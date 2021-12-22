/* CreateDate: 05/04/2018 11:43:26.303 , ModifyDate: 05/04/2018 11:43:26.303 */
GO
/******************************************************************************************************************************
PROCEDURE:				spRpt_SalesKPIReview
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Sales KPI Review
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/04/2018
--------------------------------------------------------------------------------------------------------------------------------
NOTES:


--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_SalesKPIReview] '3/1/2018'

********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SalesKPIReview]
(
	@CenterNumber INT
,	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;
/************************************************************************************/


DECLARE @CenterSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME

SET @CenterSSID = (SELECT CenterSSID FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterNumber = @CenterNumber)

SELECT @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SELECT @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@StartDate)) + '23:59:000'									--End of the same month


DECLARE @LastMonthPCP DATETIME
SET @LastMonthPCP = DATEADD(Month,-1,@StartDate)

PRINT @StartDate
PRINT @EndDate										--Today at 11:59PM

PRINT @CenterSSID
PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))

/*************************** Create temp tables ****************************************/

CREATE TABLE #Budget (
	CenterID INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	CenterTypeDescription NVARCHAR(25)
	,	DateKey INT
	,	PartitionDate DATETIME
	,	AccountID INT
	,	Budget DECIMAL(13,2)
	,	Actual DECIMAL(13,2)
	,	AccountDescription NVARCHAR(100)
	,	AccountType NVARCHAR(1)
	)






INSERT INTO #Budget
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	CASE WHEN ACC.AccountID IN(3096) THEN 3090 ELSE ACC.AccountID END AS 'AccountID'  --Combine all of the Retail Sales into one account
	,	CASE WHEN ACC.AccountID in(3090,3096) THEN (-1 * FA.Budget) ELSE FA.Budget 	END AS 'Budget'
	,	FA.Flash AS 'Actual'
	,	CASE WHEN ACC.AccountID = 10530 THEN 'PCP - PCP Sales$'
			WHEN ACC.AccountID IN(3090,3096) THEN 'Retail Sales$'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales$'
			WHEN ACC.AccountID = 10240 THEN 'New Styles#'
			WHEN ACC.AccountID = 10430 THEN 'BIO Conversion#'
			WHEN ACC.AccountID = 10410	THEN 'Active PCP#'
			WHEN ACC.AccountID = 10566	THEN 'NonPGM #'
			WHEN ACC.AccountID = 10540	THEN 'NonPGM $'
			WHEN ACC.AccountID = 10205 THEN 'Trad#'
			WHEN ACC.AccountID = 10206 THEN 'Xtr#'
			WHEN ACC.AccountID = 10210 THEN 'Grad#'
			WHEN ACC.AccountID = 10215 THEN 'Ext#'
			WHEN ACC.AccountID = 10220 THEN 'Sur#'
			WHEN ACC.AccountID = 10225 THEN 'PostEXT#'
			WHEN ACC.AccountID = 10305 THEN 'Trad$'
			WHEN ACC.AccountID = 10306 THEN 'Xtr$'
			WHEN ACC.AccountID = 10310 THEN 'Grad$'
			WHEN ACC.AccountID = 10315 THEN 'Ext$'
			WHEN ACC.AccountID = 10320 THEN 'Surg$'
			WHEN ACC.AccountID = 10325 THEN 'PostEXT$'
			WHEN ACC.AccountID = 10190 THEN 'ClosingRate_inclPEXT'
		END AS 'AccountDescription'
	,	CASE WHEN ACC.AccountID IN(3090,3096,10530,10575, 10540,10305,10306,10310,10315,10320,10325) THEN '$' ELSE RIGHT(ACC.AccountDescription,1) END AS 'AccountType'
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10530,3090,3096, 10575,10240,10430,10410,10566,10540,10205,10206,10210,10215,10220,10225,10305,10306,10310,10315,10320,10325,10190)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterSSID
UNION
SELECT  --Find previous month's data
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	1041099 AS 'AccountID'
	,	FA.Budget
	,	FA.Flash AS 'Actual'
	,	 'PCP Last Month#' AS 'AccountDescription'
	,	RIGHT(ACC.AccountDescription,1) AS 'AccountType'
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





/***********************Combine values for Retail Sales for 3090 and 3096 ****************/

SELECT CenterID
        , CenterDescriptionNumber
		, CenterTypeDescription
        , DateKey
        , PartitionDate
        , AccountID
        , SUM(Budget) AS 'Budget'
        , SUM(Actual) AS 'Actual'
        , AccountDescription
        , AccountType
INTO #Final
FROM #Budget
GROUP BY CenterID
        , CenterDescriptionNumber
		, CenterTypeDescription
        , DateKey
        , PartitionDate
        , AccountID
        , AccountDescription
        , AccountType



/**************** Find Retail Sales $ from FactSalesTransaction and update #Final *****/

--Find Retail data from FactSalesTransactio

SELECT C.CenterSSID
	,	SUM(ISNULL(fst.RetailAmt,0)) AS 'Actual'
INTO #Retail
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FST.CenterKey = C.CenterKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND C.CenterSSID = @CenterNumber
GROUP BY C.CenterSSID


UPDATE f
SET f.Actual = r.Actual
FROM #Final f
INNER JOIN #Retail r
	ON r.CenterSSID = f.CenterID
WHERE f.Actual IS NULL

/*********************** Final Select **********************************************************************************/

SELECT * FROM #Final
WHERE AccountID <> 10555  --Remove the Retail Sales $ associated with 10555 - we needed this above to find the 'Actual' value from FactAccounting

END
GO
