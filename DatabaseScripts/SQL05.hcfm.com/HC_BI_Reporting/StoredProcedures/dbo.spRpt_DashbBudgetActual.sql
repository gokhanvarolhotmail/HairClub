/* CreateDate: 01/06/2015 11:39:33.180 , ModifyDate: 06/04/2015 09:46:15.583 */
GO
/***********************************************************************
PROCEDURE:				SpRpt_DashbBudgetActual
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut
CREATED DATE:			01/06/2015

------------------------------------------------------------------------
CHANGE HISTORY:
06/02/2015 - RH - Added code to find last year's Actuals as this year's Budget for Franchises; Added CenterTypeDescription
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [SpRpt_DashbBudgetActual] 201

EXEC [SpRpt_DashbBudgetActual] 896

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_DashbBudgetActual](
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
	--SET @EndDate = DATEADD(Minute,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--End of last month at 11:59PM

	PRINT @StartDate
	PRINT @EndDate


	CREATE TABLE #budget (
		CenterID INT
		,	CenterDescriptionNumber NVARCHAR(100)
		,	CenterTypeDescription NVARCHAR(25)
		,	DateKey INT
		,	PartitionDate DATETIME
		,	AccountID INT
		,	Budget DECIMAL(18,1)
		,	Actual DECIMAL(18,1)
		,	AccountDescription NVARCHAR(100)
		,	AccountType NVARCHAR(1)
		,	RegionKey INT
		,	RegionDescription NVARCHAR(100)
		)


IF @CenterSSID LIKE '[2]%'  --Corporate Centers
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
		,	CASE WHEN ACC.AccountID = 10205 THEN 'Trad#'
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
			ELSE 'PostEXT$'
			END AS 'AccountDescription'
		,	RIGHT(ACC.AccountDescription,1) AS AccountType
		,	C.RegionKey
		,	R.RegionDescription
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
			ON FA.AccountID = ACC.AccountID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = C.RegionKey
	WHERE FA.AccountID IN(10205,10206, 10305,10306,10210,10310,10215,10315,10225,10325,10220,10320)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND CenterID = @CenterSSID
	ORDER BY FA.CenterID, PartitionDate
END
ELSE
BEGIN
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
		,	CASE WHEN ACC.AccountID = 10205 THEN 'Trad#'
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
			ELSE 'PostEXT$'
			END AS 'AccountDescription'
		,	RIGHT(ACC.AccountDescription,1) AS AccountType
		,	C.RegionKey
		,	R.RegionDescription
	INTO #LastYear
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
			ON FA.AccountID = ACC.AccountID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = C.RegionKey
	WHERE FA.AccountID IN(10205,10206, 10305,10306,10210,10310,10215,10315,10225,10325,10220,10320)
	AND FA.PartitionDate BETWEEN DATEADD(MONTH,-12,@StartDate) AND DATEADD(MONTH,-12,@EndDate)
	AND CenterID = @CenterSSID
	ORDER BY FA.CenterID, PartitionDate

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
		,	CASE WHEN ACC.AccountID = 10205 THEN 'Trad#'
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
			ELSE 'PostEXT$'
			END AS 'AccountDescription'
		,	RIGHT(ACC.AccountDescription,1) AS AccountType
		,	C.RegionKey
		,	R.RegionDescription
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
			ON FA.AccountID = ACC.AccountID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = C.RegionKey
		LEFT JOIN #LastYear LY
			ON FA.AccountID = LY.AccountID
	WHERE FA.AccountID IN(10205,10206, 10305,10306,10210,10310,10215,10315,10225,10325,10220,10320)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterSSID
	ORDER BY FA.CenterID, PartitionDate
END

	SELECT	CenterID
          , CenterDescriptionNumber
		  ,	CenterTypeDescription
          , DateKey
          , PartitionDate
          , AccountID
		  , CASE WHEN AccountType = '$' THEN FORMAT(Budget, '#,##0,.#') ELSE Budget END AS 'Budget'
          , CASE WHEN AccountType = '$' THEN FORMAT(Actual, '#,##0,.#') ELSE Actual END AS 'Actual'
          , AccountDescription
          , AccountType
          , RegionKey
          , RegionDescription
	FROM #budget


END
GO
