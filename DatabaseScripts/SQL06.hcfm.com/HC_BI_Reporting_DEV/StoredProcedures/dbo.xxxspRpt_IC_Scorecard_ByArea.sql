/***********************************************************************
PROCEDURE:				[spRpt_IC_Scorecard_ByArea]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[IC_Scorecard]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		04/25/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
CHANGE HISTORY:
05/03/2019 - RH - Added Surgery(#) Actual and Budget (AccountID 10220); Moved #Sales with GROUP BY to the ContractPrice section

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_IC_Scorecard_ByArea]  '207, 208, 209, 210, 212, 259, 268, 282, 222, 223, 224, 254, 269, 273, 298, 297'
EXEC [spRpt_IC_Scorecard_ByArea]  '242'
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_IC_Scorecard_ByArea]
(
	@CenterNumber NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;

/************** Declare and set variables **********************************************************************/

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @BeginningOfTheYear DATETIME
DECLARE @BeginningOfThePreviousYear DATETIME
DECLARE @BeginningOfThisMonth DATETIME
DECLARE @BeginningOfThePreviousMonth DATETIME


DECLARE @Today DATETIME = CURRENT_TIMESTAMP;

SET @BeginningOfTheYear = CAST('1/1/' + CAST(YEAR(@Today)AS NVARCHAR(4)) AS DATETIME)
SET @BeginningOfThePreviousYear = DATEADD(YEAR,-1,@BeginningOfTheYear)
SET @BeginningOfThisMonth = CAST(CAST(MONTH(@Today) AS VARCHAR(2)) + '/1/' + CAST(YEAR(@Today) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SET @BeginningOfThePreviousMonth = DATEADD(MONTH,-1,@BeginningOfThisMonth)


--If @Today is the beginning of the month, then set @StartDate to the first day of last month and set @EndDate to yesterday at 11:59 PM

IF @BeginningOfThisMonth = CAST(@Today AS DATE)
BEGIN
SET @StartDate = @BeginningOfThePreviousMonth
SET @EndDate = DATEADD(DAY,-1,CAST(@Today AS DATE))
END
ELSE
BEGIN
SET @StartDate = @BeginningOfThisMonth
SET @EndDate = CAST(@Today AS DATE)
END


DECLARE @MonthWorkdaysTotal INT
DECLARE @CummWorkdays INT
SET @MonthWorkdaysTotal = (SELECT MonthWorkdaysTotal FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @StartDate)
SET @CummWorkdays = (SELECT CummWorkdays FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @EndDate)


DECLARE @DaysRemaining INT
SET @DaysRemaining = @MonthWorkdaysTotal - @CummWorkdays

DECLARE @ClosingBudget DECIMAL(18,4)				--Percent
DECLARE @AvgSalePriceBudget DECIMAL(18,4)			--Money

SET @ClosingBudget = .45
SET @AvgSalePriceBudget = 3000


/********** Create temp tables ******************************************************************************/

CREATE TABLE #CenterNumber (
	CenterNumber INT
	)



CREATE TABLE #Employee(
	EmployeeKey INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeePositionSSID NVARCHAR(50)
,	EmployeePositionDescription NVARCHAR(50)
,	EmployeeFullName NVARCHAR(102)
,	EmployeeFirstName NVARCHAR(50)
,	EmployeeLastName NVARCHAR(50)
,	EmployeeInitials NVARCHAR(5)
,	UserLogin NVARCHAR(50)
,	CenterNumber INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	AreaManager NVARCHAR(102)
)



CREATE TABLE #NB1A(
	NB1A DATETIME
,	SalesOrderDetailKey INT
,	SalesOrderKey INT
,	SalesCodeDescription NVARCHAR(150)
,	SalesCodeDescriptionShort NVARCHAR(50)
,	Quantity INT
,	Employee1Initials NVARCHAR(10)
,	CenterKey INT
,	ClientKey INT
,	EmployeeKey INT
)


CREATE TABLE #INITASG(
	FullDate DATETIME
,	ClientKey INT
,	CenterKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	EmployeeKey INT
,	Quantity INT
,	SalesCodeDescriptionShort NVARCHAR(50)
,	MembershipDescription NVARCHAR(150)
,	BusinessSegmentSSID INT
)


CREATE TABLE #NBSalesWithApps(
	EmployeeKey INT
,	Quantity INT
)


CREATE TABLE #SUM_Sales(
	EmployeeKey INT
,	Employee1FullName NVARCHAR(102)
,	NetNB1Count	INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_EXTAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XTRAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


CREATE TABLE #CenterManager(
	CenterNumber INT
,	CenterManagementAreaSSID INT
,	CenterManager NVARCHAR(102)
,	EmployeePositionDescription NVARCHAR(50)
,	ConsultationBudget INT
,	NB1SalesBudget INT
,	NB1RevenueBudget DECIMAL(18,4)
,	BudgetNewStyles INT
)



CREATE TABLE #EmployeeKey(
	EmployeeKey INT
,   EmployeeSSID NVARCHAR(50)
,   EmployeePositionSSID NVARCHAR(50)
,   EmployeePositionDescription NVARCHAR(50)
,   EmployeeFullName NVARCHAR(102)
,   EmployeeFirstName NVARCHAR(50)
,   EmployeeLastName NVARCHAR(50)
,   EmployeeInitials NVARCHAR(5)
,   UserLogin NVARCHAR(50)
,   CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,	CenterManager NVARCHAR(102)
,	CenterManagementAreaDescription NVARCHAR(50)
,	AreaManager NVARCHAR(102)
)


