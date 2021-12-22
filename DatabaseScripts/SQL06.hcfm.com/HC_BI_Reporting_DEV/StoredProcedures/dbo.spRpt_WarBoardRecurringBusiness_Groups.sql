/* CreateDate: 03/07/2016 15:19:27.507 , ModifyDate: 01/27/2020 16:05:44.743 */
GO
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
03/07/2016 - RH - (#123247) Added EXTandXTRConversions,EXTandXTRConversions_Budget, @XTRPlusConversionsToBudget_Weighting, changed weightings
03/10/2016 - RH - (#123247) Changed PCPRevenue to the same as the Flash RB and the PCPRevenue_Budget to use AccountID IN(10536,3015)
04/21/2016 - RH - (#125557) Changed '202 - Brooklyn' to Medium from Small group
09/22/2016 - RH - (#130315) Add rounding to the Upgrade, Upgrade Goal and Percent
01/25/2017 - RH - (#134998) Added 245 - Pickering to the small group
03/06/2017 - RH - (#136062) Added @XTRPlusConversionsToBudget_Cap of 2.00; Added @NetUpgrades_Cap of 1.25; Changed to use new fields in the DimCenter table
08/04/2017 - RH - (#141607) Added CASE WHEN UpgradeGoal = 0 THEN 1 ELSE UpgradeGoal END AS 'UpgradeGoal'; CASE WHEN UpgradeGoal = 0 THEN (Upgrade/1) ELSE UpgradePercent END AS 'UpgradePercent'
04/24/2018 - RH - (#145957) Replaced Corporate Regions with Areas, Changed CenterSSID to CenterNumber
11/25/2019 - RH - (TrackIT 3796) Replaced CenterSSID with CenterNumber in the PCP Revenue section
01/27/2020 - RH - (TrackIT 1325) Added Service and Retail to PCP $

*** WHEN FIELDS CHANGE IN THIS STORED PROCEDURE ALSO CHANGE THEM IN THIS STORED PROCEDURE: [spRpt_FranchiseWarBoards_Manager]

==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardRecurringBusiness_Groups] 1, 2020, 0, 1, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardRecurringBusiness_Groups] (
	@Month INT
,	@Year INT
,	@RegionSSID INT
,	@CenterType INT = 1 -- 1 Corporate, 2 Franchise
,	@GroupSize INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

DECLARE @FirstDayMonth DATETIME
	,	@LastDayOfMonth DATETIME
	,	@PCPLastMonthDate DATETIME
	,	@EXTandXTRConversionsToBudget_Cap DECIMAL(18,4)
	,	@PCPRevenueToBudget_Cap DECIMAL(18,4)
	,	@XTRPlusConversionsToBudget_Cap DECIMAL(18,4)
	,	@NetUpgrades_Cap DECIMAL(18,4)

	,	@XTRPlusConversionsToBudget_Weighting DECIMAL(18,4)
	,	@EXTandXTRConversionsToBudget_Weighting DECIMAL(18,4)
	,	@UpgradePercent_Weighting DECIMAL(18,4)
	,	@PCPRevenueToBudget_Weighting DECIMAL(18,4)

SELECT @FirstDayMonth = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
	,	@LastDayOfMonth = DATEADD(ms,-3,(DATEADD(MM,1,@FirstDayMonth)))
	,	@PCPLastMonthDate = DATEADD(mm, -1, @FirstDayMonth)

	,	@XTRPlusConversionsToBudget_Cap = 2.00
	,	@NetUpgrades_Cap = 1.25
	,	@EXTandXTRConversionsToBudget_Cap = 1.25
	,	@PCPRevenueToBudget_Cap = 1.10

	,	@XTRPlusConversionsToBudget_Weighting = .30
	,	@EXTandXTRConversionsToBudget_Weighting = .25
	,	@UpgradePercent_Weighting = .15
	,	@PCPRevenueToBudget_Weighting = .3


/********************** Set up temp tables ******************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
,	RecurringBusinessSize VARCHAR(10)
)


CREATE TABLE #RetailSales (
	CenterNumber INT
,	RetailSales MONEY
)


CREATE TABLE #GroupSize(
	GroupSize INT
	,	MainGroupID INT
	,	MainGroup NVARCHAR(50)
	,	CenterID INT
	,	CenterDescriptionNumber NVARCHAR(103)
	,	XTRPlusConversions INT
	,	XTRPlusConversions_Budget INT
	,	XTRPlusConversionsToBudgetPercent DECIMAL(18,4)
	,	EXTandXTRConversions INT
	,	EXTandXTRConversions_Budget INT
	,	EXTandXTRConversionsToBudgetPercent DECIMAL(18,4)
	,	Upgrade INT
	,	UpgradeGoal DECIMAL(18,4)
	,	UpgradePercent DECIMAL(18,4)
	,	PCPLastMonth INT
	,	PCPRevenue MONEY
	,	PCPRevenue_Budget MONEY
	,	PCPRevenueToBudgetPercent DECIMAL(18,4)
	,	Total DECIMAL(18,4)
)

/********************** Find Centers ******************************************************/

IF @CenterType = 1 AND @RegionSSID=0  --All Corporate
	BEGIN
		INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
				,		CMA.CenterManagementAreaDescription AS MainGroup
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				,		DC.RecurringBusinessSize
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
				,		DC.RecurringBusinessSize
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
				,		DC.RecurringBusinessSize
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
				,		DC.RecurringBusinessSize
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
						AND DR.RegionSSID = @RegionSSID
	END


/********************** Find Conversions and PCP Upgrades ***********************************************/
SELECT FA.CenterID
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'XTRPlusConversions'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))END AS 'XTRPlusConversions_Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversions'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))END AS 'EXTConversions_Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN Flash ELSE 0 END, 0)) AS 'XtrandsConversions'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN CAST(Budget AS DECIMAL(10,0)) ELSE 0 END, 0))END AS 'XtrandsConversions_Budget'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10515) THEN Flash ELSE 0 END, 0)) AS 'PCPUpgradeCount'
INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
GROUP BY FA.CenterID

/********************** Get PCP Count for the past month ************************************************************/
SELECT FA.CenterID
,	ROUND(SUM(ISNULL(Flash, 0)),0) AS 'PCPLastMonth'
INTO #PCPLastMonth
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  ---FactAccounting has Colorado Springs listed as CenterID = 238
WHERE FA.AccountID = 10400  --10400 - PCP - BIO Active PCP #
	AND FA.PartitionDate = @PCPLastMonthDate
GROUP BY FA.CenterID

/********************** Get PCP Revenue for the month *********************************************************/

SELECT C.CenterNumber AS 'CenterID'
       ,	ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0) + ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) AS 'PCPRevenue'  --Includes Non-Program, ServiceAmt
	   ,	ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) AS 'ServiceAmt'
