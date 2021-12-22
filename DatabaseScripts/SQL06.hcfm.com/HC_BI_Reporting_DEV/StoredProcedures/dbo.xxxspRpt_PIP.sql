/* CreateDate: 04/26/2019 17:03:56.410 , ModifyDate: 05/02/2019 14:51:15.663 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_PIP]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[spRpt_PIP]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		12/27/2018
------------------------------------------------------------------------
NOTES:
No parameters - uses a rolling three months
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_PIP]

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_PIP]
--No parameters
AS
BEGIN

SET FMTONLY OFF;


/************** Declare and set variables **********************************************************************/

DECLARE @StartDate DATE
DECLARE @EndDate DATE

DECLARE @BeginningOfThisMonth DATE
DECLARE @BeginningOfThePreviousMonth DATE


DECLARE @Today DATE = CURRENT_TIMESTAMP;

SET @BeginningOfThisMonth = CAST(CAST(MONTH(@Today) AS VARCHAR(2)) + '/1/' + CAST(YEAR(@Today) AS VARCHAR(4)) AS DATE)		--Beginning of the month
SET @BeginningOfThePreviousMonth = DATEADD(MONTH,-1,@BeginningOfThisMonth)



--If @Today is the beginning of the month, then set @StartDate to the first day of last month and set @EndDate to yesterday at 11:59 PM

IF @BeginningOfThisMonth = CAST(@Today AS DATE)
BEGIN
SET @StartDate = DATEADD(MONTH, -3,@BeginningOfThePreviousMonth)
SET @EndDate = DATEADD(DAY,-1,CAST(@Today AS DATE))
END
ELSE
BEGIN
SET @StartDate = DATEADD(MONTH, -3,@BeginningOfThisMonth)
SET @EndDate = CAST(@Today AS DATE)
END


DECLARE @ClosingBudget DECIMAL(18,4)				--Percent
SET @ClosingBudget = .45



/********** Create temp tables ******************************************************************************/

CREATE TABLE #CenterNumber (CenterNumber INT)

INSERT INTO #CenterNumber
SELECT CTR.CenterNumber
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CTR.CenterKey <> 2  --Corporate
AND CTR.Active = 'Y'

CREATE TABLE #Employee(
	EmployeeKey INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeePositionSSID NVARCHAR(50)
,	EmployeePositionDescription NVARCHAR(50)
,	EmployeeFullName NVARCHAR(102)
,	UserLogin NVARCHAR(50)
,	CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
)


CREATE TABLE #Sales(
	EmployeeKey INT
,	Employee1FullName NVARCHAR(102)
,	FullDate DATE
,	NB_GradCnt INT
,	NB_GradAmt DECIMAL(18,4)
,	NB_TradCnt INT
,	NB_TradAmt DECIMAL(18,4)
,	S_SurCnt INT
,	S_SurAmt DECIMAL(18,4)
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
)


CREATE TABLE #SUM_Sales(
	EmployeeKey INT
,	Employee1FullName NVARCHAR(102)
,	FullDate DATE
,	NetNB1Count	INT
,	NetNB1Revenue DECIMAL(18,4)
)


CREATE TABLE #NetConsultations(
	EmployeeKey INT
,	Performer NVARCHAR(102)
,	FullDate DATE
,	ActivityCnt INT
)

CREATE TABLE #NetSales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	FullDate DATE
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
)


CREATE TABLE #SUM_NetSales(
	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	FullDate DATE
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
)


CREATE TABLE #IC(
	CenterNumber INT
,	FullDate DATE
,	NumberOfIC INT
,	SalesBudgetPerIC INT
,	RevenueBudgetPerIC DECIMAL(18,4)
)


CREATE TABLE #Final(
	EmployeeKey INT
,   EmployeeFullName NVARCHAR(1002)
,   UserLogin NVARCHAR(50)
,	FullDate DATE
,   CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,   CenterManagementAreaDescription NVARCHAR(50)
,   NumberOfIC INT
,	SalesBudgetPerIC INT
,	RevenueBudgetPerIC DECIMAL(18,4)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Revenue DECIMAL(18,4)
)

/*********************** Begin populating the temp tables ***********************************************************/

--Find consultants


INSERT INTO #Employee
SELECT e.EmployeeKey
,	e.EmployeeSSID
,	ep.EmployeePositionSSID
,	ep.EmployeePositionDescription
,	e.EmployeeFullName
,	e.UserLogin
,	CN.CenterNumber
,	CTR.CenterDescriptionNumber
,	CMA.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
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



--Find the Center Manager and Budget Consultations for this month and NB1 Sales Budget

SELECT a.CenterNumber
,	a.PartitionDate
	,	SUM(CASE WHEN a.AccountID IN (10205, 10206, 10215, 10210,  10225)THEN ISNULL(a.Budget,0) ELSE 0 END) AS NB1SalesBudget
	,	SUM(CASE WHEN a.AccountID IN (10305, 10306, 10315, 10310,  10325) THEN ISNULL(a.Budget,0) ELSE 0 END) AS NB1RevenueBudget
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
	WHERE FA.PartitionDate BETWEEN @StartDate AND @EndDate
		AND FA.AccountID IN( 10205,10206,10215,10210,10225,10305,10306,10315,10310, 10325)
	) a