CREATE TABLE #NetConsultations(
	EmployeeKey INT
,	Performer NVARCHAR(102)
,	ActivityDueDate DATE
,	ActivitySSID NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
,	SolutionOffered NVARCHAR(50)
)



CREATE TABLE #NetSales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_ExtAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


CREATE TABLE #SUM_NetSales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
,	XTRPlus INT
,	NB_XPAmt DECIMAL(18,4)
,	EXT INT
,	NB_ExtAmt DECIMAL(18,4)
,	Xtrands INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)


CREATE TABLE #IC(
	CenterNumber INT
,	NumberOfIC INT
,	ConsultationBudget INT
,	ConsBudgetPerIC INT
,	SalesBudgetPerIC INT
,	RevenueBudgetPerIC DECIMAL(18,4)
,	BudgetNewStylesPerIC INT
)



CREATE TABLE #Refunds(
	Employee1Key INT
,	Refunded INT
)

CREATE TABLE #Discounts(
	Employee1Key INT
,	Discount DECIMAL(18,4)
)


CREATE TABLE #Commissions(
	EmployeeKey INT
,	EmployeePayrollID NVARCHAR(20)
,	EmployeeFullName NVARCHAR(102)
,   AdvancedCommission DECIMAL(18,4)
)

CREATE TABLE #Sales(
	EmployeeKey INT
,	Employee1FullName NVARCHAR(102)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(250)
,	ClientMembershipKey INT
,	ClientMembershipEndDate DATETIME
,	ClientMembershipContractPrice DECIMAL(18,4)
,	NB_GradCnt INT
,	NB_GradAmt DECIMAL(18,4)
,	NB_TradCnt INT
,	NB_TradAmt DECIMAL(18,4)
,	NB_ExtCnt INT
,	NB_ExtAmt DECIMAL(18,4)
,	S_PostExtCnt INT
,	S_PostExtAmt DECIMAL(18,4)
,	NB_XtrCnt INT
,	NB_XtrAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	S_SurCnt DECIMAL(18,4)
)

CREATE TABLE #ContractPrice(
	EmployeeKey INT
,   ClientKey INT
,   ClientMembershipContractPrice DECIMAL(18,4)
,   NB_GradCP INT
,   S_PostExtCP INT
,   NB_TradCP INT
,   NB_ExtCP INT
,   NB_XtrCP INT
,   S_SurCP INT
)


CREATE TABLE #SUM_ContractPrice(
	EmployeeKey INT
,	XP_Price DECIMAL(18,4)
,	EXT_Price DECIMAL(18,4)
,	XTR_Price DECIMAL(18,4)
,	SUR_Price DECIMAL(18,4)
)


CREATE TABLE #Final(
		EmployeeKey INT
,       EmployeeSSID NVARCHAR(50)
,       EmployeePositionSSID NVARCHAR(50)
,       EmployeePositionDescription NVARCHAR(50)
,       EmployeeFullName NVARCHAR(1002)
,       EmployeeFirstName NVARCHAR(50)
,       EmployeeLastName NVARCHAR(50)
,       EmployeeInitials NVARCHAR(10)
,       UserLogin NVARCHAR(50)
,       CenterNumber INT
,       CenterDescriptionNumber NVARCHAR(50)
,       NumberOfIC INT
,		ConsBudgetPerIC INT
,		SalesBudgetPerIC INT
,		RevenueBudgetPerIC DECIMAL(18,4)
,		BudgetNewStylesPerIC INT
,       CenterManager NVARCHAR(102)
,       CenterManagementAreaDescription NVARCHAR(50)
,       AreaManager NVARCHAR(102)
,		Consultations INT
,		NetNB1Count INT
,		NetNB1Revenue DECIMAL(18,4)

,		XTRPlus INT
,		NB_XPAmt DECIMAL(18,4)
,		EXT INT
,		NB_ExtAmt DECIMAL(18,4)
,		Xtrands INT
,		NB_XtrAmt DECIMAL(18,4)
,		LaserCnt INT
,		LaserAmt DECIMAL(18,4)
,		NB_MDPCnt INT
,		NB_MDPAmt DECIMAL(18,4)

,		XP_Price DECIMAL(18,4)
,		XP_Payments DECIMAL(18,4)

,		EXT_Price DECIMAL(18,4)
,		EXT_Payments DECIMAL(18,4)

,		XTR_Price DECIMAL(18,4)
,		XTR_Payments DECIMAL(18,4)

,		NSD INT
,		AdvancedCommission DECIMAL(18,4)
,		Refunded INT
,		Discount DECIMAL(18,4)
)

/*********************** Begin populating the temp tables ***********************************************************/

--Find CenterNumbers using fnSplit
INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

--Find consultants
INSERT INTO #Employee
SELECT e.EmployeeKey
,	e.EmployeeSSID
,	ep.EmployeePositionSSID
,	ep.EmployeePositionDescription
,	e.EmployeeFullName
,	e.EmployeeFirstName
,	e.EmployeeLastName
,	e.EmployeeInitials
,	e.UserLogin
,	CN.CenterNumber
,	CMA.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS AreaManager
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON CTR.CenterSSID = e.CenterSSID
	INNER JOIN #CenterNumber CN
		ON CN.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA
		ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE ep.EmployeePositionDescription LIKE 'Consultant%'
	AND e.IsActiveFlag = 1
	AND e.EmployeeFullName NOT LIKE '%Test%'

