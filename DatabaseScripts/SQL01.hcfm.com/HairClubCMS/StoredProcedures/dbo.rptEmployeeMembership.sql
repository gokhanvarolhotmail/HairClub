/*===============================================================================================
 Procedure Name:            [rptEmployeeMembership]
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              03/30/2020
 Destination Server:        SQL01.HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**

===============================================================================================
CHANGE HISTORY:

================================================================================================
SAMPLE EXECUTION:

EXEC [rptEmployeeMembership] 'C','4/1/2020','4/29/2020', 3

EXEC [rptEmployeeMembership] 'F','4/1/2020','4/29/2020', 1
================================================================================================
*/

CREATE PROCEDURE [dbo].[rptEmployeeMembership] (
	@sType CHAR(1)
,	@Month INT
,	@Year INT
,	@Filter INT
)


/*
	@Filter
	-------
	1 = By Region for Franchise
	2 = By Area Manager
	3 = By Center
*/
AS
BEGIN


/**************Find StartDate and EndDate ******************************************/

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate = CAST((CAST(@Month AS CHAR(2)) + '/1/' + CAST(@Year AS CHAR(4))) AS DATE)
SET @EndDate = DATEADD(MINUTE,-1,DATEADD(MONTH,1,@StartDate))

PRINT @StartDate
PRINT @EndDate

/******* Set variables for employee prices ****************************************/
DECLARE @ServiceAmtPercent DECIMAL(18,4)
DECLARE @EmployeeAdjustPercent DECIMAL(18,4)
DECLARE @EmployeeAdjustInteger DECIMAL(18,4)

SET @ServiceAmtPercent = .80
PRINT '@ServiceAmtPercent = ' + CAST(@ServiceAmtPercent AS NVARCHAR(25))
SET @EmployeeAdjustPercent = .80
PRINT '@EmployeeAdjustPercent = ' + CAST(@EmployeeAdjustPercent AS NVARCHAR(25))
SET @EmployeeAdjustInteger = 2
PRINT '@EmployeeAdjustInteger = ' + CAST(@EmployeeAdjustInteger AS NVARCHAR(25))

/************ Create temp tables ***************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionFullCalc VARCHAR(255)
,	CenterTypeDescription NVARCHAR(20)
)

CREATE TABLE #Employees(
	ClientIdentifier INT
,   ClientGUID NVARCHAR(50)
,	ClientFullNameAltCalc NVARCHAR(103)
,	ClientFullNameAlt2Calc NVARCHAR(104)
,   ClientMembershipGUID NVARCHAR(50)
,   MembershipID INT
,   MembershipDescription NVARCHAR(60)
,   BeginDate DATETIME
,   EndDate DATETIME
,	ClientMembershipStatusID INT
,   CenterID INT
,   CenterDescriptionFullCalc NVARCHAR(50)
,   EmployeePayrollID NVARCHAR(50)
,   EmpRank INT
)


/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS MainGroupID
		,		CMA.CenterManagementAreaDescription AS MainGroup
		,		CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
		,		DC.CenterNumber
		,		DC.CenterID
		,		DC.CenterDescription
		,		DC.CenterDescriptionFullCalc
		,		CT.CenterTypeDescription
		FROM		dbo.cfgCenter DC
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = DC.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON DC.CenterManagementAreaID = CMA.CenterManagementAreaID
		WHERE		CMA.IsActiveFlag = 1
				AND CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.IsActiveFlag = 1
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupID'
		,		DC.CenterDescriptionFullCalc AS 'MainGroup'
		,		DC.CenterNumber AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterID
		,		DC.CenterDescription
		,		DC.CenterDescriptionFullCalc
		,		CT.CenterTypeDescription
		FROM    dbo.cfgCenter DC
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = DC.CenterTypeID
		WHERE	CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.IsActiveFlag = 1

END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterNumber
			,		DC.CenterID
			,		DC.CenterDescription
			,		DC.CenterDescriptionFullCalc
			,		CASE WHEN CT.CenterTypeDescription = 'Joint' THEN 'Franchise' ELSE 'Franchise' END AS 'CenterTypeDescription'
			FROM    dbo.cfgCenter DC
					INNER JOIN dbo.lkpRegion DR
						ON DC.RegionID = DR.RegionID
					INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = DC.CenterTypeID
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.IsActiveFlag = 1
END


/************************** Find employee memberships **********************************/

