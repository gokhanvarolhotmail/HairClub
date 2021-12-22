/*
==============================================================================

PROCEDURE:				spRpt_WarBoardRecurringBusiness_Groups

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		02/27/2014

==============================================================================
DESCRIPTION:	Recurring Business War Board
THE GROUPS FOR RECURRING CUSTOMER ARE DIFFERENT THAN THOSE FOR NEW BUSINESS!
==============================================================================
NOTES:
This version of the WarBoard Recurring Business divides by Groups that were setup by M.Oakes.
@GroupSize = 0 = All
1 = Group1 (Small)
2 = Group2 (Medium)
3 = Group3 (Large)
This stored procedure is not used in the Franchise version of the report.

CHANGE HISTORY:
02/27/2014	RH	Created this version to support the additional grouping - small, medium, large - for centers.
03/06/2014	RH	Changed Budget values to default to 1.
04/03/2014	RH	(WO#99944) Re-arranged groups according to the request.
04/10/2014	RH	Added (@CenterType = 0 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%') to remove 300 and 500 centers.
					Changed CAST(Budget AS INT) to CAST(Budget AS DECIMAL(10,0))
04/21/2014	RH	For PCP amounts: ROUND(SUM(ISNULL(Flash, 0)),0) and ROUND(SUM(ISNULL(FlashReporting, 0)),0)
11/14/2014  RH	Added 251 - Memphis to Group 2, 252 - Nashville to Group 3; Added 253 - Tulsa and 254 - Little Rock to Group 1
03/09/2015	RH	Moved centers according to (WO# 111646)
06/09/2014 - RH - Changed BIO Conversions Flash and Budget to include Xtrands up until '6/1/2015', also added columns XtrandsConversions and XtrandsConversion_Budget (The SSRS report has not been changed).
06/30/2015 - RH - (#116003) Added	@XtrandsConvToBudget_Cap and @XtrandsConvToBudget_Weighting to separate BIO and Xtrands; Changed @EXTConversionsToBudget_Weighting to .15
06/30/2015 - RH - (#116003) Changed AccountID 10410 [BIO EXT & XTR] to 10400 [BIO]; Changed 10530 to 10532 which is BIO only
08/05/2015 - RH - (#117440) Moved 202 - Brooklyn from Small to Medium group
11/12/2015 - RH - (#120356) Added 277 - Oxnard to the Small group.
01/26/2016 - RH - (#122447) Added 262 - Baton Rouge and 299 - Broadway to the small group
02/03/2016 - RH - (#122971) Moved Centers 202, 231 to small; 249,263 to the medium group
02/04/2016 - RH - (#123009) Moved Center 216 to the small group

==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardRecurringBusiness_Groups] 5, 2015, 0, 1, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[xxx_spRpt_WarBoardRecurringBusiness_Groups] (
	@Month INT
,	@Year INT
,	@RegionSSID INT
,	@CenterType INT = 1 -- 0 All, 1 Corporate, 2 Franchise
,	@GroupSize INT      -- 1 Small, 2 Medium, 3 Large
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @BioConvToApp_Weighting NUMERIC(15,5)
	,	@BIOConversionsToBudget_Weighting NUMERIC(15,5)
	,	@BioConvToApp_Cap NUMERIC(15,5)
	,	@EXTConvToSales_Weighting NUMERIC(15,5)
	,	@EXTConversionsToBudget_Weighting NUMERIC(15,5)
	,	@EXTConvToSales_Cap NUMERIC(15,5)

	,	@XtrandsConvToBudget_Cap NUMERIC(15,5)
	,	@XtrandsConvToBudget_Weighting NUMERIC(15,5)

	,	@RollingPCP_Weighting NUMERIC(15,5)
	,	@RollingPCP_Cap NUMERIC(15,5)
	,	@NetUpgrades_Weighting NUMERIC(15,5)
	,	@NetUpgrades_Cap NUMERIC(15,5)
	,	@Benchmark NUMERIC(15,5)
	,	@SixMonthStartDate DATETIME
	,	@SixMonthEndDate DATETIME
	,	@FirstDayMonth DATETIME
	,	@LastDayMonth DATETIME
	,	@PCPLast3MonthsStart DATETIME
	,	@PCPLast3MonthsEnd DATETIME
	,	@PCPPrior3MonthsStart DATETIME
	,	@PCPPrior3MonthsEnd DATETIME

	SELECT @BioConvToApp_Weighting = .3
	,	@BIOConversionsToBudget_Weighting = .35
	,	@BioConvToApp_Cap = 2
	,	@EXTConvToSales_Weighting = .15
	,	@EXTConversionsToBudget_Weighting = .15
	,	@EXTConvToSales_Cap = 1.25

	,	@XtrandsConvToBudget_Cap =1.25
	,	@XtrandsConvToBudget_Weighting = .10

	,	@RollingPCP_Weighting = .4
	,	@RollingPCP_Cap = 1.10
	,	@NetUpgrades_Weighting = .15
	,	@NetUpgrades_Cap = 2
	,	@Benchmark = .02
	,	@FirstDayMonth = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
	,	@LastDayMonth = DATEADD(dd, -1, DATEADD(mm, 1, @FirstDayMonth))
	,	@SixMonthStartDate = DATEADD(mm, -6, @FirstDayMonth)
	,	@SixMonthEndDate = DATEADD(mm, -1, @FirstDayMonth)
	,	@PCPLast3MonthsStart = DATEADD(MONTH, -2, @FirstDayMonth)
	,	@PCPLast3MonthsEnd = @LastDayMonth
	,	@PCPPrior3MonthsStart = DATEADD(MONTH, -3, @PCPLast3MonthsStart)
	,	@PCPPrior3MonthsEnd = DATEADD(mm, -1, @PCPLast3MonthsStart)

	CREATE TABLE #Centers (
		CenterID INT
	)

	CREATE TABLE #GroupSize(
		GroupSize INT
	,	CenterID INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	RegionDescription NVARCHAR(100)
	,	BIOConversions INT
	,	BIOConversions_Budget INT
	,	Applications INT
	,	ConversionsToAppsPercent  FLOAT
	,	BIOConversionsToBudgetPercent FLOAT
	,	EXTConversions INT
	,	EXTConversions_Budget INT

	,	XtrandsConversions INT
	,	XtrandsConversions_Budget INT
	,	XtrandsConversionsToBudgetPercent FLOAT

	,	EXTSales INT
	,	ConversionsToEXTSalesPercent FLOAT
	,	EXTConversionsToBudgetPercent FLOAT
	,	CurrentPCP INT
	,	LastPCP INT
	,	RollingPCPPercent FLOAT
	,	Upgrade INT
	,	Downgrade INT
	,	NetUpgrades INT
	,	PCPCountPercent FLOAT
	,	Benchmark FLOAT
	,	UpgradePercent FLOAT
	,	Total FLOAT  --Leave for the spRpt_FranchiseWarBoards_Manager
	,	Total_Budget  FLOAT
	)

	IF @RegionSSID=0
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID AS CenterID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			WHERE c.Active='Y'
				AND (
					(@CenterType = 0 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%')
				OR (@CenterType = 1 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%')
				OR (@CenterType = 2 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[78]%')
				)
		END
	ELSE
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID AS CenterID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE R.RegionSSID=@RegionSSID
				AND c.Active='Y'
				AND (
					(@CenterType = 0 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%')
				OR (@CenterType = 1 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%')
				OR (@CenterType = 2 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[78]%')
				)
		END


	SELECT FA.CenterID
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BioConversions'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))END AS 'BioConversions_Budget'

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) = 0
			THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) END AS 'Applications'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversions'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Flash ELSE 0 END, 0)) AS 'XtrandsConversions'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))= 0 THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))END AS 'EXTConversions_Budget'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))= 0 THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))END AS 'XtrandsConversions_Budget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10515) THEN Flash ELSE 0 END, 0)) AS 'PCPUpgradeCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10510) THEN Flash ELSE 0 END, 0)) AS 'PCPDowngradeCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10400) THEN Flash ELSE 0 END, 0)) AS 'CurrentMonthPCPCount'
	INTO #Accounting
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
	WHERE MONTH(FA.PartitionDate)=@Month
	  AND YEAR(FA.PartitionDate)=@Year
	GROUP BY FA.CenterID


	-- Get EXT 6 Months Rolling Average - Center
	SELECT  FA.CenterID
	,	ROUND(SUM(ISNULL(Flash, 0)) / 6, 0) AS 'SixMonthEXTSales'
	INTO #SixMonthExtAverage
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
     WHERE FA.PartitionDate BETWEEN @SixMonthStartDate AND @SixMonthEndDate + '23:59'
		AND FA.AccountID IN (10215)
     GROUP BY FA.CenterID


	--PCP Rolling 3 months
	SELECT FA.CenterID
	,	ROUND(SUM(ISNULL(Flash, 0)),0) AS 'PCPLast3Months'
	INTO #PCPLast3Months
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
	WHERE FA.AccountID IN (10532)
		AND FA.PartitionDate BETWEEN @PCPLast3MonthsStart AND @PCPLast3MonthsEnd
	GROUP BY FA.CenterID


	SELECT FA.CenterID
	,	ROUND(SUM(ISNULL(FlashReporting, 0)),0) AS 'PCPPrior3Months'
	INTO #PCPPrior3Months
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
	WHERE FA.AccountID IN (10532)
		AND FA.PartitionDate BETWEEN @PCPPrior3MonthsStart AND @PCPPrior3MonthsEnd
	GROUP BY FA.CenterID


	SELECT c.CenterID
	,	ISNULL(a.BioConversions, 0) AS 'BIOConversions'
	,	ISNULL(a.BIOConversions_Budget, 1) AS 'BIOConversions_Budget'
	,	ISNULL(a.Applications, 0) AS 'Applications'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0)) > @BioConvToApp_Cap
			THEN @BioConvToApp_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0))
		END AS 'ConversionsToAppsPercent'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.BioConversions_Budget, 0)) > @BioConvToApp_Cap
			THEN @BioConvToApp_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.BioConversions_Budget, 0))
		END AS 'BIOConversionsToBudgetPercent'
	,	ISNULL(a.EXTConversions, 0) AS 'EXTConversions'
	,	ISNULL(a.EXTConversions_Budget, 1) AS 'EXTConversions_Budget'

	,	ISNULL(a.XtrandsConversions, 0) AS 'XtrandsConversions'
	,	ISNULL(a.XtrandsConversions_Budget, 0) AS 'XtrandsConversions_Budget'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.XtrandsConversions, 0), ISNULL(a.XtrandsConversions_Budget, 0)) > @XtrandsConvToBudget_Cap
			THEN @XtrandsConvToBudget_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.XtrandsConversions, 0), ISNULL(a.XtrandsConversions_Budget, 0))
		END AS 'XtrandsConversionsToBudgetPercent'

	,	ISNULL(SA.SixMonthEXTSales, 0) AS 'EXTSales'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.EXTConversions, 0), ISNULL(SA.SixMonthEXTSales, 0)) > @EXTConvToSales_Cap
			THEN @EXTConvToSales_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.EXTConversions, 0), ISNULL(SA.SixMonthEXTSales, 0))
		END AS 'ConversionsToEXTSalesPercent'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.EXTConversions, 0), ISNULL(a.EXTConversions_Budget, 0)) > @EXTConvToSales_Cap
			THEN @EXTConvToSales_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.EXTConversions, 0), ISNULL(a.EXTConversions_Budget, 0))
		END AS 'EXTConversionsToBudgetPercent'
	,	ISNULL(PLast.PCPLast3Months, 0) AS 'CurrentPCP'
	,	ISNULL(PPrior.PCPPrior3Months, 0) AS 'LastPCP'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(PLast.PCPLast3Months, 0), ISNULL(PPrior.PCPPrior3Months, 0)) > @RollingPCP_Cap
			THEN @RollingPCP_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(PLast.PCPLast3Months, 0), ISNULL(PPrior.PCPPrior3Months, 0))
		END AS 'RollingPCPPercent'
	,	ISNULL(a.PCPUpgradeCount, 0) AS 'Upgrade'
	,	ISNULL(a.PCPDowngradeCount, 0) AS 'Downgrade'
	,	ISNULL(a.PCPUpgradeCount, 0) - ISNULL(a.PCPDowngradeCount, 0) AS 'NetUpgrades'
	,	dbo.DIVIDE_NOROUND((ISNULL(a.PCPUpgradeCount, 0) - ISNULL(a.PCPDowngradeCount, 0)), ISNULL(a.CurrentMonthPCPCount, 0)) AS 'PCPCountPercent'
	,	@Benchmark AS 'Benchmark'
	,	CASE WHEN dbo.DIVIDE_NOROUND(dbo.DIVIDE_NOROUND((ISNULL(a.PCPUpgradeCount, 0) - ISNULL(a.PCPDowngradeCount, 0)), ISNULL(a.CurrentMonthPCPCount, 0)), @Benchmark) > @NetUpgrades_Cap
			THEN @NetUpgrades_Cap
			ELSE dbo.DIVIDE_NOROUND(dbo.DIVIDE_NOROUND((ISNULL(a.PCPUpgradeCount, 0) - ISNULL(a.PCPDowngradeCount, 0)), ISNULL(a.CurrentMonthPCPCount, 0)), @Benchmark)
		END AS 'UpgradePercent'
	INTO #Final
	FROM #Centers c
		LEFT OUTER JOIN #Accounting a
			ON c.CenterID = a.CenterID
		LEFT OUTER JOIN #SixMonthExtAverage SA
			ON C.CenterID = SA.CenterID
		LEFT OUTER JOIN #PCPLast3Months PLast
			ON C.CenterID = PLast.CenterID
		LEFT OUTER JOIN #PCPPrior3Months PPrior
			ON C.CenterID = PPrior.CenterID

	INSERT INTO #GroupSize
	SELECT 1 AS 'GroupSize'  --Small
	,	F.CenterID
	,	C.CenterDescriptionNumber
	,	R.RegionDescription
	,	F.BIOConversions
	,	F.BIOConversions_Budget
	,	F.Applications
	,	F.ConversionsToAppsPercent
	,	F.BIOConversionsToBudgetPercent
	,	F.EXTConversions
	,	F.EXTConversions_Budget
	,	F.XtrandsConversions
	,	F.XtrandsConversions_Budget

	,	F.XtrandsConversionsToBudgetPercent

	,	F.EXTSales
	,	F.ConversionsToEXTSalesPercent
	,	F.EXTConversionsToBudgetPercent
	,	F.CurrentPCP
	,	F.LastPCP
	,	F.RollingPCPPercent
	,	F.Upgrade
	,	F.Downgrade
	,	F.NetUpgrades
	,	F.PCPCountPercent
	,	F.Benchmark
	,	F.UpgradePercent
	,	(ConversionsToAppsPercent * @BioConvToApp_Weighting)
			+ (ConversionsToEXTSalesPercent * @EXTConvToSales_Weighting)
			+ (XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
			+ (UpgradePercent * @NetUpgrades_Weighting)
			+ (RollingPCPPercent * @RollingPCP_Weighting)
		AS 'Total'
	,	((F.BIOConversionsToBudgetPercent * @BIOConversionsToBudget_Weighting)
		+ (F.EXTConversionsToBudgetPercent * @EXTConversionsToBudget_Weighting)
		+ (F.XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
		+ (F.RollingPCPPercent * @RollingPCP_Weighting))
		AS 'Total_Budget'
	FROM #Final f
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON F.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE CenterID IN(243,239,289,232,244,242,290,291,241,223,224,285,227,265,218,288,215,293,267,268,278,258,264,219,253,254,217,234,272,236,277,262,299,202,231,216)
	UNION
	SELECT 2 AS 'GroupSize' --Medium
	,	F.CenterID
	,	C.CenterDescriptionNumber
	,	R.RegionDescription
	,	F.BIOConversions
	,	F.BIOConversions_Budget
	,	F.Applications
	,	F.ConversionsToAppsPercent
	,	F.BIOConversionsToBudgetPercent
	,	F.EXTConversions
	,	F.EXTConversions_Budget
	,	F.XtrandsConversions
	,	F.XtrandsConversions_Budget

	,	F.XtrandsConversionsToBudgetPercent

	,	F.EXTSales
	,	F.ConversionsToEXTSalesPercent
	,	F.EXTConversionsToBudgetPercent
	,	F.CurrentPCP
	,	F.LastPCP
	,	F.RollingPCPPercent
	,	F.Upgrade
	,	F.Downgrade
	,	F.NetUpgrades
	,	F.PCPCountPercent
	,	F.Benchmark
	,	F.UpgradePercent
	,	(ConversionsToAppsPercent * @BioConvToApp_Weighting)
			+ (ConversionsToEXTSalesPercent * @EXTConvToSales_Weighting)
			+ (XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
			+ (UpgradePercent * @NetUpgrades_Weighting)
			+ (RollingPCPPercent * @RollingPCP_Weighting)
		AS 'Total'
	,	((F.BIOConversionsToBudgetPercent * @BIOConversionsToBudget_Weighting)
		+ (F.EXTConversionsToBudgetPercent * @EXTConversionsToBudget_Weighting)
		+ (F.XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
		+ (F.RollingPCPPercent * @RollingPCP_Weighting))
		AS 'Total_Budget'
	FROM #Final f
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON F.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE CenterID IN(275,208,228,294,221,210,212,206,214,222,237,292,255,226,295,283,281,260,235,225,287,274,296,251,284,249,257,263)
	UNION
		SELECT 3 AS 'GroupSize'  --Large
	,	F.CenterID
	,	C.CenterDescriptionNumber
	,	R.RegionDescription
	,	F.BIOConversions
	,	F.BIOConversions_Budget
	,	F.Applications
	,	F.ConversionsToAppsPercent
	,	F.BIOConversionsToBudgetPercent
	,	F.EXTConversions
	,	F.EXTConversions_Budget
	,	F.XtrandsConversions
	,	F.XtrandsConversions_Budget

	,	F.XtrandsConversionsToBudgetPercent

	,	F.EXTSales
	,	F.ConversionsToEXTSalesPercent
	,	F.EXTConversionsToBudgetPercent
	,	F.CurrentPCP
	,	F.LastPCP
	,	F.RollingPCPPercent
	,	F.Upgrade
	,	F.Downgrade
	,	F.NetUpgrades
	,	F.PCPCountPercent
	,	F.Benchmark
	,	F.UpgradePercent
	,	(ConversionsToAppsPercent * @BioConvToApp_Weighting)
			+ (ConversionsToEXTSalesPercent * @EXTConvToSales_Weighting)
			+ (XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
			+ (UpgradePercent * @NetUpgrades_Weighting)
			+ (RollingPCPPercent * @RollingPCP_Weighting)
		AS 'Total'
	,	((F.BIOConversionsToBudgetPercent * @BIOConversionsToBudget_Weighting)
		+ (F.EXTConversionsToBudgetPercent * @EXTConversionsToBudget_Weighting)
		+ (F.XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
		+ (F.RollingPCPPercent * @RollingPCP_Weighting))
		AS 'Total_Budget'
	FROM #Final f
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON F.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE CenterID IN(276,261,259,213,280,207,204,286,209,211,229,240,282,205,271,250,203,220,230,201,270,252,256)

	IF @GroupSize = 0
	BEGIN
		SELECT * FROM #GroupSize
	END
	ELSE
	BEGIN
		SELECT * FROM #GroupSize
		WHERE GroupSize = @GroupSize
	END


END