--Update records with Melissa Oakes as Area Manager where there is none
UPDATE #Employee
SET AreaManager = 'Oakes, Melissa'
WHERE CenterManagementAreaSSID IN(20,22)

--Find clients with NB1A's --Query to find Initial New Styles
INSERT INTO #NB1A
SELECT DD.FullDate AS NB1A
,	SOD.SalesOrderDetailKey
,	SOD.SalesOrderKey
,	SOD.SalesCodeDescription
,	SOD.SalesCodeDescriptionShort
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS Quantity
,	E.EmployeeInitials AS Employee1Initials
,	FST.CenterKey
,	FST.ClientKey
,	E.EmployeeKey
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON DSO.SalesOrderKey = SOD.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON SC.SalesCodeKey = FST.SalesCodeKey
LEFT JOIN #Employee E
	ON E.EmployeeKey = DSO.EmployeeKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipKey = FST.MembershipKey
WHERE DSO.OrderDate BETWEEN @StartDate AND @EndDate
AND SC.SalesCodeDescriptionShort = 'NB1A'
AND SOD.IsVoidedFlag = 0


----Then find the sales for those clients using the @BeginningOfThePreviousYear

INSERT INTO #INITASG
SELECT p.FullDate,
       p.ClientKey,
       p.CenterKey,
       p.ClientMembershipKey,
       p.MembershipKey,
       p.EmployeeKey,
       p.Quantity,
       p.SalesCodeDescriptionShort,
       p.MembershipDescription,
       p.BusinessSegmentSSID
