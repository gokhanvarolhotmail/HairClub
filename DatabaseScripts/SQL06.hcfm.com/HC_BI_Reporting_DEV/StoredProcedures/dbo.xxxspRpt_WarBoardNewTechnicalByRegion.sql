/* CreateDate: 09/14/2012 09:29:45.883 , ModifyDate: 04/06/2016 15:26:40.290 */
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardNewTechnicalByRegion

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	New Business War Board (Summary)
==============================================================================
NOTES:	@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
11/12/2012 - MB - Changed query to use new EmployeePayrollID column from employee table
04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
10/21/2013 - RH - (#92910) Added additional RSM roll-up filters - see 1,2,3,4 below - By Region, NB1, MA, TM
10/23/2013 - RH - (#92910) Also, added CenterKey to #Centers for the join on HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction
11/18/2013 - DL - Updated procedure to reference the EmployeeHoursCertipay in HC_Accounting
12/16/2014 - DL - Separated Retail Sales from Main Query & Determined From FactSalesTransactions instead of FactAccounting.
07/16/2015 - RH - (#115665) Added the Budget for Laser Retail AccountID = 3096
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
==============================================================================

SAMPLE EXECUTION:
EXEC [spRpt_WarBoardNewTechnicalByRegion]  1, 12, 2015
EXEC [spRpt_WarBoardNewTechnicalByRegion]  2, 12, 2015
EXEC [spRpt_WarBoardNewTechnicalByRegion]  3, 12, 2015

==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxspRpt_WarBoardNewTechnicalByRegion] (
	@Filter	INT
,	@Month	TINYINT
,	@Year	SMALLINT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @stype VARCHAR(1)
	,	@FirstDayMonth DATETIME
	,	@LastDayMonth DATETIME
	,	@StartDate SMALLDATETIME
	,	@EndDate SMALLDATETIME
	,	@TrxStartDate SMALLDATETIME
	,	@PeriodEndDate SMALLDATETIME
	,	@PayGroup INT
	,	@AppsToHairSales_Cap NUMERIC(15,5)
	,	@ConversionToApps_Cap NUMERIC(15,5)
	,	@UpgradesToPCPCount_Cap NUMERIC(15,5)
	,	@RetalAndServiceToBudget_Cap NUMERIC(15,5)
	,	@Benchmark NUMERIC(15,5)

	/********************************** Create temp table objects *************************************/

	CREATE TABLE #Centers (
		MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	CenterTypeDescriptionShort VARCHAR(50)
	,	CenterKey INT
	,	EmployeeKey INT
	,	EmployeeFullName VARCHAR(102)
	)

		CREATE TABLE #Dates (
		DateID INT
	,	DateDescription VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)


/********************************** Get list of centers ************************************************/


	IF @Filter = 1 -- By Region
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		'C' AS CenterTypeDescriptionShort
				,		DC.CenterKey
				,		NULL AS EmployeeKey
				,		NULL AS EmployeeFullName
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	IF @Filter = 2 -- By Area Managers
	BEGIN
		INSERT  INTO #Centers
				SELECT  AM.EmployeeKey AS 'MainGroupID'
				,		AM.EmployeeFullName AS 'MainGroup'
				,		AM.CenterSSID
				,		AM.CenterDescriptionNumber
				,		'C' AS CenterTypeDescriptionShort
				,		AM.CenterKey
				,		AM.EmployeeKey
				,		AM.EmployeeFullName
				FROM   dbo.vw_AreaManager AM
				WHERE   CONVERT(VARCHAR, AM.CenterSSID) LIKE '[2]%'
						AND AM.Active = 'Y'
	END


	IF @Filter = 3 -- By Center
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterSSID AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		'C' AS CenterTypeDescriptionShort
				,		DC.CenterKey
				,		NULL AS EmployeeKey
				,		NULL AS EmployeeFullName
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	/*/********************************** Create temp table objects *************************************/

	CREATE TABLE #Centers (
		MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	CenterTypeDescriptionShort VARCHAR(50)
	,	CenterKey INT
	)

	CREATE TABLE #Dates (
		DateID INT
	,	DateDescription VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)

	/********************************** Get list of centers *************************************/

	SET @sType = 'C'  --This report is only pulling for Corporate (War Board Corporate)

	IF @sType = 'C' AND @Filter = 1
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'C' AND @Filter = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionNB1, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'C' AND @Filter = 3
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionMA, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMMembershipAdvisorSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END

	IF @sType = 'C' AND @Filter = 4
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionTM, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'F' AND @Filter = 1
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'F' AND @Filter = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
				,		ISNULL(DC.RegionNB1, 'Unknown, Unknown') AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DC.CenterKey
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


	IF @sType = 'F' AND @Filter = 3
		BEGIN
			INSERT  INTO #Centers
					SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
					,		ISNULL(DC.RegionMA, 'Unknown, Unknown') AS 'MainGroup'
					,		DC.CenterSSID
					,		DC.CenterDescriptionNumber
					,		DCT.CenterTypeDescriptionShort
					,		DC.CenterKey
					FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
								ON DC.CenterTypeKey = DCT.CenterTypeKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
								ON DC.RegionSSID = DR.RegionKey
							LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON DC.RegionRSMMembershipAdvisorSSID = DE.EmployeeSSID
					WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
							AND DC.Active = 'Y'
		END

	IF @sType = 'F' AND @Filter = 4
		BEGIN
			INSERT  INTO #Centers
					SELECT  ISNULL(DE.EmployeeKey, '-1') AS 'MainGroupID'
					,		ISNULL(DC.RegionTM, 'Unknown, Unknown') AS 'MainGroup'
					,		DC.CenterSSID
					,		DC.CenterDescriptionNumber
					,		DCT.CenterTypeDescriptionShort
					,		DC.CenterKey
					FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
								ON DC.CenterTypeKey = DCT.CenterTypeKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
								ON DC.RegionSSID = DR.RegionKey
							LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
								ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
					WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
							AND DC.Active = 'Y'
		END

		--SELECT * FROM #Centers
	*/
	/********************* Set Variables ******************************************************/

	SELECT @FirstDayMonth = CAST(@Month AS VARCHAR(10)) + '/1/' + CAST(@Year AS VARCHAR(10))
	,	@LastDayMonth = DATEADD(dd, -1, DATEADD(mm, 1, @FirstDayMonth))
	,	@AppsToHairSales_Cap = 1.5
	,	@ConversionToApps_Cap = 1.5
	,	@UpgradesToPCPCount_Cap = 2
	,	@RetalAndServiceToBudget_Cap = 1.25
	,	@Benchmark = .02


	IF (MONTH(@LastDayMonth) = MONTH(GETDATE())) AND (YEAR(@LastDayMonth) = YEAR(GETDATE()))
		BEGIN
			SELECT @TrxStartDate = MAX(EndDate)
			FROM lkpPayPeriods
			WHERE EndDate <= GETDATE()
				AND PayGroup=1
		END
	ELSE
		BEGIN
			SELECT @TrxStartDate = MAX(EndDate)
			FROM lkpPayPeriods
			WHERE EndDate <= @LastDayMonth
				AND PayGroup=1
		END

	SET @EndDate = DATEADD(mi, -1, DATEADD(dd, 1, @TrxStartDate))

	SET @StartDate = DATEADD(dd, -41, @TrxStartDate)
	IF @StartDate < '01/01/2008'
		SET @StartDate = '01/01/2008'

	INSERT INTO #Dates (
		DateID
	,	DateDescription
	,	StartDate
	,	EndDate)
	SELECT 1
	,	'SixWeeksBack'
	,	DATEADD(dd, -41, @TrxStartDate)
	,	@EndDate


	/***************************** Get transactional information per employee ************************/

	SELECT
	C.MainGroupID
	,	C.MainGroup
	,	E.EmployeePayrollID
	,	E.EmployeeKey
	,	CONVERT(DECIMAL(7, 2), ((SUM(CASE WHEN CLT.GenderSSID=1 THEN 1 ELSE 0 END * CONVERT(DECIMAL(7, 2), LSD.MenDuration))
			+ SUM(CASE WHEN CLT.GenderSSID=2 THEN 1 ELSE 0 END * CONVERT(DECIMAL(7, 2), LSD.WomenDuration))) / 60)) AS 'SixWeeksBack_Hours'
	INTO #Time
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Centers C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].[DimEmployeePositionJoin] EPJ
			ON E.EmployeeSSID = EPJ.EmployeeGUID
		INNER JOIN #Dates
			ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		LEFT OUTER JOIN lkpLaborServiceDuration LSD
			ON SC.SalesCodeDescriptionShort = LSD.Code
		LEFT OUTER JOIN lkpStylistPoints SP
			ON FST.MembershipKey = SP.MembershipKey
	WHERE SC.SalesCodeTypeSSID=2
		AND SC.SalesCodeSSID NOT IN (706, 708)
		AND EPJ.EmployeePositionID = 1
	GROUP BY C.MainGroupID
	,	C.MainGroup
	,	E.EmployeePayrollID
	,	E.EmployeeKey

	/************************** Get employee hours [#Hours] **************************************************/
	SELECT t.MainGroupID
	,	t.MainGroup
	,	t.EmployeeKey
	,	t.EmployeePayrollID
	,	CONVERT(INT, SUM(ISNULL(CASE WHEN EHC.PeriodEnd BETWEEN DATEADD(dd, -28, @TrxStartDate) and @TrxStartDate THEN (EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000) ELSE 0 END, 0))) AS 'SixWeeksBackTotal'
	INTO #Hours
	FROM #Time t
		INNER JOIN [HC_Accounting].[dbo].[EmployeeHoursCertipay] EHC
			ON CONVERT(VARCHAR, t.EmployeePayrollID) = CONVERT(VARCHAR, EHC.EmployeeID)
	WHERE EHC.PeriodEnd BETWEEN @StartDate and @EndDate
	GROUP BY t.MainGroupID
	,	t.MainGroup
	,	t.EmployeeKey
	,	t.EmployeePayrollID

	/************************** Get SixWeeksBackEfficiency [#LaborEfficiency] **************************************************/
	SELECT t.MainGroupID
	,	t.MainGroup
	,	dbo.DIVIDE_DECIMAL(SUM(ISNULL(t.SixWeeksBack_Hours, 0)), SUM(ISNULL(h.SixWeeksBackTotal, 0))) AS 'SixWeeksBackEfficiency'
	INTO #LaborEfficiency
	FROM #Time t
		LEFT OUTER JOIN #Hours h
			ON t.EmployeeKey = h.EmployeeKey
	GROUP BY t.MainGroupID
	,	t.MainGroup


	/************************** Get Accounting [#Accounting] **************************************************/

	SELECT C.MainGroupID
	,	C.MainGroup
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205) THEN Flash ELSE 0 END, 0)) AS 'NetTradCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10210) THEN Flash ELSE 0 END, 0)) AS 'NetGradCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10215) THEN Flash ELSE 0 END, 0)) AS 'NetEXTCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10220) THEN Flash ELSE 0 END, 0)) AS 'NetSurCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10225) THEN Flash ELSE 0 END, 0)) AS 'NetPostEXTCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10110) THEN Flash ELSE 0 END, 0)) AS 'Consultations'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BioConversions'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'Applications'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10515) THEN Flash ELSE 0 END, 0)) AS 'PCPUpgradeCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10510) THEN Flash ELSE 0 END, 0)) AS 'PCPDowngradeCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10410) THEN Flash ELSE 0 END, 0)) AS 'CurrentMonthPCPCount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10210, 10215, 10220, 10225) THEN Flash ELSE 0 END, 0)) AS 'NetNb1Count'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1Budget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10525) THEN Flash ELSE 0 END, 0)) AS 'ServiceAmount'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (3090,3096) THEN ((Budget*(-1)) + (.10 * (Budget*(-1)))) ELSE 0 END, 0)) AS 'RetailAmountBudget'  --Goal is 10% above Budget  --This will match the Goal on the Center Flash
	INTO #Accounting
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterSSID
	WHERE MONTH(FA.PartitionDate)=@Month
	  AND YEAR(FA.PartitionDate)=@Year
	GROUP BY C.MainGroupID
	,	C.MainGroup


