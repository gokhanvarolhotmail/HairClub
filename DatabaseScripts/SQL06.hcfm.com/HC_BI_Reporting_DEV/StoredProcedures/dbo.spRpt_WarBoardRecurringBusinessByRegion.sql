/* CreateDate: 03/09/2016 11:37:05.133 , ModifyDate: 11/21/2019 13:44:30.330 */
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardRecurringBusinessByRegion

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	Recurring Business War Board - USED FOR THE FRANCHISES
This report is called by the stored procedure [dbo].[spRpt_FranchiseWarBoards_Manager]
==============================================================================
NOTES:
WHEN FIELDS CHANGE IN THIS STORED PROCEDURE ALSO CHANGE THEM IN THIS STORED PROCEDURE: [spRpt_FranchiseWarBoards_Manager]

04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
02/24/2014 - RH - (WO#97704) Added BioConversions_Budget, @BIOConversionsToBudget_Weighting
					and EXTConversions_Budget, @EXTConversionsToBudget_Weighting;
					Changed @RollingPCP_Weighting to .4; Changed Total formula accordingly.
03/04/2014 - RH - Changed Budget to CAST(Budget AS INT) for whole numbers.
03/05/2014 - RH - Added variables and fields for the Franchise version of the report - WarBoard_Franchise_RecurringCustomer.rdl
					@FranchBioConvToApp_Cap, @FranchRollingPCP_Weighting, FranchiseConversionsToAppsPercent, Total_Franchise
04/10/2014 - RH - Added (@CenterType = 0 AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%') to remove 300 and 500 centers.
					Changed CAST(Budget AS INT) to CAST(Budget AS DECIMAL(10,0))
					Changed for BioConversions_Budget: CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) = 0
					THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0)) END AS 'BioConversions_Budget'
04/14/2014 - RH - Applied the same change as above to EXTConversions_Budget.
04/21/2014 - RH - For PCP amounts: ROUND(SUM(ISNULL(Flash, 0)),0) and ROUND(SUM(ISNULL(FlashReporting, 0)),0);
					Changed this stored procedure to be a clone of the other two procedures - spRpt_WarBoardRecurringBusiness
					and spRpt_WarBoardRecurringBusiness_Groups so that the counts would be the same.
