/***********************************************************************
PROCEDURE:				[spRpt_PresidentsClubStylist]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[spRpt_PresidentsClubStylist]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/26/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_PresidentsClubStylist] 6,2019

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubStylist]
(
	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;


/************** Declare and set variables ********************************************************/


DECLARE @StartDate DATETIME
DECLARE	@EndDate DATETIME
DECLARE @BeginningOfTheYear DATE

SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
SET @EndDate = DATEADD(MINUTE, -1, DATEADD(mm, 1, @StartDate))
SET @BeginningOfTheYear = CAST('1/1/' + DATENAME(YEAR,@StartDate) AS DATE)

--PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(120))
--PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(120))
--PRINT '@BeginningOfTheYear = ' + CAST(@BeginningOfTheYear AS NVARCHAR(120))

--Set @OpenPCPDate to beginning of the year
DECLARE @OpenPCPDate DATETIME
SET @OpenPCPDate = @BeginningOfTheYear

/************ Create temp tables *****************************************************************/
CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(50)
,	RecurringBusinessSize NVARCHAR(10)
)

CREATE TABLE #PMC(
	CenterNumber INT
,	MembershipChanges INT
)

CREATE TABLE #OpenPCP(
	CenterNumber INT
,	PCPBegin INT
,	YearPCPBegin INT
,	BIOopenPCP INT
,	BIOopenPCPBudget INT
)

CREATE TABLE #ClosePCP(
	CenterNumber INT
,	PCPEnd INT
,	YearPCPEnd INT
,	BIOClosePCP INT
)

CREATE TABLE #Retail(
	MonthShortNameWithYear CHAR(8)
,	CenterNumber INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(200)
,	RetailSales DECIMAL(18,2)
)

CREATE TABLE #Services(
	MonthShortNameWithYear CHAR(8)
,	CenterNumber INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(200)
,	ClientServicedCnt INT
)

CREATE TABLE #EmpID(
	CenterNumber INT
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(102)
)

CREATE TABLE #Stylist(
	CenterNumber INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(104)
,	RecurringBusinessSize NVARCHAR(10)
,	EmployeeSSID NVARCHAR(50)
,	EmployeeFullName NVARCHAR(150)
,	Upgrades INT
,	BIOopenPCP INT
,	BIOClosePCP INT
,	RetailSales DECIMAL(18,2)
,	ClientServicedCnt INT
,	RetailPerClient DECIMAL(18,2)
,	StartDate DATE
,	EndDate DATE
)



/********************************** Find center information   *************************************/

INSERT INTO #Centers
SELECT c.CenterNumber
,	c.CenterDescriptionNumber
,   CMA.CenterManagementAreaSSID
,   CMA.CenterManagementAreaDescription
,	c.RecurringBusinessSize
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c WITH(NOLOCK)
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT WITH(NOLOCK)
		ON	CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA WITH(NOLOCK)
		ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
WHERE	CT.CenterTypeDescriptionShort IN('C')
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(100,199)



CREATE NONCLUSTERED INDEX IDX_Centers_CenterNumber ON #Centers ( CenterNumber );


/********************************** Get Upgrades/downgrades for timeframe *************************************/
INSERT INTO #PMC
SELECT q.CenterNumber
,       q.Employee2Key
,       q.EmployeeFullName
,       q.Upgrades + q.Downgrades AS 'MembershipChanges'
FROM
	(SELECT C.CenterNumber
	,	FST.Employee2Key
	,	E.EmployeeFullName
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'Upgrades'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN -1 ELSE 0 END) AS 'Downgrades'

	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH(NOLOCK)
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH(NOLOCK)
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C WITH(NOLOCK)
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC WITH(NOLOCK)
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1070,1080)
	GROUP BY C.CenterNumber
	,	FST.Employee2Key
	,	E.EmployeeFullName) q


/********************************** Get Opening PCP data YTD *************************************/

INSERT INTO #OpenPCP
select s.CenterNumber
,       s.PCPBegin
,       s.YearPCPBegin
,       SUM(s.BIOopenPCP) AS BIOopenPCP
,       SUM(s.BIOopenPCPBudget) AS BIOopenPCPBudget
from(
SELECT  a.CenterID AS 'CenterNumber'
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate)) AS 'PCPBegin'
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate)) AS 'YearPCPBegin'
,	CASE WHEN a.AccountID = 10400 THEN ISNULL(a.Flash,0) ELSE 0 END AS 'BIOopenPCP'
,	CASE WHEN a.AccountID = 10400 THEN (ISNULL(a.Flash,0)+ 1) ELSE 0 END AS 'BIOopenPCPBudget'
FROM    HC_Accounting.dbo.FactAccounting a
        INNER JOIN #Centers C
            ON a.CenterID = C.CenterNumber
WHERE   MONTH(a.PartitionDate) = MONTH(@OpenPCPDate)
        AND YEAR(a.PartitionDate) = YEAR(@OpenPCPDate)
        AND a.AccountID IN(10400)
)s
GROUP BY s.CenterNumber
,       s.PCPBegin
,       s.YearPCPBegin



/**************** Find Closing PCP Counts per center this month *******************************************/

