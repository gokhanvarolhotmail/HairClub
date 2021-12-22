/***********************************************************************
PROCEDURE:				[spRpt_DashbCenterRecurringRevenue]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut
CREATED DATE:			03/03/2015

------------------------------------------------------------------------
CHANGE HISTORY:
04/23/2015 - RH - (WO#113254) Changed RetailSales$ to pull where AccountID in(3090,3096) for Budget/ Goal instead of 10555; Still need to pull 'Actual' value from FactAccounting where AccountID = 10555
06/02/2015 - RH - (WO#115409) Added code to find last year's Actuals as this year's Budget for Franchises; Added CenterTypeDescription
06/05/2015 - RH - (WO#115208) Added 10566 - Serviced - NonPGM #, 10540 - NonPGM $
07/29/2015 - RH - (WO#116911) Changed Retail Sales $ to pull from FactSalesTransaction (instead of FactAccounting where AccountID = 10555)

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_DashbCenterRecurringRevenue] 216

EXEC [spRpt_DashbCenterRecurringRevenue] 825

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_DashbCenterRecurringRevenue](
	@CenterSSID INT
)

AS
BEGIN
DECLARE	@StartDate DATETIME
	,	@EndDate DATETIME

SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)	--Beginning of the month for the PartitionDate
SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0)))		--Today at 11:59PM

--For testing
--SET @StartDate = DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--Beginning of last month
--SET @EndDate = DATEADD(Minute,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--End of last month at 11:59PM											--Today at 11:59PM

PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))

--Create temp tables

CREATE TABLE #budget (
	CenterID INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	CenterTypeDescription NVARCHAR(25)
	,	DateKey INT
	,	PartitionDate DATETIME
	,	AccountID INT
	,	Budget DECIMAL(13,2)
	,	Goal DECIMAL(13,2)
	,	Actual DECIMAL(13,2)
	,	AccountDescription NVARCHAR(100)
	,	AccountType NVARCHAR(1)
	)


DECLARE @LastMonthPCP DATETIME
SET @LastMonthPCP = DATEADD(Month,-1,@StartDate)

IF @CenterSSID LIKE '[2]%'  --Corporate
BEGIN

INSERT INTO #budget
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	CASE WHEN ACC.AccountID IN(3096) THEN 3090 ELSE ACC.AccountID END AS 'AccountID'  --Combine all of the Retail Sales into one account
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * FA.Budget)
		ELSE FA.Budget
		END AS 'Budget'
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * (FA.Budget + (.10 * FA.Budget))) ELSE (FA.Budget + (.10 * FA.Budget)) END AS 'Goal'
	,	FA.Flash AS 'Actual'
	,	CASE WHEN ACC.AccountID = 10530 THEN 'PCP - PCP Sales$'
			WHEN ACC.AccountID IN(3090,3096) THEN 'Retail Sales$'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales$'
			WHEN ACC.AccountID = 10240 THEN 'New Styles#'
			WHEN ACC.AccountID = 10430 THEN 'BIO Conversion#'
			WHEN ACC.AccountID = 10410	THEN 'Active PCP#'
			WHEN ACC.AccountID = 10566	THEN 'NonPGM #'
			WHEN ACC.AccountID = 10540	THEN 'NonPGM $'
		END AS 'AccountDescription'
	,	CASE WHEN ACC.AccountID IN(3090,3096,10555, 10540) THEN '$' ELSE RIGHT(ACC.AccountDescription,1) END AS 'AccountType'
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10530,3090,3096, 10575,10240,10430,10410,10555,10566,10540)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterSSID
UNION
SELECT  --Find previous month's data
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	1041099 AS AccountID
	,	FA.Budget
	,	(FA.Budget + (.10 * FA.Budget)) AS 'Goal'
	,	FA.Flash AS 'Actual'
	,	 'PCP Last Month#' AS 'AccountDescription'
	,	RIGHT(ACC.AccountDescription,1) AS AccountType
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10410)
	AND FA.PartitionDate = DATEADD(MONTH,-1,@StartDate)
	AND FA.CenterID = @CenterSSID

--SELECT * FROM #budget
END
ELSE
BEGIN  --Franchise
--Find last year's Actuals for this year's Budget values
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	CASE WHEN ACC.AccountID IN(3096) THEN 3090 ELSE ACC.AccountID END AS 'AccountID'  --Combine all of the Retail Sales into one account
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * FA.Budget)
		ELSE FA.Budget
		END AS 'Budget'
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * (FA.Budget + (.10 * FA.Budget))) ELSE (FA.Budget + (.10 * FA.Budget)) END AS 'Goal'
	,	'0' AS 'Actual'
	,	CASE WHEN ACC.AccountID = 10530 THEN 'PCP - PCP Sales$'
			WHEN ACC.AccountID IN(3090,3096) THEN 'Retail Sales$'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales$'
			WHEN ACC.AccountID = 10240 THEN 'New Styles#'
			WHEN ACC.AccountID = 10430 THEN 'BIO Conversion#'
			WHEN ACC.AccountID = 10410	THEN 'Active PCP#'
			WHEN ACC.AccountID = 10566	THEN 'NonPGM #'
			WHEN ACC.AccountID = 10540	THEN 'NonPGM $'
		END AS 'AccountDescription'
	,	CASE WHEN ACC.AccountID IN(3090,3096,10555) THEN '$' ELSE RIGHT(ACC.AccountDescription,1) END AS 'AccountType'
INTO #LastYear
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10530,3090,3096, 10575,10240,10430,10410,10555,10566,10540)
	AND FA.PartitionDate BETWEEN DATEADD(MONTH,-12,@StartDate) AND DATEADD(MONTH,-12,@EndDate)
	AND FA.CenterID = @CenterSSID
UNION
SELECT  --Find previous month's data
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	1041099 AS AccountID
	,	FA.Budget
	,	(FA.Budget + (.10 * FA.Budget)) AS 'Goal'
	,	'0' AS 'Actual'
	,	 'PCP Last Month#' AS 'AccountDescription'
	,	RIGHT(ACC.AccountDescription,1) AS AccountType
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10410)
	AND FA.PartitionDate = DATEADD(MONTH,-13,@StartDate)
	AND FA.CenterID = @CenterSSID

--Find the  Franchise this year and update with last year's Actuals as Budget

INSERT INTO #budget
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	CASE WHEN ACC.AccountID IN(3096) THEN 3090 ELSE ACC.AccountID END AS 'AccountID'  --Combine all of the Retail Sales into one account
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * LY.Budget)
		ELSE LY.Budget
		END AS 'Budget'
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * (LY.Budget + (.10 * LY.Budget))) ELSE (LY.Budget + (.10 * LY.Budget)) END AS 'Goal'
	,	FA.Flash AS 'Actual'
	,	CASE WHEN ACC.AccountID = 10530 THEN 'PCP - PCP Sales$'
			WHEN ACC.AccountID IN(3090,3096) THEN 'Retail Sales$'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales$'
			WHEN ACC.AccountID = 10240 THEN 'New Styles#'
			WHEN ACC.AccountID = 10430 THEN 'BIO Conversion#'
			WHEN ACC.AccountID = 10410	THEN 'Active PCP#'
			WHEN ACC.AccountID = 10566	THEN 'NonPGM #'
		END AS 'AccountDescription'
	,	CASE WHEN ACC.AccountID IN(3090,3096,10555) THEN '$' ELSE RIGHT(ACC.AccountDescription,1) END AS 'AccountType'
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
	INNER JOIN #LastYear LY
		ON FA.AccountID = LY.AccountID
WHERE FA.AccountID IN(10530,3090,3096, 10575,10240,10430,10410,10555,10566)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterSSID
UNION
SELECT  --Find previous month's data
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	1041099 AS AccountID
	,	LY.Budget
	,	(LY.Budget + (.10 * LY.Budget)) AS 'Goal'
	,	FA.Flash AS 'Actual'
	,	 'PCP Last Month#' AS 'AccountDescription'
	,	RIGHT(ACC.AccountDescription,1) AS AccountType
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
	INNER JOIN #LastYear LY
		ON FA.AccountID = LY.AccountID
WHERE FA.AccountID IN(10410)
	AND FA.PartitionDate = DATEADD(MONTH,-1,@StartDate)
	AND FA.CenterID = @CenterSSID

END

/***********************Combine values for Retail Sales for 3090 and 3096 ****************/
SELECT CenterID
        , CenterDescriptionNumber
		, CenterTypeDescription
        , DateKey
        , PartitionDate
        , AccountID
        , SUM(Budget) AS 'Budget'
        , SUM(Goal) AS 'Goal'
        , SUM(Actual) AS 'Actual'
        , AccountDescription
        , AccountType
INTO #final
FROM #budget
GROUP BY CenterID
        , CenterDescriptionNumber
		, CenterTypeDescription
        , DateKey
        , PartitionDate
        , AccountID
        , AccountDescription
        , AccountType


/**************** Find Retail Sales $ from FactSalesTransaction and update #final *****/

--Find Retail data from FactSalesTransaction

SELECT C.CenterSSID
	,	SUM(ISNULL(fst.RetailAmt,0)) AS 'Actual'
INTO #Retail
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FST.CenterKey = C.CenterKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND C.CenterSSID = @CenterSSID
GROUP BY C.CenterSSID


UPDATE f
SET f.Actual = r.Actual
FROM #final f
INNER JOIN #Retail r
	ON r.CenterSSID = f.CenterID
WHERE f.Actual IS NULL

/*********************** Final Select **********************************************************************************/

SELECT * FROM #final
WHERE AccountID <> 10555  --Remove the Retail Sales $ associated with 10555 - we needed this above to find the 'Actual' value from FactAccounting


END