06/09/2014 - RH - Changed BIO Conversions Flash and Budget to include Xtrands up until '6/1/2015', also added columns XtrandsConversions and XtrandsConversion_Budget (The SSRS report has not been changed).
06/30/2015 - RH - (#116003) Added	@XtrandsConvToBudget_Cap and @XtrandsConvToBudget_Weighting to separate BIO and Xtrands; Changed @EXTConversionsToBudget_Weighting to .15
06/30/2015 - RH - (#116003) Changed AccountID 10410 [BIO EXT & XTR] to 10400 [BIO]; Changed 10530 to 10532 which is BIO only
10/24/2016 - RH - (#130695) Added XTR Conversions to EXT Conversions, and XTR Sales to EXT Sales; Changed goals and weighting
03/06/2017 - RH - (#136062) Added @XTRPlusConversionsToBudget_Cap of 2.00; Added @NetUpgrades_Cap of 1.25
04/24/2018 - RH - (#145957) Replaced Corporate Regions with Areas, Changed CenterSSID to CenterNumber
11/21/2019 - RH - (TrackIT 2159) Changed the #MainGroup table definition to match the Franchise version of this report - [spRpt_FranchiseWarBoards_Manager]
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardRecurringBusinessByRegion] 10, 2019, 0, 1

EXEC [spRpt_WarBoardRecurringBusinessByRegion] 10, 2019, 0, 2
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardRecurringBusinessByRegion] (
	@Month INT
,	@Year INT
,	@RegionSSID INT = 0
,	@CenterType INT  -- 1 Corporate, 2 Franchise
)

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


DECLARE  @BioConvToApp_Weighting NUMERIC(15,5)
,	@BioConvToApp_Cap NUMERIC(15,5)

,	@EXTXTRConvToSales_Weighting NUMERIC(15,5)
,	@EXTXTRConvToSales_Cap NUMERIC(15,5)

,	@RollingPCP_Weighting NUMERIC(15,5)
,	@RollingPCP_Cap NUMERIC(15,5)

,	@NetUpgrades_Weighting NUMERIC(15,5)
,	@NetUpgrades_Cap NUMERIC(15,5)

,	@XTRPlusConversionsToBudget_Cap DECIMAL(18,4)

,	@Benchmark NUMERIC(15,5)
,	@SixMonthStartDate DATETIME
,	@SixMonthEndDate DATETIME
,	@FirstDayMonth DATETIME
,	@LastDayMonth DATETIME
,	@PCPLast3MonthsStart DATETIME
,	@PCPLast3MonthsEnd DATETIME
,	@PCPPrior3MonthsStart DATETIME
,	@PCPPrior3MonthsEnd DATETIME

SELECT @BioConvToApp_Weighting = .30
,	@EXTXTRConvToSales_Weighting = .15
,	@RollingPCP_Weighting = .40
,	@NetUpgrades_Weighting = .15

,	@BioConvToApp_Cap = 2.00
,	@XTRPlusConversionsToBudget_Cap = 2.00
,	@EXTXTRConvToSales_Cap = 1.25
,	@RollingPCP_Cap = 1.10
,	@NetUpgrades_Cap = 1.25

,	@Benchmark = .02
,	@FirstDayMonth = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
,	@LastDayMonth = DATEADD(dd, -1, DATEADD(mm, 1, @FirstDayMonth))
,	@SixMonthStartDate = DATEADD(mm, -6, @FirstDayMonth)
,	@SixMonthEndDate = DATEADD(mm, -1, @FirstDayMonth)
,	@PCPLast3MonthsStart = DATEADD(MONTH, -2, @FirstDayMonth)
,	@PCPLast3MonthsEnd = @LastDayMonth
,	@PCPPrior3MonthsStart = DATEADD(MONTH, -3, @PCPLast3MonthsStart)
,	@PCPPrior3MonthsEnd = DATEADD(mm, -1, @PCPLast3MonthsStart)

/****************************************************************************************/
--Create temp tables
/****************************************************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
)

--DROP TABLE #MainGroup
CREATE TABLE #MainGroup(
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterID INT
,	CenterDescriptionNumber VARCHAR(104)

,	BIOConversions INT
,	Applications INT
,	ConversionsToAppsPercent  DECIMAL(18,4)

,	EXTXTRConversion INT
,	EXTXTRSales INT
,	EXTXTRConversionsToEXTXTRSalesPercent DECIMAL(18,4)

,	CurrentPCP INT
,	LastPCP INT
,	RollingPCPPercent DECIMAL(18,4)

,	Upgrade INT
,	Downgrade INT
,	NetUpgrades INT
,	PCPCountPercent DECIMAL(18,4)
,	Benchmark DECIMAL(18,4)
,	UpgradePercent DECIMAL(18,4)

,	Total_Franchise DECIMAL(18,4)
)

/****************************************************************************************/
--Populate #Centers
/****************************************************************************************/

IF @CenterType = 1 AND @RegionSSID=0  --All Corporate
	BEGIN
		INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
				,		CMA.CenterManagementAreaDescription AS MainGroup
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE	DC.Active = 'Y'
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
	END
ELSE
IF @CenterType = 2 AND @RegionSSID=0  -- All Franchises
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS MainGroupID
				,		DR.RegionDescription AS MainGroup
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END
ELSE
IF @CenterType = 1 AND @RegionSSID <> 0  --Corporate per Area
		BEGIN
		INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
				,		CMA.CenterManagementAreaDescription AS MainGroup
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE	DC.Active = 'Y'
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
				AND CMA.CenterManagementAreaSSID = @RegionSSID
	END
ELSE
IF @CenterType = 2 AND @RegionSSID <> 0   --Franchise per Region
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS MainGroupID
				,		DR.RegionDescription AS MainGroup
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
						AND DR.RegionSSID = @RegionSSID
	END

/****************************************************************************************/
--Get data from FactAccounting
/****************************************************************************************/

SELECT FA.CenterID
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BioConversions'

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) = 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) END AS 'Applications'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversions'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Flash ELSE 0 END, 0)) AS 'XtrandsConversions'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10515) THEN Flash ELSE 0 END, 0)) AS 'PCPUpgradeCount'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10510) THEN Flash ELSE 0 END, 0)) AS 'PCPDowngradeCount'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10400) THEN Flash ELSE 0 END, 0)) AS 'CurrentMonthPCPCount'
INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
GROUP BY FA.CenterID

/****************************************************************************************/
-- Get EXT - 6 Months Rolling Average - Center
/****************************************************************************************/

SELECT  FA.CenterID
,	ROUND(SUM(ISNULL(Flash, 0)) / 6, 0) AS 'SixMonthEXTSales'
INTO #SixMonthExtAverage
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
    WHERE FA.PartitionDate BETWEEN @SixMonthStartDate AND @SixMonthEndDate + '23:59'
	AND FA.AccountID IN (10215)
    GROUP BY FA.CenterID

/****************************************************************************************/
-- Get Xtrands - 6 Months Rolling Average - Center
/****************************************************************************************/

SELECT  FA.CenterID
,	ROUND(SUM(ISNULL(Flash, 0)) / 6, 0) AS 'SixMonthXTRSales'
INTO #SixMonthXtrAverage
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
    WHERE FA.PartitionDate BETWEEN @SixMonthStartDate AND @SixMonthEndDate + '23:59'
	AND FA.AccountID IN (10206)
    GROUP BY FA.CenterID

/****************************************************************************************/
--PCP Rolling 3 months
/****************************************************************************************/

SELECT FA.CenterID
,	ROUND(SUM(ISNULL(Flash, 0)),0) AS 'PCPLast3Months'
INTO #PCPLast3Months
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
WHERE FA.AccountID = 10532  --10532 - PCP - BIO Sales $
	AND FA.PartitionDate BETWEEN @PCPLast3MonthsStart AND @PCPLast3MonthsEnd
GROUP BY FA.CenterID

/****************************************************************************************/
--PCP Prior 3 months
/****************************************************************************************/

SELECT FA.CenterID
,	ROUND(SUM(ISNULL(FlashReporting, 0)),0) AS 'PCPPrior3Months'
INTO #PCPPrior3Months
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
WHERE FA.AccountID = 10532  --10532 - PCP - BIO Sales $
	AND FA.PartitionDate BETWEEN @PCPPrior3MonthsStart AND @PCPPrior3MonthsEnd
GROUP BY FA.CenterID

/****************************************************************************************/
--Populate #Final
/****************************************************************************************/

SELECT c.CenterNumber
,	ISNULL(a.BioConversions, 0) AS 'BIOConversions'
,	ISNULL(a.Applications, 0) AS 'Applications'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0)) > @BioConvToApp_Cap
		THEN @BioConvToApp_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.Applications, 0))
	END AS 'ConversionsToAppsPercent'