INSERT INTO #Employees
SELECT p.ClientIdentifier
,       p.ClientGUID
,		p.ClientFullNameAltCalc
,		p.ClientFullNameAlt2Calc
,       p.ClientMembershipGUID
,       p.MembershipID
,       p.MembershipDescription
,       p.BeginDate
,       p.EndDate
,		p.ClientMembershipStatusID
,       p.CenterID
,       p.CenterDescriptionFullCalc
,       p.EmployeePayrollID
,       p.EmpRank
FROM
(
	SELECT CLT.ClientIdentifier
	,	CLT.ClientGUID
	,	CM.ClientMembershipGUID
	,	CLT.ClientFullNameAltCalc
	,	CLT.ClientFullNameAlt2Calc
	,	CM.MembershipID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	CM.ClientMembershipStatusID
	,	CLT.CenterID
	,	#Centers.CenterDescriptionFullCalc
	,	NULL AS EmployeePayrollID
	,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientFullNameAltCalc, CM.MembershipID ORDER BY CM.EndDate DESC) AS EmpRank
	FROM dbo.datClient CLT
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
			OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
			OR CM.ClientMembershipGUID = CLT.CurrentMDPClientMembershipGUID
			OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
			OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID
			)
	INNER JOIN dbo.cfgMembership M
		ON M.MembershipID = CM.MembershipID
	INNER JOIN #Centers
		ON #Centers.CenterID = CLT.CenterID
	INNER JOIN dbo.cfgCenterMembership CMEM
		ON CMEM.MembershipID = M.MembershipID
	WHERE (M.MembershipID IN(50,51,78,282,290,309) OR M.MembershipDescription LIKE 'Employee%')
	AND CM.BeginDate <= @EndDate AND CM.EndDate >= @StartDate
	GROUP BY CLT.ClientIdentifier
	,	CLT.ClientGUID
	,	CM.ClientMembershipGUID
	,	CLT.ClientFullNameAltCalc
	,	CLT.ClientFullNameAlt2Calc
	,	CM.MembershipID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	CM.ClientMembershipStatusID
	,	CLT.CenterID
	,	#Centers.CenterDescriptionFullCalc
) p
WHERE p.EmpRank = 1
AND p.ClientMembershipStatusID = 1


/****************** Find MembershipValuationPrice ****************************************/

--Join on MembershipID, CenterID where cfgCenterMembership IsActiveFlag = 1
--Use ValuationPrice as MembershipValuationPrice


SELECT CMEM.ValuationPrice AS MembershipValuationPrice
,	EMP.ClientIdentifier
,	EMP.MembershipID
,	CMEM.CenterMembershipID
INTO #MemVP
FROM dbo.cfgCenterMembership CMEM
INNER JOIN #Employees EMP
	ON (EMP.CenterID = CMEM.CenterID AND EMP.MembershipID = CMEM.MembershipID)
WHERE CMEM.ValuationPrice IS NOT NULL
GROUP BY CMEM.ValuationPrice,
         EMP.ClientIdentifier,
         EMP.MembershipID,
         CMEM.CenterMembershipID


/****************** Find AddOnValuationPrice ********************************************/

--Use AddOnID to find AddOn description
--where IsActiveFlag = 1
--Use ValuationPrice as AddOnValuationPrice

SELECT ctrmemao.ValuationPrice AS AddOnValuationPrice
,	EMP.ClientIdentifier
,	EMP.ClientFullNameAltCalc
,	EMP.MembershipID
,	ctrmem.CenterMembershipID
,	cms.ClientMembershipStatusDescription
,	ctrmem.ValuationPrice as MembershipValue
,	ao.AddOnDescription
,	cmaos.ClientMembershipAddOnStatusDescription
,	ctrmemao.ValuationPrice as AddOnValue
INTO #AddOnVP
from #Employees EMP
	--Membership
	inner join cfgCenterMembership ctrmem on EMP.CenterID = ctrmem.CenterID AND EMP.MembershipID = ctrmem.MembershipID
	inner join lkpClientMembershipStatus cms on EMP.ClientMembershipStatusID = cms.ClientMembershipStatusID
	--Add On
	inner join datClientMembershipAddOn cmao on EMP.ClientMembershipGUID = cmao.ClientMembershipGUID
	inner join cfgAddOn ao on cmao.AddOnID = ao.AddOnID
	inner join lkpClientMembershipAddOnStatus cmaos on cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
	inner join lkpAddOnType aot on ao.AddOnTypeID = aot.AddOnTypeID
	--Add-On Valuation
	inner join cfgCenterMembershipAddOn ctrmemao on ctrmem.CenterMembershipID = ctrmemao.CenterMembershipID AND ao.AddOnID = ctrmemao.AddOnID