INSERT INTO #ClosePCP
SELECT u.CenterNumber
,       u.PCPEnd
,       u.YearPCPEnd
,       SUM(u.BIOClosePCP) AS BIOClosePCP
FROM
(SELECT  b.CenterID AS 'CenterNumber'   --CenterID matches CenterNumber in FactAccounting
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate)) AS 'PCPEnd'
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate)) AS 'YearPCPEnd'
,	CASE WHEN b.AccountID = 10400 THEN ISNULL(b.Flash,0) ELSE 0 END AS 'BIOClosePCP'
FROM    HC_Accounting.dbo.FactAccounting b
        INNER JOIN #Centers C
            ON b.CenterID = C.CenterNumber
WHERE   MONTH(b.PartitionDate) = MONTH(@EndDate)
        AND YEAR(b.PartitionDate) = YEAR(@EndDate)
        AND b.AccountID IN(10400)
)u
GROUP BY u.CenterNumber
,         u.PCPEnd
,         u.YearPCPEnd



/**********Find Retail sales per center per timeframe ***************************/

INSERT  INTO #Retail
        SELECT  DD.MonthShortNameWithYear
			,	CTR.CenterNumber
			,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
					WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
					END AS 'EmployeeSSID'
			,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
				WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
					ELSE 'UNKNOWN'
				END AS 'EmployeeFullName'
			,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FST.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON SOD.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers CTR
            ON c.CenterNumber = CTR.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EMP
			ON EMP.EmployeeKey = SO.EmployeeKey
		WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
				AND FST.RetailAmt <> '0'
GROUP BY CASE
         WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
         WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
         END,
         CASE
         WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
         WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
         ELSE 'UNKNOWN' END,
         DD.MonthShortNameWithYear,
         CTR.CenterNumber


/********** Find Services per client One per day ******************************************************/


INSERT INTO #Services
SELECT q.MonthShortNameWithYear
,	q.CenterNumber
,	q.EmployeeSSID
,	q.EmployeeFullName
,	SUM(q.ClientServicedCnt) AS ClientServicedCnt
FROM

	(SELECT #Centers.CenterNumber
	,	DD.Fulldate
	,	DD.MonthShortNameWithYear
	,	FST.ClientKey
	,	DSC.SalesCodeSSID
	,	DSC.SalesCodeDescription
	,	DSC.SalesCodeTypeSSID
	,	DSCD.SalesCodeDepartmentSSID
	,	CASE WHEN DSCD.SalesCodeDepartmentSSID between 5010 and 5040 THEN 1 ELSE 0 END AS 'ClientServicedCnt'
	,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2SSID
					WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1SSID
					END AS 'EmployeeSSID'
	,	CASE WHEN SOD.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee2FullName
			WHEN SOD.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN SOD.Employee1FullName
				ELSE 'UNKNOWN'
			END AS 'EmployeeFullName'
	,	ROW_NUMBER() OVER(PARTITION BY FST.ClientKey,DD.FullDate ORDER BY DSC.SalesCodeDescription DESC) AS 'FirstRank'  --One service per day per client
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON #Centers.CenterNumber = C.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
	WHERE 	DSCD.SalesCodeDivisionSSID = 50
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SO.IsVoidedFlag = 0
		AND DSCD.SalesCodeDepartmentSSID between 5010 and 5040  --This is for services
	)q
WHERE FirstRank = 1
GROUP BY q.MonthShortNameWithYear
,         q.CenterNumber
,         q.EmployeeSSID
,         q.EmployeeFullName


/******************** Find EmployeePayrollID and EmployeeFullName ***************************/


INSERT INTO #EmpID
SELECT #Retail.CenterNumber
,	#Retail.EmployeeSSID
,	#Retail.EmployeeFullName
FROM #Retail
UNION
SELECT #Services.CenterNumber
,	#Services.EmployeeSSID
,	#Services.EmployeeFullName
FROM #Services


/******************** Final select into #Stylist ******************************************************/

INSERT INTO #Stylist
SELECT C.CenterNumber
,	C.CenterManagementAreaSSID
,	C.CenterManagementAreaDescription
,	C.CenterDescriptionNumber
,	C.RecurringBusinessSize
,	EmpID.EmployeeSSID
,	EmpID.EmployeeFullName
,	ISNULL(PMC.MembershipChanges,0) AS Upgrades
,	ISNULL(OpenPCP.BIOopenPCP,0) AS BIOopenPCP
,	ISNULL(ClosePCP.BIOClosePCP,0) AS BIOClosePCP
,	ISNULL(R.RetailSales,0) AS RetailSales
,	ISNULL(S.ClientServicedCnt,0) AS ClientServicedCnt
,	dbo.DIVIDE_DECIMAL(ISNULL(R.RetailSales,0),ISNULL(S.ClientServicedCnt,0)) AS RetailPerClient
,	@StartDate AS StartDate
,	@EndDate AS EndDate
FROM #Centers C
	LEFT OUTER JOIN #PMC PMC
		ON C.CenterNumber = PMC.CenterNumber
	LEFT OUTER JOIN #OpenPCP OpenPCP
		ON C.CenterNumber = OpenPCP.CenterNumber
	LEFT OUTER JOIN #ClosePCP ClosePCP
		ON C.CenterNumber = ClosePCP.CenterNumber
	LEFT OUTER JOIN #EmpID EmpID
		ON EmpID.CenterNumber = C.CenterNumber
	LEFT OUTER JOIN #Retail R
		ON R.CenterNumber = C.CenterNumber AND R.EmployeeSSID = EmpID.EmployeeSSID
	LEFT OUTER JOIN #Services S
		ON S.CenterNumber = C.CenterNumber AND S.EmployeeSSID = EmpID.EmployeeSSID




SELECT * FROM #Stylist


END