SELECT  C.MainGroupID
,		C.MainGroup
,       SUM(CASE WHEN DSCD.SalesCodeDivisionSSID = 30 THEN FST.ExtendedPrice ELSE 0 END) AS 'RetailAmount'
INTO	#Retail
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
		INNER JOIN #Centers C
			ON CTR.CenterSSID = C.CenterSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
            ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DD.MonthNumber = @Month
        AND DD.YearNumber = @Year
        AND ( DSCD.SalesCodeDivisionSSID = 30)
GROUP BY C.MainGroupID
,		C.MainGroup


	/************************** Get Data [#Data] **************************************************/

	SELECT #Accounting.MainGroupID
	,	#Accounting.MainGroup
	,	Applications
	,	NetNb1Count
	,	CASE WHEN dbo.DIVIDE_DECIMAL(Applications, (NetTradCount + NetGradCount)) > @AppsToHairSales_Cap
			THEN @AppsToHairSales_Cap
			ELSE dbo.DIVIDE_DECIMAL(Applications, (NetTradCount + NetGradCount))
		END AS 'AppsToHairSalesPercent'
	,	BioConversions
	,	CASE WHEN dbo.DIVIDE_DECIMAL(BioConversions, Applications) > @ConversionToApps_Cap
			THEN @ConversionToApps_Cap
			ELSE dbo.DIVIDE_DECIMAL(BioConversions, Applications)
		END AS 'ConversionToAppsPercent'
	,	PCPUpgradeCount
	,	PCPDowngradeCount
	,	CurrentMonthPCPCount
	,	@Benchmark AS 'Benchmark'
	,	CASE WHEN dbo.DIVIDE_NOROUND(dbo.DIVIDE_NOROUND((ISNULL(PCPUpgradeCount, 0) - ISNULL(PCPDowngradeCount, 0)), ISNULL(CurrentMonthPCPCount, 0)), @Benchmark) > @UpgradesToPCPCount_Cap
			THEN @UpgradesToPCPCount_Cap
			ELSE dbo.DIVIDE_NOROUND(dbo.DIVIDE_NOROUND((ISNULL(PCPUpgradeCount, 0) - ISNULL(PCPDowngradeCount, 0)), ISNULL(CurrentMonthPCPCount, 0)), @Benchmark)
		END AS 'UpgradePercent'
	,	CASE WHEN dbo.DIVIDE_DECIMAL((ServiceAmount + RetailAmount), RetailAmountBudget) > @RetalAndServiceToBudget_Cap
			THEN @RetalAndServiceToBudget_Cap
			ELSE dbo.DIVIDE_DECIMAL((ServiceAmount + RetailAmount), RetailAmountBudget)
		END AS 'RetailServiceToBudgetPercent'
	,OpenPCP
	,ClosePCP
	,1 - dbo.DIVIDE_NOROUND((opcp.OpenPCP + BioConversions - cpcp.ClosePCP), (opcp.OpenPCP + cpcp.ClosePCP))/2 * 365/DATEDIFF(DD,DATEADD(MM,-1,@FirstDayMonth),@FirstDayMonth) AttritionPercent
	INTO #Data
	FROM #Accounting
	LEFT OUTER JOIN #Retail R
		ON #Accounting.MainGroupID = R.MainGroupID
	LEFT JOIN (
			SELECT c.MainGroupID AS 'MainGroupID', SUM(a.Flash) AS 'OpenPCP'
			FROM HC_Accounting.dbo.FactAccounting a
				INNER JOIN #Centers c
					ON a.CenterID = c.CenterSSID
			WHERE MONTH(a.PartitionDate) = MONTH(DATEADD(MM,-1,@FirstDayMonth))
				AND YEAR(a.PartitionDate) = YEAR(DATEADD(MM,-1,@FirstDayMonth))
				AND a.AccountID = 10400
			GROUP BY c.MainGroupID) opcp
		ON #Accounting.MainGroupID = opcp.MainGroupID
	LEFT JOIN (
			SELECT c.MainGroupID AS 'MainGroupID', SUM(a.Flash) AS 'ClosePCP'
			FROM HC_Accounting.dbo.FactAccounting a
				INNER JOIN #Centers c
					ON a.CenterID = c.CenterSSID
			WHERE MONTH(a.PartitionDate) = MONTH(@FirstDayMonth)
				AND YEAR(a.PartitionDate) = YEAR(@FirstDayMonth)
				AND a.AccountID = 10400
			GROUP BY c.MainGroupID) cpcp
		ON #Accounting.MainGroupID = cpcp.MainGroupID

	/************************** Get Totals **************************************************/

	SELECT *
	, SixWeeksBackEfficiency * .05
	+ AppsToHairSalesPercent * .15
	+ ConversionToAppsPercent * .10
	+ UpgradePercent * .10
	+ RetailServiceToBudgetPercent * .20
	+ AttritionPercent * .40
	AS 'Total'
	FROM (
		SELECT
			tbl.MainGroupID
		,	tbl.MainGroup
		,	CASE WHEN SixWeeksBackEfficiency > 1 THEN 1 ELSE SixWeeksBackEfficiency END SixWeeksBackEfficiency--Cap 100, Weight 5
		,	Applications
		,	NetNb1Count
		,	CASE WHEN AppsToHairSalesPercent > 1.5 THEN 1.5 ELSE AppsToHairSalesPercent END AppsToHairSalesPercent-- Cap 150, Weight 15
		,	BioConversions
		,	CASE WHEN ConversionToAppsPercent > 1.5 THEN 1.5 ELSE ConversionToAppsPercent END ConversionToAppsPercent-- Cap 150, Weight 10
		,	PCPUpgradeCount
		,	PCPDowngradeCount
		,	CurrentMonthPCPCount
		,	Benchmark
		,	CASE WHEN UpgradePercent > 2 THEN 2 ELSE UpgradePercent END UpgradePercent-- Cap 200, Weight 10
		,	CASE WHEN RetailServiceToBudgetPercent > 1.5 THEN 1.5
			  WHEN RetailServiceToBudgetPercent < 0 THEN 0
			  ELSE RetailServiceToBudgetPercent
			END RetailServiceToBudgetPercent-- Cap 150, Weight 20
		,	OpenPCP
		,	ClosePCP
		,	AttritionPercent
		FROM (
			SELECT d.MainGroupID
			,	d.MainGroup
			,	ISNULL(LE.SixWeeksBackEfficiency, 0) AS 'SixWeeksBackEfficiency'
			,	ISNULL(d.Applications, 0) AS 'Applications'
			,	ISNULL(d.NetNb1Count, 0) AS 'NetNb1Count'
			,	ISNULL(d.AppsToHairSalesPercent, 0) AS 'AppsToHairSalesPercent'
			,	ISNULL(d.BioConversions, 0) AS 'BioConversions'
			,	ISNULL(d.ConversionToAppsPercent, 0) AS 'ConversionToAppsPercent'
			,	ISNULL(d.PCPUpgradeCount, 0) AS 'PCPUpgradeCount'
			,	ISNULL(d.PCPDowngradeCount, 0) AS 'PCPDowngradeCount'
			,	ISNULL(d.CurrentMonthPCPCount, 0) AS 'CurrentMonthPCPCount'
			,	ISNULL(d.Benchmark, 0) AS 'Benchmark'
			,	ISNULL(d.UpgradePercent, 0) AS 'UpgradePercent'
			,	ISNULL(d.RetailServiceToBudgetPercent, 0) AS 'RetailServiceToBudgetPercent'
			,	ISNULL(d.OpenPCP, 0) AS 'OpenPCP'
			,	ISNULL(d.ClosePCP, 0) AS 'ClosePCP'
			,	ISNULL(d.AttritionPercent, 0) AS 'AttritionPercent'
			FROM #Data d
				LEFT OUTER JOIN #LaborEfficiency LE
					ON d.MainGroupID = LE.MainGroupID
			) tbl
		) RESULT


END
GO