INTO #PCPRevenue
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON FST.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            --ON FST.CenterKey = C.CenterKey
			ON CM.CenterKey = C.CenterKey       --KEEP HomeCenter Based
        INNER JOIN #Centers
            ON C.CenterNumber = #Centers.CenterNumber
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON FST.SalesCodeKey = SC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipSSID = M.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
            ON C.CenterTypeKey = CT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
WHERE   DD.FullDate BETWEEN @FirstDayMonth AND @LastDayOfMonth
GROUP BY C.CenterNumber

/********************** Get PCP Revenue_Budget for the month *********************************************************/

SELECT FA.CenterID
,	CASE WHEN SUM(ABS(ISNULL(Budget,0))) = 0 THEN 1 ELSE ROUND(SUM(ABS(ISNULL(Budget, 0))), 0) END AS 'PCPRevenue_Budget'
INTO #PCPRevenue_Budget
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber
WHERE FA.AccountID IN(10536,3015,10555,10575)  --Include 10555 - Retail Sales $ and 10575 - Service Sales $
	AND FA.PartitionDate = @FirstDayMonth
GROUP BY FA.CenterID


/****************************** GET RETAIL DATA **************************************/

INSERT  INTO #RetailSales
        SELECT  #Centers.CenterNumber
		,	SUM(ISNULL(t.RetailAmt, 0)) AS 'RetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON t.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON t.CenterKey = c.CenterKey
		INNER JOIN #Centers
            ON c.CenterNumber = #Centers.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON t.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @FirstDayMonth AND @LastDayOfMonth
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
		GROUP BY #Centers.CenterNumber


