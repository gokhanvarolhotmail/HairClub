/* CreateDate: 08/07/2012 15:14:02.460 , ModifyDate: 03/07/2016 16:09:05.900 */
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardRecurringBusiness

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	Recurring Business War Board
==============================================================================
CHANGE HISTORY:
04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
02/24/2014 - RH - (WO#97704) Added BioConversions_Budget, @BIOConversionsToBudget_Weighting
					and EXTConversions_Budget, @EXTConversionsToBudget_Weighting;
					Changed @RollingPCP_Weighting to .4; Changed Total formula accordingly.
03/04/2014 - RH - Changed Budget to CAST(Budget AS INT) for whole numbers.
03/05/2014 - RH - Added variables and fields for the Franchise version of the report - WarBoard_Franchise_RecurringCustomer.rdl
					@FranchBioConvToApp_Cap, @FranchRollingPCP_Weighting, FranchiseConversionsToAppsPercent, Total_Franchise;
					Changed Budget values to default to 1.
04/10/2014 - RH - Added (@CenterType = 0 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%') to remove 300 and 500 centers.
					Changed CAST(Budget AS INT) to CAST(Budget AS DECIMAL(10,0)).
04/21/2014 - RH - For PCP amounts: ROUND(SUM(ISNULL(Flash, 0)),0) and ROUND(SUM(ISNULL(FlashReporting, 0)),0)
06/09/2014 - RH - Changed BIO Conversions Flash and Budget to include Xtrands up until '6/1/2015', also added columns XtrandsConversions and XtrandsConversion_Budget (The SSRS report has not been changed).
06/30/2015 - RH - (WO#116003) Added	@XtrandsConvToBudget_Cap and @XtrandsConvToBudget_Weighting to separate BIO and Xtrands; Changed @EXTConversionsToBudget_Weighting to .15
06/30/2015 - RH - (WO#116003) Changed AccountID 10410 [BIO EXT & XTR] to 10400 [BIO]; Changed 10530 to 10532 which is BIO only

==============================================================================

NOTES:
*** WHEN FIELDS CHANGE IN THIS STORED PROCEDURE ALSO CHANGE THEM IN THIS STORED PROCEDURE: [spRpt_FranchiseWarBoards_Manager]

==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardRecurringBusiness] 5, 2015, 0, 1

EXEC [spRpt_WarBoardRecurringBusiness] 2, 2015, 0, 2
==============================================================================
*/
CREATE PROCEDURE [dbo].[xxx_spRpt_WarBoardRecurringBusiness] (
	@Month INT
,	@Year INT
,	@RegionSSID INT
,	@CenterType INT  -- 0 All, 1 Corporate, 2 Franchise
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @BioConvToApp_Weighting NUMERIC(15,5)
	,	@BIOConversionsToBudget_Weighting NUMERIC(15,5)
	,	@BioConvToApp_Cap NUMERIC(15,5)
	,	@FranchBioConvToApp_Cap NUMERIC(15,5)
	,	@EXTConvToSales_Weighting NUMERIC(15,5)
	,	@EXTConversionsToBudget_Weighting NUMERIC(15,5)
	,	@EXTConvToSales_Cap NUMERIC(15,5)

	,	@XtrandsConvToBudget_Cap NUMERIC(15,5)
	,	@XtrandsConvToBudget_Weighting NUMERIC(15,5)

	,	@RollingPCP_Weighting NUMERIC(15,5)
	,	@FranchRollingPCP_Weighting NUMERIC(15,5)
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
	,	@FranchBioConvToApp_Cap = 1.2
	,	@EXTConvToSales_Weighting = .15
	,	@EXTConversionsToBudget_Weighting = .15
	,	@EXTConvToSales_Cap = 1.25

	,	@XtrandsConvToBudget_Cap =1.25
	,	@XtrandsConvToBudget_Weighting = .10

	,	@FranchRollingPCP_Weighting = .35
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

	IF @RegionSSID=0
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
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
			SELECT c.CenterSSID
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

	--Find Flash and Budget values from FactAccounting
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
	WHERE FA.AccountID = 10532  --10532 - PCP - BIO Sales $
		AND FA.PartitionDate BETWEEN @PCPLast3MonthsStart AND @PCPLast3MonthsEnd
	GROUP BY FA.CenterID

	SELECT FA.CenterID
	,	ROUND(SUM(ISNULL(FlashReporting, 0)),0) AS 'PCPPrior3Months'
	INTO #PCPPrior3Months
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
	WHERE FA.AccountID = 10532  --10532 - PCP - BIO Sales $
		AND FA.PartitionDate BETWEEN @PCPPrior3MonthsStart AND @PCPPrior3MonthsEnd
	GROUP BY FA.CenterID


	SELECT c.CenterID
	,	ISNULL(a.BioConversions, 0) AS 'BIOConversions'
	,	ISNULL(a.BIOConversions_Budget, 0) AS 'BIOConversions_Budget'
	,	ISNULL(a.Applications, 0) AS 'Applications'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0)) > @BioConvToApp_Cap
			THEN @BioConvToApp_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0))
		END AS 'ConversionsToAppsPercent'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0)) > @FranchBioConvToApp_Cap
			THEN @FranchBioConvToApp_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0))
		END AS 'FranchiseConversionsToAppsPercent'
	,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.BioConversions_Budget, 0)) > @BioConvToApp_Cap
			THEN @BioConvToApp_Cap
			ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.BioConversions_Budget, 0))
		END AS 'BIOConversionsToBudgetPercent'
	,	ISNULL(a.EXTConversions, 0) AS 'EXTConversions'
	,	ISNULL(a.EXTConversions_Budget, 0) AS 'EXTConversions_Budget'

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
	,	ISNULL(PLast.PCPLast3Months, 0) AS 'PCPLast3Months'
	,	ISNULL(PPrior.PCPPrior3Months, 0) AS 'PCPPrior3Months'
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

	SELECT F.CenterID
	,	C.CenterDescriptionNumber
	,	R.RegionDescription
	,	F.BIOConversions
	,	F.BIOConversions_Budget
	,	F.Applications
	,	F.ConversionsToAppsPercent
	,	F.FranchiseConversionsToAppsPercent
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
	,	((ConversionsToAppsPercent * @BioConvToApp_Weighting)
			+ (ConversionsToEXTSalesPercent * @EXTConvToSales_Weighting)
			+ (XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
			+ (UpgradePercent * @NetUpgrades_Weighting)
			+ (RollingPCPPercent * @RollingPCP_Weighting))
		AS 'Total'
	,	((F.BIOConversionsToBudgetPercent * @BIOConversionsToBudget_Weighting)
		+ (F.EXTConversionsToBudgetPercent * @EXTConversionsToBudget_Weighting)
		+ (F.XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
		+ (F.RollingPCPPercent * @RollingPCP_Weighting))
		AS 'Total_Budget'
	,	((FranchiseConversionsToAppsPercent * @BioConvToApp_Weighting)
		+ (ConversionsToEXTSalesPercent * @EXTConvToSales_Weighting)
		+ (XtrandsConversionsToBudgetPercent * @XtrandsConvToBudget_Weighting)
		+ (UpgradePercent * @NetUpgrades_Weighting)
		+ (RollingPCPPercent * @FranchRollingPCP_Weighting))
		AS 'Total_Franchise'
	FROM #Final f
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON F.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
END
GO
