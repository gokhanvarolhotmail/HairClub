/* CreateDate: 07/25/2019 13:51:50.430 , ModifyDate: 07/26/2019 16:09:33.303 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_WarBoardStylist]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[spRpt_WarBoardStylist]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/17/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardStylist] 6,2019

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_WarBoardStylist]
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
SET @EndDate = DATEADD(day, -1* day(dateadd(month, 1 ,@StartDate)),dateadd(month, 1 , @StartDate))
SET @BeginningOfTheYear = CAST('1/1/' + DATENAME(YEAR,@StartDate) AS DATE)


PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(120))
PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(120))
PRINT '@BeginningOfTheYear = ' + CAST(@BeginningOfTheYear AS NVARCHAR(120))


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
,	Employee2Key INT
,	Upgrades INT
)


CREATE TABLE #OpenPCP(
	CenterNumber INT
,	PCPBegin INT
,	YearPCPBegin INT
,	BIOopenPCP INT
,	BIOopenPCPBudget INT
)


CREATE TABLE #RetailSales(
	CenterNumber INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(200)
,	RetailAmt DECIMAL(18,4)
)

CREATE TABLE #Stylist(
	CenterNumber INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(104)
,	RecurringBusinessSize NVARCHAR(10)
,	Employee2Key INT
,	EmployeeFullName NVARCHAR(150)
,	Upgrades INT
,	BIOopenPCP INT
,	BIOClosePCP INT
,	RetailAmt DECIMAL(18,4)
)

/********************************** Find center information   *************************************/

INSERT INTO #Centers
SELECT c.CenterNumber
,	c.CenterDescriptionNumber
,   CMA.CenterManagementAreaSSID
,   CMA.CenterManagementAreaDescription
,	c.RecurringBusinessSize
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON	CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
WHERE	CT.CenterTypeDescriptionShort IN('C')
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(100,199)


/********************************** Get Upgrades for timeframe *************************************/


INSERT INTO #PMC
SELECT C.CenterNumber
,	FST.Employee2Key
,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'Upgrades'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FST.CenterKey = c.CenterKey
	INNER JOIN #Centers
		ON C.CenterNumber = #Centers.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeDepartmentSSID IN (1070)
GROUP BY C.CenterNumber
,	FST.Employee2Key

--SELECT '#PMC' AS tablename, * FROM #PMC ORDER BY CenterNumber

/********************************** Get Opening PCP data YTD *************************************/


--Set @OpenPCPDate to beginning of the year
DECLARE @OpenPCPDate DATETIME
SET @OpenPCPDate = @BeginningOfTheYear


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

IF OBJECT_ID('tempdb..#ClosePCP') IS NOT NULL
BEGIN
	DROP TABLE #ClosePCP
END

CREATE TABLE #ClosePCP(
	CenterNumber INT
,	PCPEnd INT
,	YearPCPEnd INT
,	BIOClosePCP INT
)

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


INSERT  INTO #RetailSales
        SELECT  C.CenterNumber
		,	CASE WHEN ISNULL(FST.Employee2Key,FST.Employee1Key) = -1 THEN -1
				ELSE ISNULL(FST.Employee2Key,FST.Employee1Key)  END AS 'EmployeeKey'
		,	CASE WHEN sod.Employee2SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee2FullName
				WHEN sod.Employee1SSID <> '00000000-0000-0000-0000-000000000002' THEN sod.Employee1FullName
				ELSE
				'UNKNOWN'
				END AS 'EmployeeFullName'
		,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailAmt'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = FST.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers CTR
            ON c.CenterNumber = CTR.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @StartDate AND @EndDate
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
		GROUP BY C.CenterNumber
		,	FST.Employee1Key
		,	FST.Employee2Key
		,	sod.Employee1SSID
		,	sod.Employee2SSID
		,	sod.Employee1FullName
		,	sod.Employee2FullName


/*********** Final select***********************************************/

INSERT INTO #Stylist
SELECT C.CenterNumber
,	C.CenterManagementAreaSSID
,	C.CenterManagementAreaDescription
,	C.CenterDescriptionNumber
,	C.RecurringBusinessSize
,	PMC.Employee2Key
,	NULL AS EmployeeFullName
,	ISNULL(PMC.Upgrades,0) AS Upgrades
,	ISNULL(OpenPCP.BIOopenPCP,0) AS BIOopenPCP
,	ISNULL(ClosePCP.BIOClosePCP,0) AS BIOClosePCP
,	NULL AS RetailAmt
FROM #Centers C
	LEFT OUTER JOIN #PMC PMC
		ON C.CenterNumber = PMC.CenterNumber
	LEFT OUTER JOIN #OpenPCP OpenPCP
		ON C.CenterNumber = OpenPCP.CenterNumber
	LEFT OUTER JOIN #ClosePCP ClosePCP
		ON C.CenterNumber = ClosePCP.CenterNumber

UPDATE STY
SET STY.EmployeeFullName = RS.EmployeeFullName
FROM #Stylist STY
INNER JOIN #RetailSales RS
	ON STY.Employee2Key = RS.EmployeeKey
WHERE STY.EmployeeFullName IS NULL


UPDATE STY
SET STY.RetailAmt = RS.RetailAmt
FROM #Stylist STY
INNER JOIN #RetailSales RS
	ON STY.Employee2Key = RS.EmployeeKey
WHERE STY.RetailAmt IS NULL

SELECT * FROM #Stylist



END
GO
