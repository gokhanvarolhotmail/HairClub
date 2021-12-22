/* CreateDate: 11/29/2012 12:59:05.867 , ModifyDate: 04/08/2013 10:07:19.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_SalesSiteNewBusinessRevenueStatistics

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		11/29/2012

==============================================================================
DESCRIPTION:	New business statistics for sales department site
==============================================================================
NOTES:

--  04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_SalesSiteNewBusinessRevenueStatistics 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_SalesSiteNewBusinessRevenueStatistics] (
	@RegionCenterFilter INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


	DECLARE @ReceivablesDate DATETIME
	,	@StartDate DATETIME
	,	@StartDateSales DATETIME
	,	@EndDate DATETIME
	,	@OneMonthBackStart DATETIME
	,	@OneMonthBackEnd DATETIME
	,	@TwoMonthsBackStart DATETIME
	,	@TwoMonthsBackEnd DATETIME
	,	@ThreeMonthsBackStart DATETIME
	,	@ThreeMonthsBackEnd DATETIME
	,	@FourMonthsBackStart DATETIME
	,	@FourMonthsBackEnd DATETIME
	,	@FiveMonthsBackStart DATETIME
	,	@FiveMonthsBackEnd DATETIME
	,	@SixMonthsBackStart DATETIME
	,	@SixMonthsBackEnd DATETIME
	,	@SevenMonthsBackStart DATETIME
	,	@SevenMonthsBackEnd DATETIME
	,	@EigntMonthsBackStart DATETIME
	,	@EightMonthsBackEnd DATETIME
	,	@NineMonthsBackStart DATETIME
	,	@NineMonthsBackEnd DATETIME
	,	@TenMonthsBackStart DATETIME
	,	@TenMonthsBackEnd DATETIME
	,	@ElevenMonthsBackStart DATETIME
	,	@ElevenMonthsBackEnd DATETIME
	,	@TwelveMonthsBackStart DATETIME
	,	@TwelveMonthsBackEnd DATETIME


	CREATE TABLE #Centers (
		CenterSSID INT
	,	CenterDescription VARCHAR(50)
	,	RegionDescription VARCHAR(50)
	)

	CREATE TABLE #Dates (
		DateID INT
	,	DateDesc VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)

	CREATE TABLE #Output (
		CenterRegionDescription VARCHAR(50)
	,	DateDesc VARCHAR(50)
	,	DateAbbreviation VARCHAR(25)
	,	StartDate DATETIME
	,	EndDate DATETIME
	,	Actual MONEY
	,	Budget MONEY
	)

	IF @RegionCenterFilter=0
		BEGIN
			INSERT INTO #Centers (
				CenterSSID
			,	CenterDescription
			,	RegionDescription
			)
			SELECT c.CenterSSID
			,	c.CenterDescriptionNumber
			,	R.RegionDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
				AND c.Active = 'Y'
		END
	ELSE IF @RegionCenterFilter < 200
		BEGIN
			INSERT INTO #Centers (
				CenterSSID
			,	CenterDescription
			,	RegionDescription
			)
			SELECT c.CenterSSID
			,	R.RegionDescription
			,	R.RegionDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE R.RegionSSID=@RegionCenterFilter
				AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
				AND c.Active = 'Y'
		END
	ELSE
		BEGIN
			INSERT INTO #Centers (
				CenterSSID
			,	CenterDescription
			,	RegionDescription
			)
			SELECT c.CenterSSID
			,	c.CenterDescriptionNumber
			,	R.RegionDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE c.CenterSSID = @RegionCenterFilter
				AND c.Active = 'Y'
		END


	SET @StartDate = CONVERT(VARCHAR, MONTH(GETDATE())) + '/1/' + CONVERT(VARCHAR, YEAR(GETDATE()))
	SET @EndDate = DATEADD(dd,-1,DATEADD(mm, 1, @StartDate))


	SELECT @OneMonthBackStart = @StartDate
	,	@OneMonthBackEnd = @EndDate
	,	@TwoMonthsBackStart = DATEADD(MONTH, -1, @StartDate)
	,	@TwoMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwoMonthsBackStart))
	,	@ThreeMonthsBackStart = DATEADD(MONTH, -2, @StartDate)
	,	@ThreeMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @ThreeMonthsBackStart))
	,	@FourMonthsBackStart = DATEADD(MONTH, -3, @StartDate)
	,	@FourMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @FourMonthsBackStart))
	,	@FiveMonthsBackStart = DATEADD(MONTH, -4, @StartDate)
	,	@FiveMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @FiveMonthsBackStart))
	,	@SixMonthsBackStart = DATEADD(MONTH, -5, @StartDate)
	,	@SixMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @SixMonthsBackStart))
	,	@SevenMonthsBackStart = DATEADD(MONTH, -6, @StartDate)
	,	@SevenMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @SevenMonthsBackStart))
	,	@EigntMonthsBackStart = DATEADD(MONTH, -7, @StartDate)
	,	@EightMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @EigntMonthsBackStart))
	,	@NineMonthsBackStart = DATEADD(MONTH, -8, @StartDate)
	,	@NineMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @NineMonthsBackStart))
	,	@TenMonthsBackStart = DATEADD(MONTH, -9, @StartDate)
	,	@TenMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TenMonthsBackStart))
	,	@ElevenMonthsBackStart = DATEADD(MONTH, -10, @StartDate)
	,	@ElevenMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @ElevenMonthsBackStart))
	,	@TwelveMonthsBackStart = DATEADD(MONTH, -11, @StartDate)
	,	@TwelveMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwelveMonthsBackStart))



	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (1, DATENAME(MONTH, @OneMonthBackStart), @OneMonthBackStart, @OneMonthBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (2, DATENAME(MONTH, @TwoMonthsBackStart), @TwoMonthsBackStart, @TwoMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (3, DATENAME(MONTH, @ThreeMonthsBackStart), @ThreeMonthsBackStart, @ThreeMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (4, DATENAME(MONTH, @FourMonthsBackStart), @FourMonthsBackStart, @FourMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (5, DATENAME(MONTH, @FiveMonthsBackStart), @FiveMonthsBackStart, @FiveMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (6, DATENAME(MONTH, @SixMonthsBackStart), @SixMonthsBackStart, @SixMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (7, DATENAME(MONTH, @SevenMonthsBackStart), @SevenMonthsBackStart, @SevenMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (8, DATENAME(MONTH, @EigntMonthsBackStart), @EigntMonthsBackStart, @EightMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (9, DATENAME(MONTH, @NineMonthsBackStart), @NineMonthsBackStart, @NineMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (10, DATENAME(MONTH, @TenMonthsBackStart), @TenMonthsBackStart, @TenMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (11, DATENAME(MONTH, @ElevenMonthsBackStart), @ElevenMonthsBackStart, @ElevenMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (12, DATENAME(MONTH, @TwelveMonthsBackStart), @TwelveMonthsBackStart, @TwelveMonthsBackEnd)



	IF @RegionCenterFilter=0
		BEGIN
			INSERT INTO #Output (
				CenterRegionDescription
			,	DateDesc
			,	DateAbbreviation
			,	StartDate
			,	EndDate
			,	Actual
			,	Budget)
			SELECT 'Corporate'
			,	D.DateDesc
			,	LEFT(DATENAME(MONTH, D.StartDate), 3) + ' ''' + RIGHT(CONVERT(VARCHAR, YEAR(D.StartDate)), 2) AS 'DateDesc'
			,	D.StartDate
			,	D.EndDate
			,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Flash ELSE 0 END, 0)) AS 'NetNb1AmountActual'
			,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1AmountBudget'
			FROM HC_Accounting.[dbo].[FactAccounting] FA
				INNER JOIN #Centers C
					ON FA.CenterID = C.CenterSSID
				INNER JOIN #Dates D
					ON FA.PartitionDate BETWEEN D.StartDate AND D.EndDate
			WHERE FA.AccountID IN (10305, 10315, 10310, 10320, 10325)
			GROUP BY D.DateDesc
			,	D.StartDate
			,	D.EndDate
			ORDER BY D.StartDate
		END
	ELSE IF @RegionCenterFilter < 200
		BEGIN
			INSERT INTO #Output (
				CenterRegionDescription
			,	DateDesc
			,	DateAbbreviation
			,	StartDate
			,	EndDate
			,	Actual
			,	Budget)
			SELECT C.RegionDescription
			,	D.DateDesc
			,	LEFT(DATENAME(MONTH, D.StartDate), 3) + ' ''' + RIGHT(CONVERT(VARCHAR, YEAR(D.StartDate)), 2) AS 'DateDesc'
			,	D.StartDate
			,	D.EndDate
			,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Flash ELSE 0 END, 0)) AS 'NetNb1AmountActual'
			,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1AmountBudget'
			FROM HC_Accounting.[dbo].[FactAccounting] FA
				INNER JOIN #Centers C
					ON FA.CenterID = C.CenterSSID
				INNER JOIN #Dates D
					ON FA.PartitionDate BETWEEN D.StartDate AND D.EndDate
			WHERE FA.AccountID IN (10305, 10315, 10310, 10320, 10325)
			GROUP BY C.RegionDescription
			,	D.DateDesc
			,	D.StartDate
			,	D.EndDate
			ORDER BY D.StartDate
		END
	ELSE
		BEGIN
			INSERT INTO #Output (
				CenterRegionDescription
			,	DateDesc
			,	DateAbbreviation
			,	StartDate
			,	EndDate
			,	Actual
			,	Budget)
			SELECT C.CenterDescription
			,	D.DateDesc
			,	LEFT(DATENAME(MONTH, D.StartDate), 3) + ' ''' + RIGHT(CONVERT(VARCHAR, YEAR(D.StartDate)), 2) AS 'DateDesc'
			,	D.StartDate
			,	D.EndDate
			,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Flash ELSE 0 END, 0)) AS 'NetNb1AmountActual'
			,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1AmountBudget'
			FROM HC_Accounting.[dbo].[FactAccounting] FA
				INNER JOIN #Centers C
					ON FA.CenterID = C.CenterSSID
				INNER JOIN #Dates D
					ON FA.PartitionDate BETWEEN D.StartDate AND D.EndDate
			WHERE FA.AccountID IN (10305, 10315, 10310, 10320, 10325)
			GROUP BY C.CenterDescription
			,	D.DateDesc
			,	D.StartDate
			,	D.EndDate
			ORDER BY D.StartDate
		END


	SELECT *
	FROM #Output
END
GO