where	(cmaos.ClientMembershipAddOnStatusDescriptionShort IS NULL or cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active')
AND ao.AddOnDescription = 'Long Hair'  --only long hair has a dollar amount associated with it for employees
GROUP BY ctrmemao.ValuationPrice
,         EMP.ClientIdentifier
,		 EMP.ClientFullNameAltCalc
,         EMP.MembershipID
,         ctrmem.CenterMembershipID
,         cms.ClientMembershipStatusDescription
,         ctrmem.ValuationPrice
,         ao.AddOnDescription
,         cmaos.ClientMembershipAddOnStatusDescription
,         ctrmemao.ValuationPrice


/********************************** Get Service Amount *************************************/
/*Calculation for 'Service Amount' column should give a value of 80% of the default service amount
(Sales Code Level) for the FIRST service entered that is not
a.	Application
b.	Salon Visit
*/

SELECT q.CenterNumber
,       q.CenterTypeDescription
,       q.ClientIdentifier
,       q.ClientMembershipGUID
,       q.ClientFullNameAltCalc
,       q.OrderDate
,       q.InvoiceNumber
,       q.SalesCodeID
,       q.SalesCodeDescription
,       q.SalesCodeDescriptionShort
,       q.SalesCodeDepartmentDescription
,       q.SalesCodeDivisionDescription
,       q.ServiceAmt
,       q.ServiceRank
INTO #Services
FROM
(SELECT  #Centers.CenterNumber
,	#Centers.CenterTypeDescription
,	ClientIdentifier
,	E.ClientMembershipGUID
,	E.ClientFullNameAltCalc
,	SO.OrderDate
,	SO.InvoiceNumber
,	SC.SalesCodeID
,	SC.SalesCodeDescription
,	SC.SalesCodeDescriptionShort
,	DEPT.SalesCodeDepartmentDescription
,	DIV.SalesCodeDivisionDescription
,	SUM(ISNULL(SC.PriceDefault, 0)) AS 'ServiceAmt'
,	ROW_NUMBER()OVER(PARTITION BY E.ClientIdentifier ORDER BY SO.OrderDate ASC) AS ServiceRank
FROM  dbo.datSalesOrder SO
INNER JOIN #Employees E
	ON SO.ClientMembershipGUID = E.ClientMembershipGUID
INNER JOIN dbo.datSalesOrderDetail SOD
	ON SO.SalesOrderGUID = SOD.SalesOrderGUID
INNER JOIN dbo.datClientMembership CM
	ON SO.ClientMembershipGUID = CM.ClientMembershipGUID
INNER JOIN dbo.cfgCenter C
	ON CM.CenterID = C.CenterID       --KEEP HomeCenter Based
INNER JOIN #Centers
	ON C.CenterID = #Centers.CenterID
INNER JOIN dbo.cfgSalesCode SC
	ON SOD.SalesCodeID = SC.SalesCodeID
INNER JOIN dbo.cfgMembership M
	ON CM.MembershipID = M.MembershipID
INNER JOIN dbo.lkpSalesCodeDepartment DEPT
	ON DEPT.SalesCodeDepartmentID = SC.SalesCodeDepartmentID
INNER JOIN dbo.lkpSalesCodeDivision DIV
	ON DIV.SalesCodeDivisionID = DEPT.SalesCodeDivisionID
WHERE SO.OrderDate BETWEEN CM.BeginDate AND CM.EndDate  --Services within the membership
	AND DEPT.SalesCodeDivisionID = 50  --Services
	AND SC.SalesCodeDescription NOT LIKE '%Application%'
	AND SC.SalesCodeDescription NOT LIKE '%Salon%Visit%'
	AND SC.SalesCodeDescriptionShort <> 'NB1A'
	AND SC.SalesCodeDescriptionShort NOT LIKE 'APP%'
	AND SC.SalesCodeID NOT IN ( 665, 654, 393, 668 )
	AND SO.IsVoidedFlag = 0
GROUP BY #Centers.CenterNumber
,   #Centers.CenterTypeDescription
,   E.ClientIdentifier
,   E.ClientMembershipGUID
,   E.ClientFullNameAltCalc
,   SO.OrderDate
,   SO.InvoiceNumber
,   SC.SalesCodeID
,   SC.SalesCodeDescription
,   SC.SalesCodeDescriptionShort
,   DEPT.SalesCodeDepartmentDescription
,   DIV.SalesCodeDivisionDescription
)q
WHERE q.ServiceRank = 1

/****************** UPDATE with EmployeePayrollID from DimEmployee ******************/

UPDATE EMP
SET EMP.EmployeePayrollID = E.EmployeePayrollID
FROM #Employees EMP
INNER JOIN dbo.datEmployee  E
	ON E.EmployeeFullNameCalc = EMP.ClientFullNameAlt2Calc
WHERE EMP.EmployeePayrollID IS NULL

/****************************** GET FINAL DATA SET ***********************************/
SELECT p.CenterTypeDescription
,       p.MainGroupID
,       p.MainGroup
,       p.MainGroupSortOrder
,       p.CenterID
,       p.CenterDescription
,       p.CenterDescriptionFullCalc
,       p.ClientIdentifier
,       p.ClientMembershipGUID
,       p.ClientFullNameAltCalc
,       p.MembershipID
,       p.MembershipDescription
,       p.BeginDate
,       p.EndDate
,       p.EmployeePayrollID
,       p.OrderDate
,       p.InvoiceNumber
,       p.SalesCodeID
,       p.SalesCodeDescription
,       p.SalesCodeDescriptionShort
,       p.SalesCodeDepartmentDescription
,       p.SalesCodeDivisionDescription
,       p.MembershipValuationPrice
,       p.EmpMembershipAmt
,       p.AddOnValuationPrice
,       p.EmpAddOnAmt
,       p.EmpServiceAmt
,		(p.EmpServiceAmt + p.EmpMembershipAmt + p.EmpAddOnAmt) AS TotalValue
FROM
	(SELECT  CTR.CenterTypeDescription
	,	CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.MainGroupSortOrder
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	,	E.ClientIdentifier
	,	E.ClientMembershipGUID
	,	E.ClientFullNameAltCalc
	,	E.MembershipID
	,	E.MembershipDescription
	,	E.BeginDate
	,	E.EndDate
	,	E.EmployeePayrollID
	,	S.OrderDate
	,	S.InvoiceNumber
	,	S.SalesCodeID
	,	S.SalesCodeDescription
	,	S.SalesCodeDescriptionShort
	,	S.SalesCodeDepartmentDescription
	,	S.SalesCodeDivisionDescription
	--Find employee price adjustments
	,	((ISNULL(#MemVP.MembershipValuationPrice,0)/12)*@EmployeeAdjustPercent) AS MembershipValuationPrice
	,	((ISNULL(#MemVP.MembershipValuationPrice,0)/12)*@EmployeeAdjustPercent)/@EmployeeAdjustInteger AS EmpMembershipAmt
	,	ISNULL(#AddOnVP.AddOnValuationPrice,0) AS AddOnValuationPrice
	,	dbo.fxDivideDecimal(ISNULL(#AddOnVP.AddOnValuationPrice,0),@EmployeeAdjustInteger) AS EmpAddOnAmt
	,	(ISNULL(S.ServiceAmt, 0) * @ServiceAmtPercent) AS EmpServiceAmt  --80% of Service Amount  @ServiceAmtPercent
	FROM    #Employees E
	INNER JOIN #Centers CTR
		ON E.CenterID = CTR.CenterID
	LEFT OUTER JOIN #MemVP
		ON (E.ClientIdentifier = #MemVP.ClientIdentifier AND #MemVP.MembershipID = E.MembershipID)
	LEFT OUTER JOIN #AddOnVP
		ON E.ClientIdentifier = #AddOnVP.ClientIdentifier
	LEFT OUTER JOIN #Services S
		ON E.ClientIdentifier = S.ClientIdentifier
	)p
ORDER BY p.CenterDescription, p.ClientFullNameAltCalc

END