FROM
(SELECT DD.FullDate
,	FST.ClientKey
,	FST.CenterKey
,	FST.ClientMembershipKey
,	FST.MembershipKey
,	FST.Employee1Key AS EmployeeKey
,	1 AS Quantity						--FST.Quantity will show too many for surgery
,	SC.SalesCodeDescriptionShort
,	M.MembershipDescription
,	M.BusinessSegmentSSID
FROM  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = dd.DateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
						ON fst.SalesCodeKey = sc.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON FST.SalesOrderKey = SO.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON SO.ClientMembershipKey = DCM.ClientMembershipKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
						ON DCM.MembershipKey = m.MembershipKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON DCM.CenterKey = C.CenterKey
WHERE DD.FullDate >= @BeginningOfThePreviousYear
AND SC.SalesCodeDescriptionShort  = 'INITASG'
AND FST.ClientKey IN(SELECT ClientKey FROM #NB1A)
AND SOD.IsVoidedFlag = 0
AND M.MembershipDescription NOT IN('New Client (ShowNoSale)','New Client (Surgery Offered)')
GROUP BY DD.FullDate
,	FST.ClientKey
,	FST.CenterKey
,	FST.ClientMembershipKey
,	FST.MembershipKey
,	FST.Employee1Key
,	FST.Quantity
,	SC.SalesCodeDescriptionShort
,	M.MembershipDescription
,	M.BusinessSegmentSSID
)p
GROUP BY
p.FullDate,
       p.ClientKey,
       p.CenterKey,
       p.ClientMembershipKey,
       p.MembershipKey,
       p.EmployeeKey,
       p.Quantity,
       p.SalesCodeDescriptionShort,
       p.MembershipDescription,
       p.BusinessSegmentSSID



--SUM the Quantities
INSERT INTO #NBSalesWithApps
SELECT EmployeeKey, SUM(Quantity) AS Quantity
FROM #INITASG
GROUP BY EmployeeKey



--Find the Center Manager and Budget Consultations for this month and NB1 Sales Budget

SELECT a.CenterNumber
	,	SUM(CASE WHEN a.AccountID = 10110 THEN ISNULL(a.Budget,0) ELSE 0 END) AS ConsultationBudget   --10110	Activity - Consultations #
	,	SUM(CASE WHEN a.AccountID IN (10205, 10206, 10215, 10210,  10225)THEN ISNULL(a.Budget,0) ELSE 0 END) AS NB1SalesBudget
	,	SUM(CASE WHEN a.AccountID IN (10305, 10306, 10315, 10310,  10325) THEN ISNULL(a.Budget,0) ELSE 0 END) AS NB1RevenueBudget
	,	SUM(CASE WHEN a.AccountID IN (10240) THEN ISNULL(a.Budget,0) ELSE 0 END) AS BudgetNewStyles
INTO #Budget
FROM
	(
	SELECT CTR.CenterNumber
	, FA.PartitionDate
	, FA.AccountID
	, FA.Budget
	FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterNumber
	INNER JOIN #CenterNumber CN
		ON CN.CenterNumber = CTR.CenterNumber
	WHERE FA.PartitionDate = @BeginningOfThisMonth
		AND FA.AccountID IN( 10110,10205,10206,10215,10210,10225,10305,10306,10315,10310, 10325,10240)
	) a
GROUP BY a.CenterNumber


/********* This code is to set the correct CenterManager **********************************************************/

INSERT INTO #CenterManager
SELECT  CTR.CenterNumber
			,	CTR.CenterManagementAreaSSID
			,	CASE WHEN CTR.CenterNumber = 250 THEN 'Ricky Kalra'
					WHEN CTR.CenterNumber = 292 THEN 'Alexander Gonzales'
				ELSE e.EmployeeFullName END AS CenterManager
			,	ep.EmployeePositionDescription
,	NULL AS ConsultationBudget
,	NULL AS NB1SalesBudget
,	NULL AS NB1RevenueBudget
,	NULL AS BudgetNewStyles
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	INNER JOIN #CenterNumber CN
		ON CN.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON E.CenterSSID = CTR.CenterSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ
		ON E.EmployeeSSID = EPJ.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP
		ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE
	 EP.EmployeePositionDescription LIKE 'Manager%'
	AND E.IsActiveFlag = 1
	AND E.EmployeeFullName NOT LIKE '%Test%'
	AND CTR.Active = 'Y' AND CTR.CenterNumber <> 100 AND CT.CenterTypeDescriptionShort = 'C'
	AND E.EmployeeFullName NOT IN('Ardeleanu, Raluca'  --These are inactive center managers
,	'Mondin, Raquel'
,	'Wheat, Danielle'
,	'Christy, Amy'
,	'Ambe, Mara'
,	'Vitale, Nicole'
,	'Masterson, Elizabeth'
,	'Myers, Caleena'
,	'Smith, Christopher'
,	'Rivera Herth, Ginger'
,	'Riggi, JoAnn'
,	'Holz, Jennifer'
,	'Mallard, Anthony'
,	'Wahl, Nolan'
,	'Acosta, Jancarlos'
,	'Gantt, Stacie'
,	'Zahid, Aleena'
,	'Mozafary, Mahmood'
,	'El-Dick, Joseph'
,	'Atchley, Elissa'
,	'Hitt, Erica'
,	'Wilson, Audrey'
,	'Calhoun, Rochelle'
,	'Torres, Gladys'
,	'Suddath, Sharon'
,	'Skaggs, Whittney'
,	'Lyon, Deena'
,	'Johnson, Lasandra'
,	'Spencer, Keyana'
,	'Santos, Marco'
,	'Perez, Kalena'
,	'Gonzales, Alexander'
,	'Bell, Kenya'
,	'Hickman, Natasha'
,	'Rose Baker, Deana'
,	'Johnson, Alexandrea'
)


--INSERT NULL records into #CenterManager for centers without a center manager
INSERT INTO #CenterManager
(
    CenterNumber,
    CenterManagementAreaSSID,
    EmployeePositionDescription
)
SELECT CN.CenterNumber
,	CenterManagementAreaSSID
,	'Manager' AS 'EmployeePositionDescription'
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	INNER JOIN #CenterNumber CN
	ON CN.CenterNumber = CTR.CenterNumber
WHERE CN.CenterNumber NOT IN (SELECT CenterNumber FROM #CenterManager)



UPDATE CM
SET CM.ConsultationBudget = B.ConsultationBudget
FROM #CenterManager CM
INNER JOIN #Budget B
	ON CM.CenterNumber = B.CenterNumber
WHERE CM.ConsultationBudget IS NULL

UPDATE CM
SET CM.NB1SalesBudget = B.NB1SalesBudget
FROM #CenterManager CM
INNER JOIN #Budget B
	ON CM.CenterNumber = B.CenterNumber
WHERE CM.NB1SalesBudget IS NULL

UPDATE CM
SET CM.NB1RevenueBudget = B.NB1RevenueBudget
FROM #CenterManager CM
INNER JOIN #Budget B
	ON CM.CenterNumber = B.CenterNumber
WHERE CM.NB1RevenueBudget IS NULL

UPDATE CM
SET CM.BudgetNewStyles = B.BudgetNewStyles
FROM #CenterManager CM
INNER JOIN #Budget B
	ON CM.CenterNumber = B.CenterNumber
WHERE CM.BudgetNewStyles IS NULL




--Combine these fields
INSERT INTO #EmployeeKey
SELECT  E.EmployeeKey
,       E.EmployeeSSID
,       E.EmployeePositionSSID
,       E.EmployeePositionDescription
,       E.EmployeeFullName
,       E.EmployeeFirstName
,       E.EmployeeLastName
,       E.EmployeeInitials
,       E.UserLogin
,       E.CenterNumber
,       CTR.CenterDescriptionNumber
,		CM.CenterManager
,		E.CenterManagementAreaDescription
,		E.AreaManager
FROM #Employee E
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterNumber = E.CenterNumber
INNER JOIN #CenterManager CM ON CM.CenterNumber = CTR.CenterNumber
GROUP BY E.EmployeeKey
,		E.EmployeeSSID
,		E.EmployeePositionSSID
,		E.EmployeePositionDescription
,		E.EmployeeFullName
,		E.EmployeeFirstName
,		E.EmployeeLastName
,		E.EmployeeInitials
,		E.UserLogin
,		E.CenterNumber
,		CTR.CenterDescriptionNumber
,		CM.CenterManager
,		E.CenterManagementAreaDescription
,		E.AreaManager



--Find the activities that are consultations and employees
INSERT INTO #NetConsultations
SELECT  E.EmployeeKey
,		DAD.Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS ActionCode
,		ISNULL(DA.ResultCodeDescription, '') AS ResultCode
,		CASE WHEN DAD.SolutionOffered <> '' THEN DAD.SolutionOffered ELSE DAR.SalesTypeDescription END AS SolutionOffered
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON (DC.ContactSSID = DA.ContactSSID OR (DC.ContactSSID IS NULL AND DC.SFDC_LeadID = DA.SFDC_LeadID)) AND DC.CreationDate >= @BeginningOfThePreviousYear --To limit this join
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
			ON (DAR.ActivitySSID = DA.ActivitySSID OR (DAR.ActivitySSID IS NULL AND DAR.SFDC_TaskID = DA.SFDC_TaskID))
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
			ON (DAD.ActivitySSID = DA.ActivitySSID OR (DAD.ActivitySSID IS NULL AND DAD.SFDC_TaskID = DA.SFDC_TaskID))
		INNER JOIN #Employee E
			--ON FAR.ActivityEmployeeKey = E.EmployeeKey --These employees are from the NCC
			ON DAD.Performer = E.EmployeeFullName
WHERE   DA.ActivityDueDate BETWEEN @StartDate AND @EndDate
		AND FAR.Consultation = 1
		AND DAD.Performer IN(SELECT EmployeeFullName FROM #Employee)



----Find the Sales

--INSERT INTO #Sales
--SELECT FST.Employee1Key AS EmployeeKey
--,		SOD.Employee1FullName
--,		FST.ClientKey
--,		CLT.ClientIdentifier
--,		CLT.ClientFullName
--,		CM.ClientMembershipKey
--,		CM.ClientMembershipEndDate
--,		CM.ClientMembershipContractPrice
--,		FST.NB_GradCnt
--,		FST.NB_GradAmt

--,       FST.NB_TradCnt
--,       FST.NB_TradAmt

--,       FST.NB_ExtCnt
--,       FST.NB_ExtAmt

--,		FST.S_PostExtCnt
--,		FST.S_PostExtAmt

--,       FST.NB_XtrCnt
--,       FST.NB_XtrAmt
--,       FST.LaserCnt
--,       FST.LaserAmt
--,       FST.NB_MDPCnt
--,       FST.NB_MDPAmt
--FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
--        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--            ON FST.OrderDateKey = dd.DateKey
--		INNER JOIN #Employee E
--			ON FST.Employee1Key = E.EmployeeKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
--            ON fst.SalesCodeKey = DSC.SalesCodeKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
--			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
--			ON FST.SalesOrderKey = SO.SalesOrderKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
--			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
--			ON SO.ClientMembershipKey = CM.ClientMembershipKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
--            ON cm.MembershipKey = m.MembershipKey
--        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--            ON cm.CenterKey = c.CenterKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
--			ON FST.ClientKey = CLT.ClientKey
--WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
--        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
--        AND SO.IsVoidedFlag = 0
--		AND m.RevenueGroupDescription = 'New Business'
--		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
--		AND DSCD.SalesCodeDivisionSSID IN(10,20)

-- GROUP BY FST.Employee1Key
--,		SOD.Employee1FullName
--,		FST.ClientKey
--,		CLT.ClientIdentifier
--,		CLT.ClientFullName
--,		CM.ClientMembershipKey
--,		CM.ClientMembershipEndDate
--,		CM.ClientMembershipContractPrice
--,		FST.NB_GradCnt
--,		FST.NB_GradAmt
--,		FST.NB_TradCnt
--,		FST.NB_TradAmt
--,		FST.NB_ExtCnt
--,		FST.NB_ExtAmt
--,		FST.S_PostExtCnt
--,		FST.S_PostExtAmt
--,		FST.NB_XTRCnt
--,		FST.NB_XTRAmt
--,		FST.LaserCnt
--,		FST.LaserAmt
--,       FST.NB_MDPCnt
--,       FST.NB_MDPAmt




--Find the Sales
INSERT INTO #SUM_Sales
SELECT  FST.Employee1Key
,		SOD.Employee1FullName
,		SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.NB_XtrCnt, 0))
        + SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_MDPCnt,0))
        + SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0)) AS 'NetNB1Count'
