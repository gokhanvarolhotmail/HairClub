/***********************************************************************
PROCEDURE:	[spRpt_FranchiseWarBoards_NB2]
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/29/2012
-- Date Implemented:       8/29/2012
-- Date Last Modified:     8/29/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
-- ----------------------------------------------------------------------------------------------
-- Notes:

--  04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
-- ----------------------------------------------------------------------------------------------
Sample Execution:
exec spRpt_FranchiseWarBoards_NB2 3, 2013
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FranchiseWarBoards_NB2] (
	 @Month TINYINT
	,@Year INT
) AS
	SET NOCOUNT ON

	DECLARE
		@PreviousMonth AS TINYINT
	,	@PreviousYear AS INT
	,	@PreviousDate AS VARCHAR(20)
	,	@CurrentDate AS VARCHAR(20)
	,	@PreviousMonth2Mos AS TINYINT
	,	@PreviousYear2Mos AS INT
	,	@Begin90Days SMALLDATETIME
	,	@End90Days	SMALLDATETIME
	,	@RankMax			INT
	,	@CurrentRank		INT
	,	@SavedRank			INT
	,	@CurrentValueINT	INT
	,	@SavedValueINT		INT
	,	@CurrentValueDEC	DECIMAL(10,4)
	,	@SavedValueDEC		DECIMAL(10,4)
	,	@CurrentDateEnd DATETIME
	,	@PCPPrior3MonthsStart DATETIME
	,	@PCPPrior3MonthsEnd DATETIME
	,	@PCPLast3MonthsStart DATETIME
	,	@PCPLast3MonthsEnd DATETIME

	BEGIN
		IF (@Month) = 1
		BEGIN
			SET @PreviousMonth = 12
			SET @PreviousYear = @Year - 1
		END
		ELSE
		BEGIN
			SET @PreviousMonth = @Month - 1
			SET @PreviousYear = @Year
		END

		IF (@PreviousMonth) = 1
		BEGIN
			SET @PreviousMonth2Mos = 12
			SET @PreviousYear2Mos = @PreviousYear - 1
		END
		ELSE
			BEGIN
				SET @PreviousMonth2Mos = @PreviousMonth - 1
				SET @PreviousYear2Mos = @PreviousYear
			END

		SET @PreviousDate = RTRIM(CAST(@PreviousMonth AS VARCHAR)) + '/01/' + RTRIM(CAST(@PreviousYear AS varchar))
		SET @CurrentDate = RTRIM(CAST(@Month AS VARCHAR)) + '/01/' + RTRIM(CAST(@Year AS VARCHAR))
		SET @End90Days = DATEADD(mi, -1, DATEADD(m, 1, CAST(@CurrentDate as smalldatetime)))
		SET @Begin90Days = DATEADD(m, -2, @CurrentDate)
		SET @CurrentDateEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentDate))

		SET @PCPLast3MonthsEnd = @CurrentDate
		SET @PCPLast3MonthsStart = DATEADD(MONTH,-2, @PCPLast3MonthsEnd)

		SET @PCPPrior3MonthsEnd =  DATEADD(MONTH,-3, @CurrentDate)
		SET @PCPPrior3MonthsStart = DATEADD(MONTH,-2, @PCPPrior3MonthsEnd)

		-----------------------------------------------------------------------------------------------
		-- Create temp tables with Identity values, to store and rank records.
		-----------------------------------------------------------------------------------------------
		-- Attrition/Retention
		-----------------------------------------------------------------------------------------------
		--CREATE TABLE #Attrition_DHT (
		--	AttritionRank	INT		IDENTITY
		--,	AttritionRankActual	INT
		--,	[Center]	INT
		--,	PreviousMonthPCPCount	INT
		--,	CurrentMonthPCPCount	INT
		--,	PcpDifference	INT
		--,	DifferencePercent	DECIMAL(10,6)
		--,	AttritionPoints	INT
		--,	Team	VARCHAR(30)		)

		--CREATE TABLE #Attrition_Hunters (
		--	AttritionRank	INT		IDENTITY
		--,	AttritionRankActual	INT
		--,	[Center]	INT
		--,	PreviousMonthPCPCount	INT
		--,	CurrentMonthPCPCount	INT
		--,	PcpDifference	INT
		--,	DifferencePercent	DECIMAL(10,6)
		--,	AttritionPoints	INT
		--,	Team	VARCHAR(30)		)

		--CREATE TABLE #Attrition_Sky (
		--	AttritionRank	INT		IDENTITY
		--,	AttritionRankActual INT
		--,	[Center]	INT
		--,	PreviousMonthPCPCount	INT
		--,	CurrentMonthPCPCount	INT
		--,	PcpDifference	INT
		--,	DifferencePercent	DECIMAL(10,6)
		--,	AttritionPoints	INT
		--,	Team	VARCHAR(30)		)

		-------------------------------------------------------------------------------------------------
		---- Upgrades/Downgrades
		-------------------------------------------------------------------------------------------------
		--CREATE TABLE #Upgrades_DHT (
		--	UpgradeRank	INT	IDENTITY
		--,	UpgradeRankActual	INT
		--,	Center	INT
		--,	Upgrades	INT
		--,	Downgrades	INT
		--,	BeginningPcpClients	INT
		--,	UpgradeCalculation	DECIMAL(10,5)
		--,	UpgradePoints	INT
		--,	Team	VARCHAR(30)
		--,	CurrentPCPClients INT)

		--CREATE TABLE #Upgrades_Hunters (
		--	UpgradeRank	INT	IDENTITY
		--,	UpgradeRankActual	INT
		--,	Center	INT
		--,	Upgrades	INT
		--,	Downgrades	INT
		--,	BeginningPcpClients	INT
		--,	UpgradeCalculation	DECIMAL(10,5)
		--,	UpgradePoints	INT
		--,	Team	VARCHAR(30)
		--,	CurrentPCPClients INT	)

		--CREATE TABLE #Upgrades_Sky (
		--	UpgradeRank	INT	IDENTITY
		--,	UpgradeRankActual	INT
		--,	Center	INT
		--,	Upgrades	INT
		--,	Downgrades	INT
		--,	BeginningPcpClients	INT
		--,	UpgradeCalculation	DECIMAL(10,5)
		--,	UpgradePoints	INT
		--,	Team	VARCHAR(30)
		--,	CurrentPCPClients INT	)

		--------------------------------------------------------------------------------------------------
		---- Conversions
		--------------------------------------------------------------------------------------------------
		--CREATE TABLE #Conversions_DHT	(
		--	ConversionRank	INT		IDENTITY
		--,	ConversionRankActual	INT
		--,	[Center]	INT
		--,	Conversions	INT
		--,	Applications	INT
		--,	ConversionPercentage	DECIMAL(10, 6)
		--,	ConversionPoints	INT
		--,	Team	VARCHAR(30)
		--,	EXTConversions	INT
		--,   EXTConversionPercentage DECIMAL(10, 6))

		--CREATE TABLE #Conversions_Hunters	(
		--	ConversionRank	INT		IDENTITY
		--,	ConversionRankActual	INT
		--,	[Center]	INT
		--,	Conversions	INT
		--,	Applications	INT
		--,	ConversionPercentage	DECIMAL(10, 6)
		--,	ConversionPoints	INT
		--,	Team	VARCHAR(30)
		--,	EXTConversions	INT
		--,   EXTConversionPercentage DECIMAL(10, 6))

		--CREATE TABLE #Conversions_Sky	(
		--	ConversionRank	INT		IDENTITY
		--,	ConversionRankActual	INT
		--,	[Center]	INT
		--,	Conversions	INT
		--,	Applications	INT
		--,	ConversionPercentage	DECIMAL(10, 6)
		--,	ConversionPoints	INT
		--,	Team	VARCHAR(30)
		--,	EXTConversions	INT
		--,   EXTConversionPercentage DECIMAL(10, 6))

		---------------------------------------------------------------------------------------------------------
		-- Get the PCP numbers for the previous month
		---------------------------------------------------------------------------------------------------------
		SELECT ce.ReportingCenterSSID Center
		,	SUM(ISNULL(CASE WHEN a.AccountID IN (10515) THEN [Flash] ELSE 0 END  , 0)) AS 'PCPUpgradeCount'	--6232
		,	SUM(ISNULL(CASE WHEN a.AccountID IN (10510) THEN [Flash] ELSE 0 END  , 0)) AS 'PCPDowngradeCount'	--6231
		INTO #Accounting
		FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter de ON de.CenterSSID = ce.ReportingCenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = de.RegionKey
		WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
		GROUP BY ce.ReportingCenterSSID

		-- Get the PCP Client totals for the previous 2 months
		SELECT ce.ReportingCenterSSID Center
		,	SUM(ISNULL(CASE WHEN a.AccountID IN (10400) THEN [Flash] ELSE 0 END, 0)) AS 'PreviousMonthPCPCount'		--6311
		INTO #PreviousPCP
		FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter de ON de.CenterSSID = ce.ReportingCenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = de.RegionKey
		WHERE d.MonthNumber = @PreviousMonth
		AND d.YearNumber = @PreviousYear
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
		GROUP BY ce.ReportingCenterSSID


		SELECT ce.ReportingCenterSSID Center
		,	SUM(ISNULL(CASE WHEN a.AccountID IN (10400) THEN [Flash] ELSE 0 END, 0)) AS 'CurrentMonthPCPCount'	--6311
		INTO #CurrentPCP
		FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter de ON de.CenterSSID = ce.ReportingCenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = de.RegionKey
		WHERE d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
		GROUP BY ce.ReportingCenterSSID

		--------------------------------------------------------------------------------------------------------
		-- Get the Conversion and Applications numbers for the past 90 days
		--------------------------------------------------------------------------------------------------------
		SELECT ce.ReportingCenterSSID Center
		,	SUM(t.NB_AppsCnt) As 'Applications'
		,	SUM(t.NB_BIOConvCnt) - SUM(t.NB_EXTConvCnt) As 'Conversions'
		,	dbo.DIVIDE_DECIMAL((SUM(t.NB_BIOConvCnt) - SUM(t.NB_EXTConvCnt)), SUM(t.NB_AppsCnt)) As 'ConversionPercentage'
		,SUM(t.NB_EXTConvCnt)  As 'EXTConversions'
		,dbo.DIVIDE_DECIMAL(SUM(t.NB_EXTConvCnt), SUM(t.NB_AppsCnt)) As 'EXTConversionPercentage'
		INTO #Conversions
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
		WHERE d.FullDate BETWEEN @CurrentDate AND @CurrentDateEnd
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
		GROUP BY ce.ReportingCenterSSID

		--------------------------------------------------------------------------------------------------------
		-- Join the 4 temp tables above, and place into temp table #PcpNumbers
		--------------------------------------------------------------------------------------------------------
		SELECT
			re.RegionDescription Region
		,	ce.CenterDescriptionNumber 'CenterName'
		,	a.*
		,	cnv.Applications
		,	cnv.Conversions
		,   cnv.EXTConversions
		,	cnv.EXTConversionPercentage
		,	cnv.ConversionPercentage
		,	p.PreviousMonthPCPCount
		,	cu.CurrentMonthPCPCount - p.PreviousMonthPCPCount AS 'PcpDifference'
		,	dbo.DIVIDE_DECIMAL((cu.CurrentMonthPCPCount - p.PreviousMonthPCPCount), p.PreviousMonthPCPCount) AS 'PcpDiffPercentage'
		,	dbo.DIVIDE_DECIMAL(a.PcpUpgradeCount, cu.CurrentMonthPCPCount) AS 'UpgradePercentage'
		,	cu.CurrentMonthPCPCount
		INTO #PcpNumbersData
		FROM #Accounting a
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.Center
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = ce.RegionKey
		INNER JOIN #Conversions cnv ON cnv.[Center] = ce.CenterSSID
		INNER JOIN #PreviousPCP p ON cnv.Center = p.Center
		INNER JOIN #CurrentPCP cu ON cnv.Center = cu.Center
		WHERE ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'

		SELECT
			re.RegionDescription Region
		,	ce.CenterSSID AS 'Center'
		,	ce.CenterDescriptionNumber AS 'CenterName'
		,	ISNULL(cl.PCPUpgradeCount, 0) AS 'PcpUpgradeCount'
		,	ISNULL(cl.PcpDowngradeCount, 0) AS 'PcpDowngradeCount'
		,	ISNULL(cl.Applications, 0) AS 'Applications'
		,	ISNULL(cl.Conversions, 0) AS 'Conversions'
		,	ISNULL(cl.ConversionPercentage, 0.0) AS 'ConversionPercentage'
		,	ISNULL(cl.PreviousMonthPCPCount, 0) AS 'PreviousMonthPCPCount'
		,	ISNULL(cl.PcpDifference, 0) AS 'PcpDifference'
		,	ISNULL(cl.PcpDiffPercentage, 0.0) AS 'PcpDiffPercentage'
		,	ISNULL(cl.UpgradePercentage, 0.0) AS 'UpgradePercentage'
		,	ISNULL(cl.CurrentMonthPCPCount, 0) AS 'CurrentMonthPCPCount'
		,	ISNULL(cl.EXTConversions, 0) AS 'EXTConversions'
		,	ISNULL(cl.EXTConversionPercentage, 0.0) AS 'EXTConversionPercentage'
		INTO #PcpNumbers
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = ce.RegionKey
		LEFT OUTER JOIN [#PcpNumbersData] cl ON ce.CenterSSID = cl.[Center]
		WHERE ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'


		--PCP Rolling 3 months
		SELECT ce.ReportingCenterSSID center
		,	SUM(ISNULL([FlashReporting], 0)) AS 'PCPLast3Months'
		INTO #PCPLast3Months
		FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter de ON de.CenterSSID = ce.ReportingCenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = de.RegionKey
		WHERE d.FullDate BETWEEN @PCPLast3MonthsStart AND @PCPLast3MonthsEnd
		AND a.AccountID IN (10530)
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
		GROUP BY ce.ReportingCenterSSID


		SELECT ce.ReportingCenterSSID center
		,	SUM(ISNULL([FlashReporting], 0)) AS 'PCPPrior3Months'
		INTO #PCPPrior3Months
		FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = a.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = a.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter de ON de.CenterSSID = ce.ReportingCenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = de.RegionKey
		WHERE d.FullDate BETWEEN @PCPPrior3MonthsStart AND @PCPPrior3MonthsEnd
		AND a.AccountID IN (10530)
		AND ce.CenterTypeSSID IN (2,3)
		AND ce.Active = 'Y'
		GROUP BY ce.ReportingCenterSSID

		----------------------------------------------------------------------------------------------------------
		-- Merge all the temp tables, for the result set output.
		----------------------------------------------------------------------------------------------------------

		SELECT
			a.Region
		,	a.[Center]
		,	a.CenterName AS 'CenterName'
		,	a.PreviousMonthPcpCount
		,	a.PcpDifference
		,	a.PcpDiffPercentage
		, CASE WHEN a.CurrentMonthPCPCount > 0 THEN (cast(a.PcpDifference as decimal)) / a.CurrentMonthPCPCount ELSE 0 END AS MyDifferencePercent
		,	a.Conversions
		,	a.Applications
		,	a.ConversionPercentage
		,	a.EXTConversionPercentage
		,	a.EXTConversions
		,	a.PcpUpgradeCount Upgrades
		,	a.PcpDowngradeCount Downgrades
		,	a.PreviousMonthPCPCount BeginningPcpClients
		,	a.UpgradePercentage
		,	a.CurrentMonthPCPCount CurrentPCPClients
		,ISNULL(last3.PCPLast3Months, 0) PCPLast3Months
		,ISNULL(prior3.PCPPrior3Months,0) PCPPrior3Months
		INTO #Final
		FROM #PcpNumbers a
		LEFT JOIN #PCPLast3Months last3 ON last3.center = a.center
		LEFT JOIN #PCPPrior3Months prior3 ON prior3.center = a.center


SELECT
*,
-- Attrition Base 35 No Cap
-- Upgrade Base 15 Cap 200%
-- Bio Conv Base 30 Cap 200%
-- EXT Conv Base 20 Cap 125%
((PCP3MonthPoints * 35)
+(UpgradePoints * 15)
+(ConversionPoints * 30)
+(EXTConversionPoints * 20))/100
AS TotalPoints
FROM (
	SELECT
	 Region
	,Center
	, CenterName
	, PreviousMonthPcpCount, CurrentPCPClients, PcpDifference, PcpDiffPercentage
	, Attrition
	, AttritionPoints
	,PCPLast3Months,PCPPrior3Months
	, CASE WHEN PCP3MonthPoints > 1.1 THEN 1.1 ELSE PCP3MonthPoints END 'PCP3MonthPoints'
	, Upgrades, Downgrades, BeginningPcpClients
	, UpgradePercentage UpgradeCalculation
	, CASE WHEN UpgradePoints > 2 THEN 2.0 ELSE UpgradePoints END 'UpgradePoints'
	, Conversions, Applications, ConversionPercentage
	, CASE WHEN ConversionPoints > 2 THEN 2.0 ELSE ConversionPoints END 'ConversionPoints'
	, EXTConversionPercentage, EXTConversions
	, CASE WHEN EXTConversionPoints > 1.25 THEN 1.25 ELSE EXTConversionPoints END 'EXTConversionPoints'
	FROM (
		SELECT
		f.Region,f.Center,f.CenterName,f.PreviousMonthPcpCount,f.CurrentPCPClients,f.PcpDifference,f.PcpDiffPercentage,
		PCPLast3Months,
		PCPPrior3Months,
		dbo.DIVIDE_DECIMAL(PCPLast3Months, PCPPrior3Months) AS PCP3MonthPoints,
		dbo.DIVIDE_DECIMAL(CAST(f.PcpDifference AS DECIMAL), CAST(f.PreviousMonthPcpCount AS DECIMAL)) AS 'Attrition',
		CASE WHEN dbo.DIVIDE_DECIMAL(CAST(f.PcpDifference AS DECIMAL), CAST(f.PreviousMonthPcpCount AS DECIMAL)) < 0
			THEN 0
			ELSE dbo.DIVIDE_DECIMAL(CAST(f.PcpDifference AS DECIMAL), CAST(f.PreviousMonthPcpCount AS DECIMAL)) / .01
		END AS 'AttritionPoints',
		f.Upgrades,f.Downgrades,f.BeginningPcpClients,f.UpgradePercentage,
		f.UpgradePercentage / .02 AS 'UpgradePoints',
		f.Conversions,f.Applications,f.ConversionPercentage,
		f.ConversionPercentage /.67 AS 'ConversionPoints',
		f.EXTConversionPercentage,f.EXTConversions,
		f.EXTConversionPercentage /.35 AS 'EXTConversionPoints'
		FROM #Final f
	) TBL
) TBL2


	END
