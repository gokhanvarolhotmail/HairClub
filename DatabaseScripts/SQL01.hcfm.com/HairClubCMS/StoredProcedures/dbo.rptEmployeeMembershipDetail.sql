/*===============================================================================================
 Procedure Name:            [rptEmployeeMembershipDetail]
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

EXEC [rptEmployeeMembershipDetail] 298,'1/1/2020','2/29/2020'

EXEC [rptEmployeeMembershipDetail] 804,'2/1/2020','2/29/2020'
================================================================================================
*/

CREATE PROCEDURE [dbo].[rptEmployeeMembershipDetail] (
	@CenterID INT
,	@begdt DATETIME
,	@enddt DATETIME
)

AS
BEGIN

/*
	@Filter
	-------
	1 = By Region for Franchise
	2 = By Area Manager
	3 = By Center
*/

/************ Create temp tables ***************************************************/

CREATE TABLE #Centers (
	CenterTypeDescription NVARCHAR(20)
,	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionFullCalc VARCHAR(255)
)


/********************************** Get list of centers *************************************/


INSERT  INTO #Centers
		SELECT  CT.CenterTypeDescription
		,		CASE WHEN CT.CenterTypeDescriptionShort IN('C') THEN CMA.CenterManagementAreaID
					WHEN CT.CenterTypeDescriptionShort IN('F','JV') THEN R.RegionID
					ELSE ''
					END AS MainGroupID
		,		CASE WHEN CT.CenterTypeDescriptionShort IN('C') THEN CMA.CenterManagementAreaDescription
					WHEN CT.CenterTypeDescriptionShort IN('F','JV') THEN R.RegionDescription
					ELSE ''
					END AS MainGroup
		,		CASE WHEN CT.CenterTypeDescriptionShort IN('C','HW') THEN CMA.CenterManagementAreaSortOrder
					WHEN CT.CenterTypeDescriptionShort IN('F','JV') THEN R.RegionSortOrder
					ELSE ''
					END AS MainGroupSortOrder
		,		DC.CenterNumber
		,		DC.CenterID
		,		DC.CenterDescription
		,		DC.CenterDescriptionFullCalc
		FROM		dbo.cfgCenter DC
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = DC.CenterTypeID
				LEFT JOIN dbo.cfgCenterManagementArea CMA
					ON DC.CenterManagementAreaID = CMA.CenterManagementAreaID
				LEFT JOIN dbo.lkpRegion R
					ON R.RegionID = DC.RegionID
		WHERE	DC.CenterID = @CenterID
				AND CT.CenterTypeDescriptionShort IN('C','HW','F','JV')
				AND DC.IsActiveFlag = 1


/************************** Find employee memberships **********************************/

SELECT p.ClientIdentifier
,       p.ClientGUID
,       p.ClientMembershipGUID
,       p.ClientFullNameAltCalc
,       p.MembershipID
,       p.MembershipDescription
,       p.BeginDate
,       p.EndDate
,       p.RevenueGroupDescription
,       p.BusinessSegmentDescription
,       p.CenterID
,       p.CenterDescriptionFullCalc
,       p.EmployeePayrollID
,       p.EmpRank
INTO #Employees
FROM
(
	SELECT CLT.ClientIdentifier
	,	CLT.ClientGUID
	,	CM.ClientMembershipGUID
	,	CLT.ClientFullNameAltCalc
	,	CM.MembershipID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	RG.RevenueGroupDescription
	,	BS.BusinessSegmentDescription
	,	E.CenterID
	,	#Centers.CenterDescriptionFullCalc
	,	E.EmployeePayrollID
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
	LEFT JOIN dbo.datEmployee E
		ON E.EmployeeFullNameCalc = CLT.ClientFullNameAlt2Calc
	INNER JOIN #Centers
		ON #Centers.CenterID = E.CenterID
	INNER JOIN dbo.lkpBusinessSegment BS
		ON BS.BusinessSegmentID = M.BusinessSegmentID
	INNER JOIN dbo.lkpRevenueGroup RG
		ON RG.RevenueGroupID = M.RevenueGroupID
	INNER JOIN dbo.cfgCenterMembership CMEM
		ON CMEM.MembershipID = M.MembershipID
	WHERE E.CenterID = @CenterID
		AND (M.MembershipID IN(50,51,78,282,290,309) OR M.MembershipDescription LIKE 'Employee%')
		AND E.IsActiveFlag = 1
		AND CM.EndDate >= @enddt
	GROUP BY CLT.ClientIdentifier
	,	CLT.ClientGUID
	,	CM.ClientMembershipGUID
	,	CLT.ClientFullNameAltCalc
	,	CM.MembershipID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	RG.RevenueGroupDescription
	,	BS.BusinessSegmentDescription
	,	E.CenterID
	,	#Centers.CenterDescriptionFullCalc
	,	E.EmployeePayrollID
) p
WHERE p.EmpRank = 1