,       SUM(ISNULL(FST.NB_TradAmt, 0))
		+ SUM(ISNULL(FST.NB_ExtAmt, 0))
		+ SUM(ISNULL(FST.NB_XtrAmt, 0))
        + SUM(ISNULL(FST.NB_GradAmt, 0))
		+ SUM(ISNULL(FST.NB_MDPAmt,0))
        + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'NetNB1Revenue'
,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XTRPlus'
,       SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NB_XPAmt'
,       SUM(ISNULL(FST.NB_ExtCnt, 0)) +  SUM(ISNULL(FST.S_PostExtCnt, 0)) AS EXT
,       SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS NB_ExtAmt
,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS Xtrands
,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS NB_XtrAmt
,       SUM(ISNULL(FST.LaserCnt, 0)) AS LaserCnt
,       SUM(ISNULL(FST.LaserAmt, 0)) AS LaserAmt
,       SUM(ISNULL(FST.NB_MDPCnt, 0)) AS NB_MDPCnt
,       SUM(ISNULL(FST.NB_MDPAmt, 0)) AS NB_MDPAmt
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Employee E
			ON FST.Employee1Key = E.EmployeeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
		AND m.RevenueGroupDescription = 'New Business'
		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
		AND DSCD.SalesCodeDivisionSSID IN(10,20)
GROUP BY FST.Employee1Key
 ,       SOD.Employee1FullName


--Join both sets of data with a UNION
INSERT INTO #NetSales
SELECT 	EK.EmployeeKey
,	NC.Performer AS EmployeeFullName
,	SUM(CASE WHEN NC.ActionCode = 'Appointment' THEN 1 ELSE 0 END) AS Consultations
,	0 AS NetNB1Count
,	0 AS NetNB1Revenue
,	0 AS XTRPlus
,	0 AS NB_XPAmt
,	0 AS EXT
,	0 AS NB_ExtAmt
,	0 AS Xtrands
,	0 AS NB_XtrAmt
--,	0 AS Surgery
,	0 AS LaserCnt
,	0 AS LaserAmt
,	0 AS NB_MDPCnt
,	0 AS NB_MDPAmt
FROM #EmployeeKey EK
INNER JOIN #NetConsultations NC
	ON NC.EmployeeKey = EK.EmployeeKey