/********************** Find combined values from the temp tables *************************************************/
SELECT c.CenterNumber
,	ISNULL(a.XTRPlusConversions, 0) AS 'XTRPlusConversions'
,	ISNULL(a.XTRPlusConversions_Budget, 1) AS 'XTRPlusConversions_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.XtrPlusConversions,0), ISNULL(a.XtrPlusConversions_Budget,2)) > @XTRPlusConversionsToBudget_Cap
		THEN @XTRPlusConversionsToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.XtrPlusConversions,0), ISNULL(a.XtrPlusConversions_Budget,2))
	END AS 'XtrPlusConversionsToBudgetPercent'

,	ISNULL(a.EXTConversions, 0)+ISNULL(a.XtrandsConversions, 0) AS 'EXTandXTRConversions'
,	ISNULL(a.EXTConversions_Budget, 1)+ISNULL(a.XtrandsConversions_Budget, 1) AS 'EXTandXTRConversions_Budget'

,	ISNULL(a.PCPUpgradeCount, 0) AS 'Upgrade'
,	ISNULL(PLast.PCPLastMonth, 0)  * .02 AS 'UpgradeGoal'

,	ISNULL(PLast.PCPLastMonth, 0) AS 'PCPLastMonth'
,	ISNULL(PCPRev.PCPRevenue, 0) + ISNULL(RETAIL.RetailSales,0) AS 'PCPRevenue'
,	ISNULL(PCPBud.PCPRevenue_Budget, 0) AS 'PCPRevenue_Budget'
INTO #Final
FROM #Centers c
	LEFT OUTER JOIN #Accounting a
		ON c.CenterNumber = a.CenterID
	LEFT OUTER JOIN #PCPLastMonth PLast
		ON C.CenterNumber = PLast.CenterID
	LEFT OUTER JOIN #PCPRevenue PCPRev
		ON C.CenterNumber = PCPRev.CenterID
	LEFT OUTER JOIN #PCPRevenue_Budget PCPBud
		ON C.CenterNumber = PCPBud.CenterID
	LEFT OUTER JOIN #RetailSales RETAIL
		ON C.CenterNumber = RETAIL.CenterNumber

/********************** Select into #Region and combine values *****************************************************/
SELECT 	C.MainGroupID
,	C.MainGroup
,	F.CenterNumber
,	C.CenterDescriptionNumber
,	C.RecurringBusinessSize
,	XTRPlusConversions
,	XTRPlusConversions_Budget
,	XTRPlusConversionsToBudgetPercent
,	f.EXTandXTRConversions
,	f.EXTandXTRConversions_Budget
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(f.EXTandXTRConversions, 0), ISNULL(f.EXTandXTRConversions_Budget, 2)) > @EXTandXTRConversionsToBudget_Cap
		THEN @EXTandXTRConversionsToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(f.EXTandXTRConversions, 0), ISNULL(f.EXTandXTRConversions_Budget, 2))
	END AS 'EXTandXTRConversionsToBudgetPercent'

,	ROUND(F.Upgrade,0) AS 'Upgrade'
,	ROUND(F.UpgradeGoal,0) AS 'UpgradeGoal'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ROUND(F.Upgrade,0),ROUND(F.UpgradeGoal,0)) > @NetUpgrades_Cap
		THEN @NetUpgrades_Cap
		ELSE dbo.DIVIDE_DECIMAL(ROUND(F.Upgrade,0),ROUND(F.UpgradeGoal,0))
	END AS 'UpgradePercent'