/****************** Find MembershipValuationPrice ****************************************/

--Join on MembershipID, CenterID where cfgCenterMembership IsActiveFlag = 1
--Use ValuationPrice as MembershipValuationPrice

SELECT  CMEM.CenterID
,	CMEM.ValuationPrice AS MembershipValuationPrice
,	EMP.ClientIdentifier
,	EMP.MembershipID
,	CMEM.CenterMembershipID
INTO #MemVP
FROM dbo.cfgCenterMembership CMEM
INNER JOIN #Employees EMP
	ON (EMP.CenterID = CMEM.CenterID AND EMP.MembershipID = CMEM.MembershipID)
WHERE CMEM.CenterID = @CenterID
	AND CMEM.IsActiveFlag = 1
	AND CMEM.ValuationPrice IS NOT NULL
GROUP BY CMEM.CenterID
,	CMEM.ValuationPrice
,	EMP.ClientIdentifier
,	EMP.MembershipID
,	CMEM.CenterMembershipID


/****************** Find AddOnValuationPrice ********************************************/

--Use AddOnID to find AddOn description
--where IsActiveFlag = 1
--Use ValuationPrice as AddOnValuationPrice
--JOIN to cfgCenterMembership with CenterMembershipID

SELECT CMEM.CenterID
,	ADDON.ValuationPrice AS AddOnValuationPrice
,	EMP.ClientIdentifier
,	EMP.MembershipID
,	CMEM.CenterMembershipID
INTO #AddOnVP
FROM dbo.cfgCenterMembershipAddOn ADDON
INNER JOIN dbo.cfgCenterMembership CMEM
	ON CMEM.CenterMembershipID = ADDON.CenterMembershipID
INNER JOIN #Employees EMP
	ON EMP.CenterID = CMEM.CenterID
WHERE  CMEM.CenterID = @CenterID
	AND ADDON.IsActiveFlag = 1
	AND ADDON.ValuationPrice IS NOT NULL
GROUP BY CMEM.CenterID
,	ADDON.ValuationPrice
,	EMP.ClientIdentifier
,	EMP.MembershipID
,	CMEM.CenterMembershipID


/********************************** Get Service Amount *************************************/

SELECT  #Centers.CenterNumber
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
INTO #Services
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
WHERE SO.OrderDate BETWEEN @begdt AND @enddt
		AND DEPT.SalesCodeDivisionID = 50  --Services
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



/****************************** GET FINAL DATA SET ***********************************/

SELECT  CTR.CenterTypeDescription AS 'Type'
,	CTR.MainGroupID
,	CTR.MainGroup
,	CTR.MainGroupSortOrder
,	CTR.CenterID
,	CTR.CenterDescription
,	CTR.CenterDescriptionFullCalc AS 'Center'
,	E.ClientIdentifier
,	E.ClientFullNameAltCalc
,	E.MembershipID
,	E.MembershipDescription
,	E.BeginDate
,	E.EndDate
,	E.RevenueGroupDescription
,	E.BusinessSegmentDescription
,	E.EmployeePayrollID
,	ISNULL(#MemVP.MembershipValuationPrice,0) AS MembershipValuationPrice
,	ISNULL(#AddOnVP.AddOnValuationPrice,0) AS AddOnValuationPrice
,	S.OrderDate
,	S.InvoiceNumber
,	S.SalesCodeID
,	S.SalesCodeDescription
,	S.SalesCodeDescriptionShort
,	S.SalesCodeDepartmentDescription
,	S.SalesCodeDivisionDescription
,	ISNULL(S.ServiceAmt, 0) AS 'ServiceAmt'
FROM    #Employees E
INNER JOIN #Centers CTR
	ON E.CenterID = CTR.CenterID
LEFT OUTER JOIN #MemVP
	ON (E.ClientIdentifier = #MemVP.ClientIdentifier AND #MemVP.MembershipID = E.MembershipID)
LEFT OUTER JOIN #AddOnVP
	ON E.ClientIdentifier = #AddOnVP.ClientIdentifier
LEFT OUTER JOIN #Services S
	ON E.ClientIdentifier = S.ClientIdentifier


END