GROUP BY EK.EmployeeKey
,	NC.Performer
UNION
SELECT 	EK.EmployeeKey
,	S.Employee1FullName AS EmployeeFullName
,	0 AS Consultations
,	S.NetNB1Count
,	S.NetNB1Revenue
,	S.XTRPlus
,	S.NB_XPAmt
,	S.EXT
,	S.NB_ExtAmt
,	S.Xtrands
,	S.NB_XtrAmt
,	S.LaserCnt
,	S.LaserAmt
,	S.NB_MDPCnt
,	S.NB_MDPAmt
FROM #EmployeeKey EK
INNER JOIN #SUM_Sales S
	ON EK.EmployeeKey = S.EmployeeKey
GROUP BY EK.EmployeeKey
,	S.Employee1FullName
,	S.NetNB1Count
,	S.NetNB1Revenue
,	S.XTRPlus
,	S.NB_XPAmt
,	S.EXT
,	S.NB_ExtAmt
,	S.Xtrands
,	S.NB_XtrAmt
,	S.LaserCnt
,	S.LaserAmt
,	S.NB_MDPCnt
,	S.NB_MDPAmt



--SUM the results
INSERT INTO #SUM_NetSales
SELECT 	NS.EmployeeKey
,	NS.EmployeeFullName
,	SUM(Consultations) AS Consultations
,	SUM(NetNB1Count) AS NetNB1Count
,	SUM(NetNB1Revenue) AS NetNB1Revenue
,	SUM(XTRPlus) AS XTRPlus
,	SUM(NB_XPAmt) AS NB_XPAmt
,	SUM(EXT) AS EXT
,	SUM(NB_ExtAmt) AS NB_ExtAmt
,	SUM(Xtrands) AS Xtrands
,	SUM(NB_XtrAmt) AS NB_XtrAmt
,	SUM(LaserCnt) AS LaserCnt
,	SUM(LaserAmt) AS LaserAmt
,	SUM(NB_MDPCnt) AS NB_MDPCnt
,	SUM(NB_MDPAmt) AS NB_MDPAmt
FROM #NetSales NS
GROUP BY NS.EmployeeKey
,	NS.EmployeeFullName



--Find the number of active IC's in this timeframe for the center
INSERT INTO #IC
SELECT EK.CenterNumber AS CenterNumber
,	COUNT(S.EmployeeKey) AS NumberOfIC
,	MAN.ConsultationBudget
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.ConsultationBudget/COUNT(S.EmployeeKey)) END AS ConsBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.NB1SalesBudget/COUNT(S.EmployeeKey)) END AS SalesBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.NB1RevenueBudget/COUNT(S.EmployeeKey)) END AS RevenueBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (MAN.BudgetNewStyles/COUNT(S.EmployeeKey)) END AS BudgetNewStylesPerIC
FROM #SUM_Sales S
INNER JOIN #EmployeeKey EK
	ON S.EmployeeKey = EK.EmployeeKey
INNER JOIN #CenterManager MAN
	ON EK.CenterNumber = MAN.CenterNumber
WHERE S.NetNB1Revenue > 0
GROUP BY EK.CenterNumber
,       MAN.ConsultationBudget
,		MAN.NB1SalesBudget
,		MAN.NB1RevenueBudget
,		MAN.BudgetNewStyles


/************* Find Refunds - one per day per client ***********************************************************************/


INSERT INTO #Refunds
SELECT q.Employee1Key
,	SUM(ISNULL(q.Refunded,0)) AS Refunded
FROM (
		SELECT  FST.Employee1Key
		,	SOD.Employee1FullName
		,	DD.FullDate
		,	FST.Discount
		,	CASE WHEN SO.IsRefundedFlag = 0 THEN 0 ELSE 1 END AS Refunded
		,	SC.SalesCodeDescription
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	m.BusinessSegmentDescription
		,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier, DD.FullDate ORDER BY DD.FullDate DESC) AS Ranking
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN #Employee E
					ON FST.Employee1Key = E.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipKey = m.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON cm.CenterKey = c.CenterKey
				INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
				AND SO.IsVoidedFlag = 0
				AND SO.IsRefundedFlag = 1
				AND (SC.SalesCodeDescription LIKE 'Payment - Membership%' OR SC.SalesCodeDescription IN('Assign Membership','Transfer Member In','Transfer Member Out'))
				AND m.RevenueGroupDescription = 'New Business'
)q
WHERE Ranking = 1
GROUP BY q.Employee1Key


/************* Find SUM of Discounts ***********************************************************************/

INSERT INTO #Discounts
SELECT q.Employee1Key
,	SUM(ISNULL(q.Discount,0)) AS Discount
FROM (
		SELECT  FST.Employee1Key
		,	SOD.Employee1FullName
		,	DD.FullDate
		,	FST.Discount
		,	CASE WHEN SO.IsRefundedFlag = 0 THEN 0 ELSE 1 END AS Refunded
		,	SO.InvoiceNumber
		,	SC.SalesCodeDescription
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	m.BusinessSegmentDescription
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN #Employee E
					ON FST.Employee1Key = E.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipKey = m.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON cm.CenterKey = c.CenterKey
				INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
								ON FST.ClientKey = CLT.ClientKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
				AND SO.IsVoidedFlag = 0
				AND FST.Discount <> 0
				AND (SC.SalesCodeDescription LIKE 'Payment - Membership%' OR SC.SalesCodeDescription IN('Assign Membership','Transfer Member In','Transfer Member Out'))
				AND m.RevenueGroupDescription = 'New Business'
)q
GROUP BY q.Employee1Key