,	ISNULL(a.EXTConversions, 0) AS 'EXTConversions'
,	ISNULL(a.XtrandsConversions, 0) AS 'XtrandsConversions'

,	ISNULL(SA.SixMonthEXTSales, 0) AS 'EXTSales'
,	ISNULL(SXTR.SixMonthXTRSales, 0) AS  'XTRSales'

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
		ON c.CenterNumber = a.CenterID
	LEFT OUTER JOIN #SixMonthExtAverage SA
		ON C.CenterNumber = SA.CenterID
	LEFT OUTER JOIN #SixMonthXtrAverage SXTR
		ON C.CenterNumber = SXTR.CenterID
	LEFT OUTER JOIN #PCPLast3Months PLast
		ON C.CenterNumber = PLast.CenterID
	LEFT OUTER JOIN #PCPPrior3Months PPrior
		ON C.CenterNumber = PPrior.CenterID

/****************************************************************************************/
--Find EXTXTRConversionsToEXTXTRSalesPercent
/****************************************************************************************/

INSERT INTO #MainGroup
SELECT 	C.MainGroupID
,	C.MainGroup
,	F.CenterNumber AS 'CenterID'
,	C.CenterDescriptionNumber

,	F.BIOConversions
,	F.Applications
,	F.ConversionsToAppsPercent

,	(F.EXTConversions + F.XtrandsConversions) AS EXTXTRConversion
,	(F.EXTSales + F.XTRSales) AS EXTXTRSales
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(F.EXTConversions + F.XtrandsConversions, 0), ISNULL(F.EXTSales + F.XTRSales, 0)) > @EXTXTRConvToSales_Cap
		THEN @EXTXTRConvToSales_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(F.EXTConversions + F.XtrandsConversions, 0), ISNULL(F.EXTSales + F.XTRSales, 0))
		END AS 'EXTXTRConversionsToEXTXTRSalesPercent'

,	F.CurrentPCP
,	F.LastPCP
,	F.RollingPCPPercent

,	F.Upgrade
,	F.Downgrade
,	F.NetUpgrades
,	F.PCPCountPercent
,	F.Benchmark
,	F.UpgradePercent
,	NULL AS Franchise_Total
FROM #Final f
INNER JOIN #Centers C
	ON C.CenterNumber = f.CenterNumber

/****************************************************************************************/
--Final select statement with weightings
/****************************************************************************************/

SELECT MainGroupID
	,	MainGroup
	,	CenterID
	,	CenterDescriptionNumber
        , BIOConversions
        , Applications
        , ConversionsToAppsPercent

        , EXTXTRConversion
        , EXTXTRSales
        , EXTXTRConversionsToEXTXTRSalesPercent

        , CurrentPCP
        , LastPCP
        , RollingPCPPercent
        , Upgrade
        , Downgrade
        , NetUpgrades
        , PCPCountPercent
        , Benchmark
        , UpgradePercent

        , ((ConversionsToAppsPercent * @BioConvToApp_Weighting)
		+ (EXTXTRConversionsToEXTXTRSalesPercent * @EXTXTRConvToSales_Weighting)
		+ (RollingPCPPercent * @RollingPCP_Weighting)
		+ (UpgradePercent * @NetUpgrades_Weighting))
		AS 'Total_Franchise'
FROM #MainGroup








END
GO
