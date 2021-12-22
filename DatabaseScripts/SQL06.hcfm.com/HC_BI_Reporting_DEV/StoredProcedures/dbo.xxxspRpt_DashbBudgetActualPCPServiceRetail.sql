/***********************************************************************
PROCEDURE:				[spRpt_DashbdBudgetActualPCPServiceRetail]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut
CREATED DATE:			02/26/2015

------------------------------------------------------------------------
CHANGE HISTORY:
06/02/2015 - RH - Added code to find last year's Actuals as this year's Budget for Franchises; Added CenterTypeDescription

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_DashbBudgetActualPCPServiceRetail] 201

EXEC [spRpt_DashbBudgetActualPCPServiceRetail] 896

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_DashbBudgetActualPCPServiceRetail](
	@CenterSSID INT
)

AS
BEGIN
DECLARE	@StartDate DATETIME
	,	@EndDate DATETIME

SET @StartDate = DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--Beginning of last month
SET @EndDate = DATEADD(Minute,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--End of last month at 11:59PM											--Today at 11:59PM

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
	,	Actual DECIMAL(13,2)
	,	AccountDescription NVARCHAR(100)
	,	AccountType NVARCHAR(1)
	)

IF @CenterSSID LIKE '[2]%'  --Corporate
BEGIN
INSERT INTO #budget
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	FA.AccountID
	,	FA.Budget
	,	FA.Flash AS Actual
	,	CASE WHEN ACC.AccountID = 10410 THEN 'PCP - BIO & EXTMEM Active PCP #'
			WHEN ACC.AccountID = 10555 THEN 'Retail Sales $'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales $'
		END AS 'AccountDescription'
	,	RIGHT(ACC.AccountDescription,1) AS AccountType
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID

WHERE FA.AccountID IN(10410,10555,10575)
AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
AND CenterID = CASE
				   WHEN @CenterSSID IS NOT NULL THEN @CenterSSID
				   ELSE FA.CenterID
			   END
ORDER BY FA.CenterID, PartitionDate
END
ELSE
BEGIN  --Franchise
--Find the  Franchise "Budgets"- last year Flash values
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	FA.AccountID
	,	FA.Flash AS Budget
	,	'0' AS Actual
	,	CASE WHEN ACC.AccountID = 10410 THEN 'PCP - BIO & EXTMEM Active PCP #'
			WHEN ACC.AccountID = 10555 THEN 'Retail Sales $'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales $'
		END AS 'AccountDescription'
	,	RIGHT(ACC.AccountDescription,1) AS AccountType
INTO #LastYear
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10410,10555,10575)
AND FA.PartitionDate BETWEEN DATEADD(MONTH,-12,@StartDate) AND DATEADD(MONTH,-12,@EndDate)
AND CenterID = CASE
				   WHEN @CenterSSID IS NOT NULL THEN @CenterSSID
				   ELSE FA.CenterID
			   END
ORDER BY FA.CenterID, PartitionDate

--Find the  Franchise this year and update with last year's Actuals as Budget
INSERT INTO #budget
SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate
	,	FA.AccountID
	,	LY.Budget
	,	FA.Flash AS 'Actual'
	,	CASE WHEN ACC.AccountID = 10410 THEN 'PCP - BIO & EXTMEM Active PCP #'
			WHEN ACC.AccountID = 10555 THEN 'Retail Sales $'
			WHEN ACC.AccountID = 10575 THEN 'Service Sales $'
		END AS 'AccountDescription'
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
WHERE FA.AccountID IN(10410,10555,10575)
AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
AND C.CenterSSID = CASE
				   WHEN @CenterSSID IS NOT NULL THEN @CenterSSID
				   ELSE FA.CenterID
			   END
ORDER BY FA.CenterID, PartitionDate

END

SELECT * FROM #budget


END