--Find the AdvancedCommission by Employee

INSERT INTO #Commissions
SELECT fch.EmployeeKey
,	fch.EmployeePayrollID
,	fch.EmployeeFullName
,	SUM(fch.AdvancedCommission) AS 'AdvancedCommission'
FROM   HC_Commission.dbo.vw_FactCommissionHeader fch
WHERE  fch.AdvancedCommissionDate BETWEEN @StartDate AND @EndDate
              AND fch.[Role] = 'Image Consultant'
			  AND fch.EmployeeKey IN(SELECT EmployeeKey FROM #EmployeeKey)
GROUP BY fch.EmployeeKey
,	fch.EmployeePayrollID
,	fch.EmployeeFullName

/******Find the ClientMembershipContractPrice ********************************************************/

-- Find the Sales in order to find the contract price

INSERT INTO #Sales
SELECT FST.Employee1Key AS EmployeeKey
,		SOD.Employee1FullName
,		FST.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CM.ClientMembershipKey
,		CM.ClientMembershipEndDate
,		CM.ClientMembershipContractPrice
,		FST.NB_GradCnt
,		FST.NB_GradAmt
,       FST.NB_TradCnt
,       FST.NB_TradAmt
,       FST.NB_ExtCnt
,       FST.NB_ExtAmt
,		FST.S_PostExtCnt
,		FST.S_PostExtAmt
,       FST.NB_XtrCnt
,       FST.NB_XtrAmt
,       FST.LaserCnt
,       FST.LaserAmt
,       FST.NB_MDPCnt
,       FST.NB_MDPAmt
,		FST.S_SurCnt
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Employee E
			ON FST.Employee1Key = E.EmployeeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON fst.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSCD.SalesCodeDepartmentKey = DSC.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON cm.MembershipKey = m.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
 GROUP by   FST.Employee1Key
,		SOD.Employee1FullName
,		FST.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CM.ClientMembershipKey
,		CM.ClientMembershipEndDate
,		CM.ClientMembershipContractPrice
,		FST.NB_GradCnt
,		FST.NB_GradAmt
,		FST.NB_TradCnt
,		FST.NB_TradAmt
,		FST.NB_ExtCnt
,		FST.NB_ExtAmt
,		FST.S_PostExtCnt
,		FST.S_PostExtAmt
,		FST.NB_XTRCnt
,		FST.NB_XTRAmt
,		FST.LaserCnt
,		FST.LaserAmt
,       FST.NB_MDPCnt
,       FST.NB_MDPAmt
,		FST.S_SurCnt


INSERT INTO #ContractPrice
SELECT EmployeeKey
,		ClientKey
,		ClientMembershipContractPrice
,		(NB_GradCnt * ClientMembershipContractPrice) AS NB_GradCP
,		(S_PostExtCnt * ClientMembershipContractPrice) AS S_PostExtCP
,       (NB_TradCnt * ClientMembershipContractPrice) AS NB_TradCP
,       (NB_ExtCnt * ClientMembershipContractPrice) AS NB_ExtCP
,       (NB_XtrCnt * ClientMembershipContractPrice) AS NB_XtrCP
,       (S_SurCnt * ClientMembershipContractPrice) AS S_SurCP
FROM #Sales
WHERE (NB_GradCnt <> 0
	OR	S_PostExtCnt <> 0
	OR  NB_TradCnt	 <> 0
	OR  NB_ExtCnt	 <> 0
	OR  NB_XtrCnt	 <> 0
	OR  S_SurCnt <> 0
)

INSERT INTO #SUM_ContractPrice
SELECT EmployeeKey
,	SUM(NB_GradCP) + SUM(NB_TradCP) AS XP_Price
,	SUM(S_PostExtCP) + SUM(NB_ExtCP) AS EXT_Price
,	SUM(NB_XtrCP) AS XTR_Price
,	SUM(S_SurCP) AS SUR_Price
FROM #ContractPrice
GROUP BY EmployeeKey




/******** Final select *******************************************************************/


INSERT INTO #Final
SELECT EK.EmployeeKey
,       EK.EmployeeSSID
,       EK.EmployeePositionSSID
,       EK.EmployeePositionDescription
,       EK.EmployeeFullName
,       EK.EmployeeFirstName
,       EK.EmployeeLastName
,       EK.EmployeeInitials

,       EK.UserLogin
,       EK.CenterNumber
,       EK.CenterDescriptionNumber
,       MAX(IC.NumberOfIC) AS NumberOfIC
,		MAX(IC.ConsBudgetPerIC) AS ConsBudgetPerIC
,		MAX(IC.SalesBudgetPerIC) AS SalesBudgetPerIC
,		MAX(IC.RevenueBudgetPerIC) AS RevenueBudgetPerIC
,		MAX(IC.BudgetNewStylesPerIC) AS BudgetNewStylesPerIC

,       EK.CenterManager
,       EK.CenterManagementAreaDescription
,       EK.AreaManager
,		ISNULL(NS.Consultations,0) AS Consultations
,		ISNULL(NS.NetNB1Count,0) AS NetNB1Count
,		ISNULL(NS.NetNB1Revenue,0) AS NetNB1Revenue

,		ISNULL(NS.XTRPlus,0) AS XTRPlus
,		ISNULL(NS.NB_XPAmt,0) AS NB_XPAmt
,		ISNULL(NS.EXT,0) AS EXT
,		ISNULL(NS.NB_ExtAmt,0) AS NB_ExtAmt
,		ISNULL(NS.Xtrands,0) AS Xtrands
,		ISNULL(NS.NB_XtrAmt,0) AS NB_XtrAmt
,		ISNULL(NS.LaserCnt,0) AS LaserCnt
,		ISNULL(NS.LaserAmt,0) AS LaserAmt
,		ISNULL(NS.NB_MDPCnt,0) AS NB_MDPCnt
,		ISNULL(NS.NB_MDPAmt,0) AS NB_MDPAmt


,		ISNULL(CP.XP_Price,0) AS XP_Price
,		ISNULL(NS.NB_XPAmt,0) AS XP_Payments

,		ISNULL(CP.EXT_Price,0) AS EXT_Price
,		ISNULL(NS.NB_EXTAmt,0) AS EXT_Payments

,		ISNULL(CP.XTR_Price,0) AS XTR_Price
,		ISNULL(NS.NB_XtrAmt,0) AS XTR_Payments

,		ISNULL(Apps.Quantity,0) AS NSD
,		ISNULL(COM.AdvancedCommission,0) AS AdvancedCommission
,		ISNULL(R.Refunded,0) AS Refunded
,		ISNULL(D.Discount,0) AS Discount

FROM #EmployeeKey EK
INNER JOIN #SUM_NetSales NS
	ON EK.EmployeeKey = NS.EmployeeKey
INNER JOIN #IC IC
	ON IC.CenterNumber = EK.CenterNumber
LEFT JOIN #INITASG INI
	ON	INI.EmployeeKey = EK.EmployeeKey
LEFT JOIN #NBSalesWithApps Apps
	ON EK.EmployeeKey = Apps.EmployeeKey
LEFT JOIN #Refunds R
	ON EK.EmployeeKey = R.Employee1Key
LEFT JOIN #Discounts D
	ON EK.EmployeeKey = D.Employee1Key
LEFT JOIN #Commissions COM
	ON EK.EmployeeKey = COM.EmployeeKey
LEFT JOIN #SUM_ContractPrice CP
	ON CP.EmployeeKey = EK.EmployeeKey
GROUP BY EK.EmployeeKey
,		EK.EmployeeSSID
,		EK.EmployeePositionSSID
,		EK.EmployeePositionDescription
,		EK.EmployeeFullName
,		EK.EmployeeFirstName
,		EK.EmployeeLastName
,		EK.EmployeeInitials
,		EK.UserLogin
,		EK.CenterNumber
,		EK.CenterDescriptionNumber
,		EK.CenterManager
,		EK.CenterManagementAreaDescription
,		EK.AreaManager
,		NS.Consultations
,		NS.NetNB1Count
,		NS.NetNB1Revenue

,		NS.XTRPlus
,		NS.NB_XPAmt
,		NS.EXT
,		NS.NB_ExtAmt
,		NS.Xtrands
,		NS.NB_XtrAmt
,		NS.LaserCnt
,		NS.LaserAmt
,		NS.NB_MDPCnt
,		NS.NB_MDPAmt

,		CP.XP_Price

,		CP.EXT_Price

,		CP.XTR_Price


,		Apps.Quantity
,		ISNULL(COM.AdvancedCommission,0)
,		R.Refunded
,		D.Discount



/********** Last select  ******************************/

SELECT EmployeeKey
,       EmployeeSSID
,       EmployeePositionSSID
,       EmployeePositionDescription
,       EmployeeFullName
,       EmployeeFirstName
,       EmployeeLastName
,       EmployeeInitials
,       UserLogin
,       CenterNumber
,       CenterDescriptionNumber
,       NumberOfIC
,       ConsBudgetPerIC
,       SalesBudgetPerIC
,		RevenueBudgetPerIC
,		BudgetNewStylesPerIC
,       CenterManager
,       CenterManagementAreaDescription
,       AreaManager
,       Consultations
,       NetNB1Count
,       NetNB1Revenue

,		XTRPlus
,		NB_XPAmt
,		EXT
,		NB_ExtAmt
,		Xtrands
,		NB_XtrAmt
,		LaserCnt
,		LaserAmt
,		NB_MDPCnt
,		NB_MDPAmt

,		XP_Price
,		XP_Payments
,		EXT_Price
,		EXT_Payments
,		XTR_Price
,		XTR_Payments

,       NSD
,       AdvancedCommission
,       Refunded
,       Discount
,		@DaysRemaining AS DaysRemaining
,		RevenueBudgetPerIC - (XP_Payments + EXT_Payments + XTR_Payments) AS DollarsRemaining
,		CASE WHEN @DaysRemaining = 0 THEN 0 ELSE ((RevenueBudgetPerIC - (XP_Payments + EXT_Payments + XTR_Payments))/@DaysRemaining) END AS DollarsPerDay
,		@AvgSalePriceBudget AS AvgSalePriceBudget
,		@ClosingBudget AS ClosingBudget
,		dbo.DIVIDE_DECIMAL(NetNB1Revenue,NetNB1Count) AS AvgSalePriceActual
,		dbo.DIVIDE_NOROUND(NetNB1Count,Consultations) AS ClosingPercentActual  --ClosingPercent needs 4 characters past the decimal
,		dbo.DIVIDE_DECIMAL(Discount,NetNB1Revenue) AS DiscountPercent
,		@StartDate AS StartDate
,		@EndDate AS EndDate
FROM #Final


END