GROUP BY a.CenterNumber
,	a.PartitionDate




--Find the activities that are consultations and employees
INSERT INTO #NetConsultations
SELECT  E.EmployeeKey
,		DAD.Performer
,		CAST(CAST(MONTH(DA.ActivityDueDate) AS VARCHAR(2)) + '/1/' + CAST(YEAR(DA.ActivityDueDate) AS VARCHAR(4)) AS DATE) AS FullDate
,		COUNT(DA.ActivitySSID) AS ActivityCnt
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
			ON (DAD.ActivitySSID = DA.ActivitySSID OR (DAD.ActivitySSID IS NULL AND DAD.SFDC_TaskID = DA.SFDC_TaskID))
		INNER JOIN #Employee E
			--ON FAR.ActivityEmployeeKey = E.EmployeeKey --These employees are from the NCC
			ON DAD.Performer = E.EmployeeFullName
WHERE   DA.ActivityDueDate BETWEEN @StartDate AND @EndDate
		AND FAR.Consultation = 1
		AND DAD.Performer IN(SELECT EmployeeFullName FROM #Employee)
GROUP BY CAST(CAST(MONTH(DA.ActivityDueDate) AS VARCHAR(2)) + '/1/' + CAST(YEAR(DA.ActivityDueDate) AS VARCHAR(4)) AS DATE),
         E.EmployeeKey,
         DAD.Performer


INSERT INTO #Sales
SELECT FST.Employee1Key AS EmployeeKey
,		SOD.Employee1FullName
,		CAST(CAST(MONTH(DD.FullDate) AS VARCHAR(2)) + '/1/' + CAST(YEAR(DD.FullDate) AS VARCHAR(4)) AS DATE)
,		SUM(ISNULL(FST.NB_GradCnt,0)) AS NB_GradCnt
,		SUM(ISNULL(FST.NB_GradAmt,0)) AS NB_GradAmt
,       SUM(ISNULL(FST.NB_TradCnt,0)) AS NB_TradCnt
,       SUM(ISNULL(FST.NB_TradAmt,0)) AS NB_TradAmt
,		SUM(ISNULL(FST.S_SurCnt,0)) AS S_SurCnt
,		SUM(ISNULL(FST.S_SurAmt,0)) AS S_SurAmt
,       SUM(ISNULL(FST.NB_ExtCnt,0)) AS NB_ExtCnt
,       SUM(ISNULL(FST.NB_ExtAmt,0)) AS NB_ExtAmt
,		SUM(ISNULL(FST.S_PostExtCnt,0)) AS S_PostExtCnt
,		SUM(ISNULL(FST.S_PostExtAmt,0)) AS S_PostExtAmt
,       SUM(ISNULL(FST.NB_XtrCnt,0)) AS NB_XtrCnt
,       SUM(ISNULL(FST.NB_XtrAmt,0)) AS NB_XtrAmt
,       SUM(ISNULL(FST.LaserCnt,0)) AS LaserCnt
,       SUM(ISNULL(FST.LaserAmt,0)) AS LaserAmt
,       SUM(ISNULL(FST.NB_MDPCnt,0)) AS NB_MDPCnt
,       SUM(ISNULL(FST.NB_MDPAmt,0)) AS NB_MDPAmt
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
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
		AND m.RevenueGroupDescription = 'New Business'
		AND m.MembershipSSID NOT IN(57,58)  --New Client (ShowNoSale),New Client (Surgery Offered)
		AND DSCD.SalesCodeDivisionSSID IN(10,20)
 GROUP BY   FST.Employee1Key
,		SOD.Employee1FullName
,CAST(CAST(MONTH(DD.FullDate) AS VARCHAR(2)) + '/1/' + CAST(YEAR(DD.FullDate) AS VARCHAR(4)) AS DATE)


INSERT INTO #SUM_Sales
		SELECT  t.EmployeeKey
		,	t.Employee1FullName
		,	t.FullDate
,		SUM(ISNULL(t.NB_TradCnt, 0))
		+ SUM(ISNULL(t.NB_ExtCnt, 0))
		+ SUM(ISNULL(t.NB_XtrCnt, 0))
        + SUM(ISNULL(t.NB_GradCnt, 0))
		--+ SUM(ISNULL(t.S_SurCnt, 0))
		+ SUM(ISNULL(t.NB_MDPCnt,0))
        + SUM(ISNULL(t.S_PostExtCnt, 0)) AS 'NetNB1Count'
,       SUM(ISNULL(t.NB_TradAmt, 0))
		+ SUM(ISNULL(t.NB_ExtAmt, 0))
		+ SUM(ISNULL(t.NB_XtrAmt, 0))
        + SUM(ISNULL(t.NB_GradAmt, 0))
		--+ SUM(ISNULL(t.S_SurAmt, 0))
		+ SUM(ISNULL(t.NB_MDPAmt,0))
        + SUM(ISNULL(t.S_PostExtAmt, 0)) AS 'NetNB1Revenue'
FROM #Sales t
GROUP BY t.EmployeeKey
,	t.Employee1FullName
,	t.FullDate


--Join both sets of data with a UNION
INSERT INTO #NetSales
SELECT 	EK.EmployeeKey
,	NC.Performer AS EmployeeFullName
,	NC.FullDate
,	SUM(ISNULL(NC.ActivityCnt,0)) AS Consultations
,	0 AS NetNB1Count
,	0 AS NetNB1Revenue
FROM #Employee EK
INNER JOIN #NetConsultations NC
	ON NC.EmployeeKey = EK.EmployeeKey
GROUP BY EK.EmployeeKey
,	NC.Performer
,	NC.FullDate
UNION
SELECT 	EK.EmployeeKey
,	S.Employee1FullName AS EmployeeFullName
,	S.FullDate
,	0 AS Consultations
,	S.NetNB1Count
,	S.NetNB1Revenue
FROM #Employee EK
INNER JOIN #SUM_Sales S
	ON EK.EmployeeKey = S.EmployeeKey
GROUP BY EK.EmployeeKey
,	S.Employee1FullName
,	S.FullDate
,	S.NetNB1Count
,	S.NetNB1Revenue


--SUM the results
INSERT INTO #SUM_NetSales
SELECT 	NS.EmployeeKey
,	NS.EmployeeFullName
,	FullDate
,	SUM(Consultations) AS Consultations
,	SUM(NetNB1Count) AS NetNB1Count
,	SUM(NetNB1Revenue) AS NetNB1Revenue
FROM #NetSales NS
GROUP BY NS.EmployeeKey
,	NS.EmployeeFullName
,	FullDate


--Find the number of active IC's in this timeframe for the center
INSERT INTO #IC
SELECT EK.CenterNumber AS CenterNumber
,	S.FullDate
,	COUNT(S.EmployeeKey) AS NumberOfIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (BUD.NB1SalesBudget/COUNT(S.EmployeeKey)) END AS SalesBudgetPerIC
,	CASE WHEN COUNT(S.EmployeeKey) = 0 THEN 0 ELSE (BUD.NB1RevenueBudget/COUNT(S.EmployeeKey)) END AS RevenueBudgetPerIC
FROM #SUM_Sales S
INNER JOIN #Employee EK
	ON S.EmployeeKey = EK.EmployeeKey
INNER JOIN #Budget BUD
	ON BUD.CenterNumber = EK.CenterNumber
WHERE S.NetNB1Revenue <> 0
AND  S.FullDate = BUD.PartitionDate
GROUP BY EK.CenterNumber
,	S.FullDate
,	BUD.NB1SalesBudget
,	BUD.NB1RevenueBudget


/******** Final select *******************************************************************/


INSERT INTO #Final
SELECT EK.EmployeeKey
,       EK.EmployeeFullName
,       EK.UserLogin
,		NS.FullDate
,       EK.CenterNumber
,       EK.CenterDescriptionNumber
,       EK.CenterManagementAreaDescription
,       MAX(IC.NumberOfIC) AS NumberOfIC
,		MAX(IC.SalesBudgetPerIC) AS SalesBudgetPerIC
,		MAX(IC.RevenueBudgetPerIC) AS RevenueBudgetPerIC
,		ISNULL(NS.Consultations,0) AS Consultations
,		ISNULL(NS.NetNB1Count,0) AS NetNB1Count
,		ISNULL(NS.NetNB1Revenue,0) AS NetNB1Revenue
FROM #Employee EK
INNER JOIN #IC IC
	ON IC.CenterNumber = EK.CenterNumber
INNER JOIN #SUM_NetSales NS
	ON EK.EmployeeKey = NS.EmployeeKey
WHERE (ISNULL(NS.Consultations,0) <> 0 OR ISNULL(NS.NetNB1Count,0) <> 0 OR ISNULL(NS.NetNB1Revenue,0) <> 0)
GROUP BY EK.EmployeeKey
,		EK.EmployeeFullName
,		EK.UserLogin
,		NS.FullDate
,		EK.CenterNumber
,		EK.CenterDescriptionNumber
,		EK.CenterManagementAreaDescription
,		NS.Consultations
,		NS.NetNB1Count
,		NS.NetNB1Revenue


/********** Last select  ******************************/

TRUNCATE TABLE dbo.PIP_Count

INSERT INTO dbo.PIP_Count
SELECT EmployeeKey
,       EmployeeFullName
,       UserLogin
,		FullDate
,       CenterNumber
,       CenterDescriptionNumber
,       CenterManagementAreaDescription
,       Consultations
,       NetNB1Count
,       NetNB1Revenue
,		dbo.DIVIDE_NOROUND(NetNB1Revenue,RevenueBudgetPerIC) AS RevenuePercent
,		@ClosingBudget AS ClosingBudget
,		dbo.DIVIDE_NOROUND(NetNB1Count,Consultations) AS ClosingPercentActual  --ClosingPercent needs 4 characters past the decimal
,		@StartDate AS StartDate
,		@EndDate AS EndDate
FROM #Final



END
GO
