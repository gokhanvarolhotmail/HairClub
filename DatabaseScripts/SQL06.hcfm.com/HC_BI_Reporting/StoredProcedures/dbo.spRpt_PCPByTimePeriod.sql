/* CreateDate: 06/06/2012 11:30:56.103 , ModifyDate: 04/08/2013 10:04:51.647 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_PCPByTimePeriod

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		6/6/2012

==============================================================================
DESCRIPTION:	PCP By Time Period Report
==============================================================================
NOTES:

--  04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_PCPByTimePeriod] 3, 2013
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_PCPByTimePeriod] (
	@Month			TINYINT
,	@Year			SMALLINT)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @TempDate DATETIME
	,	@CurrentMonthStart DATETIME
	,	@CurrentMonthEnd DATETIME
	,	@QuarterStart DATETIME
	,	@QuarterEnd DATETIME
	,	@CurrentFiscalYearStart DATETIME
	,	@CurrentFiscalYearEnd DATETIME
	,	@CurrentMonth TINYINT
	,	@CurrentFiscalQuarter VARCHAR(50)
	,	@CurrentFiscalYear VARCHAR(50)


	CREATE TABLE #Dates (
		DateID INT
	,	DateDesc VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)


	CREATE TABLE #Centers (
		CenterID INT
	,	CenterName VARCHAR(50)
	,	RegionName VARCHAR(50)
	)


	CREATE TABLE #Final (
		Region VARCHAR(50)
	,	CenterName VARCHAR(50)
	,	MTD_Conversions_Actual INT
	,	MTD_Conversions_Budget INT
	,	MTD_Conversions_Diff INT
	,	MTD_Conversions_Pct FLOAT
	,	MTD_PCPRevenue_Actual MONEY
	,	MTD_PCPRevenue_Budget MONEY
	,	MTD_PCPRevenue_Diff MONEY
	,	MTD_PCPRevenue_Pct FLOAT

	,	QTD_Conversions_Actual INT
	,	QTD_Conversions_Budget INT
	,	QTD_Conversions_Diff INT
	,	QTD_Conversions_Pct FLOAT
	,	QTD_PCPRevenue_Actual MONEY
	,	QTD_PCPRevenue_Budget MONEY
	,	QTD_PCPRevenue_Diff MONEY
	,	QTD_PCPRevenue_Pct FLOAT

	,	YTD_Conversions_Actual INT
	,	YTD_Conversions_Budget INT
	,	YTD_Conversions_Diff INT
	,	YTD_Conversions_Pct FLOAT
	,	YTD_PCPRevenue_Actual MONEY
	,	YTD_PCPRevenue_Budget MONEY
	,	YTD_PCPRevenue_Diff MONEY
	,	YTD_PCPRevenue_Pct FLOAT
	)

	INSERT INTO #Centers (
		CenterID
	,	CenterName
	,	RegionName)
	SELECT c.CenterSSID
	,	CONVERT(VARCHAR, c.CenterSSID) + ' - ' + c.CenterDescription AS 'CenterName'
	,	RGN.RegionDescription
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			ON c.RegionSSID = r.RegionSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
			ON c.CenterTypeKey = t.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion RGN
			ON c.RegionSSID = RGN.RegionSSID
	WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
		AND c.Active='Y'


	INSERT INTO #Final (
		Region
	,	CenterName)
	SELECT RegionName
	,	CenterName
	FROM #Centers


	SET @CurrentMonthStart = (
		SELECT MIN(FullDate)
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalYear = @Year
			AND MonthNumber = @Month
	)
	SET @CurrentMonthEnd = (
		SELECT MAX(FullDate)
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalYear = @Year
			AND MonthNumber = @Month
	)
	SET @CurrentFiscalYear = (
		SELECT DISTINCT FiscalYearName
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalYearName = CONVERT(VARCHAR, @Year)
	)
	SET @CurrentFiscalYearStart = (
		SELECT MIN(FullDate)
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalYearName = @CurrentFiscalYear
	)
	SET @CurrentFiscalYearEnd = (
		SELECT MAX(FullDate)
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalYearName = @CurrentFiscalYear
	)
	SET @CurrentFiscalQuarter = (
		SELECT DISTINCT FiscalQuarterNameWithYear
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE @CurrentMonthStart BETWEEN FirstDateOfQuarter AND LastDateOfQuarter
	)
	SET	@QuarterStart = (
		SELECT MIN(FullDate)
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalQuarterNameWithYear = @CurrentFiscalQuarter
	)
	SET	@QuarterEnd = (
		SELECT MAX(FullDate)
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FiscalQuarterNameWithYear = @CurrentFiscalQuarter
	)

	SET @CurrentFiscalYearEnd = @CurrentMonthEnd
	SET @QuarterEnd = @CurrentMonthEnd


	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (1, 'CurrentMonth', @CurrentMonthStart, @CurrentMonthEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (2, 'CurrentFiscalQuarter', @QuarterStart, @QuarterEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (3, 'CurrentFiscalYear', @CurrentFiscalYearStart, @CurrentFiscalYearEnd)



	SELECT #Dates.DateDesc
	,	#Centers.CenterName
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10430, 10435 ) THEN a.Flash ELSE 0 END, 0)) AS 'ConversionsActual'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10430, 10435 ) THEN a.Budget ELSE 0 END, 0)) AS 'ConversionsBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 3020, 3025, 3030, 3035, 3040, 3045, 3050, 3055 ) THEN a.Actual * -1 ELSE 0 END, 0))
			- SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 3021, 3004, 3000 ) THEN a.Actual * -1 ELSE 0 END, 0))
		AS 'PCPRevenueActual'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10530 ) THEN a.Budget ELSE 0 END, 0)) AS 'PCPRevenueBudget'
	INTO #tmp
	FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON a.[CenterID] = CTR.CenterSSID
		INNER JOIN #Dates
			ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN #Centers
			ON a.CenterID = #Centers.CenterID
	WHERE a.AccountID IN (
		10430
	,	10435
	,	10530
	,	3020
	,	3025
	,	3030
	,	3035
	,	3040
	,	3045
	,	3050
	,	3055
	,	3021
	,	3004
	,	3000
	)
	GROUP BY #Dates.DateDesc
	,	#Centers.CenterName


	UPDATE f
	SET f.MTD_Conversions_Actual	= ISNULL(t.ConversionsActual, 0)
	,	f.MTD_Conversions_Budget	= ISNULL(t.ConversionsBudget, 0)
	,	f.MTD_Conversions_Diff		= ISNULL(t.ConversionsActual, 0) - ISNULL(t.ConversionsBudget, 0)
	,	f.MTD_Conversions_Pct		= dbo.DIVIDE_DECIMAL(ISNULL(t.ConversionsActual, 0), ISNULL(t.ConversionsBudget, 0))
	,	f.MTD_PCPRevenue_Actual		= ISNULL(t.PCPRevenueActual, 0)
	,	f.MTD_PCPRevenue_Budget		= ISNULL(t.PCPRevenueBudget, 0)
	,	f.MTD_PCPRevenue_Diff		= ISNULL(t.PCPRevenueActual, 0) - ISNULL(t.PCPRevenueBudget, 0)
	,	f.MTD_PCPRevenue_Pct		= dbo.DIVIDE_DECIMAL(ISNULL(t.PCPRevenueActual, 0), ISNULL(t.PCPRevenueBudget, 0))
	FROM #Final f
		LEFT OUTER JOIN #tmp t
			ON f.CenterName = t.CenterName
	WHERE t.DateDesc='CurrentMonth'


	UPDATE f
	SET f.QTD_Conversions_Actual	= ISNULL(t.ConversionsActual, 0)
	,	f.QTD_Conversions_Budget	= ISNULL(t.ConversionsBudget, 0)
	,	f.QTD_Conversions_Diff		= ISNULL(t.ConversionsActual, 0) - ISNULL(t.ConversionsBudget, 0)
	,	f.QTD_Conversions_Pct		= dbo.DIVIDE_DECIMAL(ISNULL(t.ConversionsActual, 0), ISNULL(t.ConversionsBudget, 0))
	,	f.QTD_PCPRevenue_Actual		= ISNULL(t.PCPRevenueActual, 0)
	,	f.QTD_PCPRevenue_Budget		= ISNULL(t.PCPRevenueBudget, 0)
	,	f.QTD_PCPRevenue_Diff		= ISNULL(t.PCPRevenueActual, 0) - ISNULL(t.PCPRevenueBudget, 0)
	,	f.QTD_PCPRevenue_Pct		= dbo.DIVIDE_DECIMAL(ISNULL(t.PCPRevenueActual, 0), ISNULL(t.PCPRevenueBudget, 0))
	FROM #Final f
		LEFT OUTER JOIN #tmp t
			ON f.CenterName = t.CenterName
	WHERE t.DateDesc='CurrentFiscalQuarter'


	UPDATE f
	SET f.YTD_Conversions_Actual	= ISNULL(t.ConversionsActual, 0)
	,	f.YTD_Conversions_Budget	= ISNULL(t.ConversionsBudget, 0)
	,	f.YTD_Conversions_Diff		= ISNULL(t.ConversionsActual, 0) - ISNULL(t.ConversionsBudget, 0)
	,	f.YTD_Conversions_Pct		= dbo.DIVIDE_DECIMAL(ISNULL(t.ConversionsActual, 0), ISNULL(t.ConversionsBudget, 0))
	,	f.YTD_PCPRevenue_Actual		= ISNULL(t.PCPRevenueActual, 0)
	,	f.YTD_PCPRevenue_Budget		= ISNULL(t.PCPRevenueBudget, 0)
	,	f.YTD_PCPRevenue_Diff		= ISNULL(t.PCPRevenueActual, 0) - ISNULL(t.PCPRevenueBudget, 0)
	,	f.YTD_PCPRevenue_Pct		= dbo.DIVIDE_DECIMAL(ISNULL(t.PCPRevenueActual, 0), ISNULL(t.PCPRevenueBudget, 0))
	FROM #Final f
		LEFT OUTER JOIN #tmp t
			ON f.CenterName = t.CenterName
	WHERE t.DateDesc='CurrentFiscalYear'

	SELECT 	Region
	,	CenterName
	,	ISNULL(MTD_Conversions_Actual, 0) AS 'MTD_Conversions_Actual'
	,	ISNULL(MTD_Conversions_Budget, 0) AS 'MTD_Conversions_Budget'
	,	ISNULL(MTD_Conversions_Diff, 0) AS 'MTD_Conversions_Diff'
	,	ISNULL(MTD_Conversions_Pct, 0) AS 'MTD_Conversions_Pct'
	,	ISNULL(MTD_PCPRevenue_Actual, 0) AS 'MTD_PCPRevenue_Actual'
	,	ISNULL(MTD_PCPRevenue_Budget, 0) AS 'MTD_PCPRevenue_Budget'
	,	ISNULL(MTD_PCPRevenue_Diff, 0) AS 'MTD_PCPRevenue_Diff'
	,	ISNULL(MTD_PCPRevenue_Pct, 0) AS 'MTD_PCPRevenue_Pct'
	,	ISNULL(QTD_Conversions_Actual, 0) AS 'QTD_Conversions_Actual'
	,	ISNULL(QTD_Conversions_Budget, 0) AS 'QTD_Conversions_Budget'
	,	ISNULL(QTD_Conversions_Diff, 0) AS 'QTD_Conversions_Diff'
	,	ISNULL(QTD_Conversions_Pct, 0) AS 'QTD_Conversions_Pct'
	,	ISNULL(QTD_PCPRevenue_Actual, 0) AS 'QTD_PCPRevenue_Actual'
	,	ISNULL(QTD_PCPRevenue_Budget, 0) AS 'QTD_PCPRevenue_Budget'
	,	ISNULL(QTD_PCPRevenue_Diff, 0) AS 'QTD_PCPRevenue_Diff'
	,	ISNULL(QTD_PCPRevenue_Pct, 0) AS 'QTD_PCPRevenue_Pct'
	,	ISNULL(YTD_Conversions_Actual, 0) AS 'YTD_Conversions_Actual'
	,	ISNULL(YTD_Conversions_Budget, 0) AS 'YTD_Conversions_Budget'
	,	ISNULL(YTD_Conversions_Diff, 0) AS 'YTD_Conversions_Diff'
	,	ISNULL(YTD_Conversions_Pct, 0) AS 'YTD_Conversions_Pct'
	,	ISNULL(YTD_PCPRevenue_Actual, 0) AS 'YTD_PCPRevenue_Actual'
	,	ISNULL(YTD_PCPRevenue_Budget, 0) AS 'YTD_PCPRevenue_Budget'
	,	ISNULL(YTD_PCPRevenue_Diff, 0) AS 'YTD_PCPRevenue_Diff'
	,	ISNULL(YTD_PCPRevenue_Pct, 0) AS 'YTD_PCPRevenue_Pct'
	,	DATENAME(MONTH, @CurrentMonthStart) AS 'MonthName'
	,	CONVERT(VARCHAR, YEAR(@CurrentMonthStart)) AS 'FiscalYear'
	FROM #Final
	ORDER BY Region
	,	CenterName

END
GO