,	F.PCPLastMonth
,	F.PCPRevenue
,	F.PCPRevenue_Budget
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(f.PCPRevenue, 0), ISNULL(f.PCPRevenue_Budget, 1)) > @PCPRevenueToBudget_Cap
		THEN @PCPRevenueToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(f.PCPRevenue, 0), ISNULL(f.PCPRevenue_Budget, 1))
	END AS 'PCPRevenueToBudgetPercent'
INTO #MainGroup
FROM #Final f
	INNER JOIN #Centers C
		ON F.CenterNumber = C.CenterNumber


/*********************** Insert into #GroupSize *************************************************************/
IF @GroupSize = 0
BEGIN
INSERT INTO #GroupSize
SELECT CASE WHEN RecurringBusinessSize = 'Small' THEN 1
			WHEN RecurringBusinessSize = 'Medium' THEN 2
			WHEN RecurringBusinessSize = 'Large' THEN 3
			WHEN @CenterType = 2 THEN 0 ELSE 1
		END AS  'GroupSize'
	,	MainGroupID
	,	MainGroup
	,	CenterNumber AS 'CenterID'
	,	CenterDescriptionNumber
	,	XTRPlusConversions
	,	XTRPlusConversions_Budget
	,	XTRPlusConversionsToBudgetPercent
	,	EXTandXTRConversions
	,	EXTandXTRConversions_Budget
	,	EXTandXTRConversionsToBudgetPercent
	,	Upgrade
	,	CASE WHEN UpgradeGoal = 0 THEN 1 ELSE UpgradeGoal END AS 'UpgradeGoal'
	,	CASE WHEN UpgradeGoal = 0 THEN (Upgrade/1) ELSE UpgradePercent END AS 'UpgradePercent'
	,	PCPLastMonth
	,	PCPRevenue
	,	PCPRevenue_Budget
	,	PCPRevenueToBudgetPercent
	,	((XTRPlusConversionsToBudgetPercent * @XTRPlusConversionsToBudget_Weighting)
	+	(EXTandXTRConversionsToBudgetPercent * @EXTandXTRConversionsToBudget_Weighting)
	+	(UpgradePercent* @UpgradePercent_Weighting)
	+	(PCPRevenueToBudgetPercent * @PCPRevenueToBudget_Weighting )
	)
	AS 'Total'
FROM #MainGroup
END
ELSE
BEGIN
INSERT INTO #GroupSize
SELECT * FROM
			(SELECT CASE WHEN RecurringBusinessSize = 'Small' THEN 1
						WHEN RecurringBusinessSize = 'Medium' THEN 2
						WHEN RecurringBusinessSize = 'Large' THEN 3
						WHEN @CenterType = 2 THEN 0 ELSE 1
						END AS  'GroupSize'
				,	MainGroupID
				,	MainGroup
				,	CenterNumber AS 'CenterID'
				,	CenterDescriptionNumber
				,	XTRPlusConversions
				,	XTRPlusConversions_Budget
				,	XTRPlusConversionsToBudgetPercent
				,	EXTandXTRConversions
				,	EXTandXTRConversions_Budget
				,	EXTandXTRConversionsToBudgetPercent
				,	Upgrade
				,	CASE WHEN UpgradeGoal = 0 THEN 1 ELSE UpgradeGoal END AS 'UpgradeGoal'
				,	CASE WHEN UpgradeGoal = 0 THEN (Upgrade/1) ELSE UpgradePercent END AS 'UpgradePercent'
				,	PCPLastMonth
				,	PCPRevenue
				,	PCPRevenue_Budget
				,	PCPRevenueToBudgetPercent
				,	((XTRPlusConversionsToBudgetPercent * @XTRPlusConversionsToBudget_Weighting)
				+	(EXTandXTRConversionsToBudgetPercent * @EXTandXTRConversionsToBudget_Weighting)
				+	(UpgradePercent* @UpgradePercent_Weighting)
				+	(PCPRevenueToBudgetPercent * @PCPRevenueToBudget_Weighting )
				)
				AS 'Total'
			FROM #MainGroup)q
WHERE GroupSize = @GroupSize
END

SELECT * FROM #GroupSize


END
GO
