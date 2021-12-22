/* CreateDate: 04/16/2012 14:21:21.740 , ModifyDate: 02/02/2021 14:39:56.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_RichMatrix

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		04/16/2012

LAST REVISION DATE: 	04/16/2012

==============================================================================
DESCRIPTION:	Rich Matrix Report
==============================================================================
NOTES:	This report changes according to the day it is run if it is run in the current month.  It
calculates the portion of the current month and adjusts all of the totals accordingly. (@CummWorkdays / @MonthWorkdays)

**	03/29/2013	KRM		Modified report to derive FactAccounting from HC_Accounting
06/10/2013 - MB - Removed Retail columns
06/14/2013 - MB - Fixed ReportDate output column for correct Month & Year
06/14/2013 - KM - Added in change to exclude incomplete appointments (ResultCodeKey <> -1)
09/30/2013 - MB - Changed dates for all fiscal related columns (WO# 92139)
02/13/2014 - MB - Changed fiscal year to match calendar year (Exec Request)
12/01/2014 - RH - Added Xtrands - NB_XTRCnt, NB_XTRAmt, NB_XTRConvCnt (Exec Request)
12/29/2014 - RH - Added AND c.Active = 'Y' to the Centers query
01/13/2015 - RH - Added Xtrands to the Budget amounts
06/09/2015 - RH - (#115208) Changed the query for Consultations to pull from vwFactActivityResults to match other reports, Changed 3080 to 10575 for Service Budget
06/19/2015 - RH - (#115208) Removed exclusion of SalesCodeSSID = 697 (PRM-LONG) from Services; Change Active PCP Clients for Year to Date to be the counts for the prior month; Changed to Home Center based
07/21/2015 - RH - Changed Leads count to COALESCE(DW.[Leads],1)
07/27/2015 - RH - Changed Leads count to SUM(FL.[Leads])
10/12/2015 - RH - Changed BIO to XTRPlus
10/12/2015 - RH - Added	"AND FAR.BeBack <> 1 AND FAR.Show=1" to the query for Consultations - to match the Flash NB
04/05/2016 - RH - Changed wording - Apps to NSD, Trad to GWP, Applications to NewStyleDays, XTRPlus to XTR+
05/04/2016 - RH - Changed Leads count to COUNT(FL.Leads) to match the mini-Flash
06/06/2016 - DL - Changed COUNT(FL.Leads) back to COUNT(FL.Leads) so that the report matches OnContact (#126963)
01/19/2017 - RH - Added SET RowValue = 1 for rows 5,6,7,8,9,13,14,17,21,25,29,33,38,40,42,44 for formatting in the report (#132073)
01/24/2017 - RH - Added "PCP & Non Pgm" = PCP_NB2Amt (#132073)
04/03/2017 - RH - Added account 3015 budget ($ for Non-Pgrm) + account 10536 (PCP - BIO & EXTMEM & Xtrands Sales $) for the PCP_NB2AmtBudget.
07/31/2017 - RH - Changed GWP to "XTR+ Initial" and Gradual to "XTR+ Initial 6" (#141004)
01/23/2018 - RH - Changed CenterSSID to CenterNumber, except for joins on FactAccounting
03/06/2018 - RH - (#147144) Changed joins on FactAccounting to CenterNumber
08/07/2018 - RH - Added Corporate (100) as a "Center" for Leads (per Kevin)
01/25/2019 - RH - (Case #7101) Removed Surgery from TotalNewCustomerTotalCashBudget	and TotalNewCustomerTotalCash
06/19/2019 - JL - (TFS 12573) Laser Report adjustment
12/06/2019 - RH - (TFS 13549) Several changes per Rev, including adding RestorInk and XTR+ Total; Make PCP_Revenue based on AccountID 10536; added columns CurrentMonthActualToBudget, Variance and YTDToBudget
01/13/2020 - JL - Remove Bosley Consult from leads, appointments & consultation count TrackIT 5322
01/13/2020 - RH - (TFS 13688) Added Surgery Sales, RestorInk to SalesBudget and TotalNewCustomerVolumeOfSalesBudget; Added Surgery Revenue to TotalNewCustomerTotalCashBudget
03/12/2020 - RH - TrackIT 7697 Added S_PRPCnt and S_PRPAmt to Surgery and the Totals for New Customer  (no budgets yet)
=============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_RichMatrix] 12, 2019, 1, 'FranJV'

EXEC [spRpt_RichMatrix] 2, 2020, 1, 'Corporate'

EXEC [spRpt_RichMatrix] 12, 2019, 3, 'Barth'

==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_RichMatrix] (
    @Month			TINYINT
,	@Year			SMALLINT
,	@ReportType		TINYINT
,	@Filter			NVARCHAR(50))
AS
BEGIN
SET FMTONLY OFF
SET NOCOUNT OFF


/*
	@ReportType
	1 = Center type (Corporate, Franchise...)
	2 = Center number (201, 203, ...)
	3 = Region

	@Filter

*/
DECLARE @TempDate DATETIME
,	@CurrentMonthStart DATETIME
,	@CurrentMonthEnd DATETIME
,	@OneMonthBackStart DATETIME
,	@OneMonthBackEnd DATETIME
,	@TwoMonthsBackStart DATETIME
,	@TwoMonthsBackEnd DATETIME
,	@ThreeMonthsBackStart DATETIME
,	@ThreeMonthsBackEnd DATETIME
,	@OneYearBackStart DATETIME
,	@OneYearBackEnd DATETIME
,	@TwoYearsBackStart DATETIME
,	@TwoYearsBackEnd DATETIME
,	@CurrentFiscalYearStart DATETIME
,	@CurrentFiscalYearEnd DATETIME
,	@PriorFiscalYearStart DATETIME
,	@PriorFiscalYearEnd DATETIME
,	@CurrentMonth TINYINT
,	@CummWorkdays DECIMAL
,	@MonthWorkdays DECIMAL
,	@CummToMonth DECIMAL(7, 6)
,	@MonthTotalDays DECIMAL
,	@CurrentDay DECIMAL
,	@CurrentToTotal DECIMAL(7, 6)
,	@Country VARCHAR(100)
,	@Filter1 NVARCHAR(50)
,	@Filter2 NVARCHAR(50)
,	@CurrentToTotalYTD DECIMAL(7, 6)
,	@ReportCenters NVARCHAR(50)


/**************************  Create temp tables **************************************************/

CREATE TABLE #Centers (
	CenterNumber INT
,	CenterSSID INT
)


CREATE TABLE #Dates (
	DateID INT
,	DateDesc VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
)


CREATE TABLE #Data (
	DateDesc VARCHAR(50)
,	Leads INT
,	Appointments INT
,	Shows INT
,	BeBacks INT
,	BeBacksToExclude INT
,	Sales  DECIMAL(18,4)
,	[XTRPlusInitVolumeOfSales]  DECIMAL(18,4)
,	[XTRPlusInitTotalCash] MONEY
,	[XTRPlusInit6VolumeOfSales] INT
,	[XTRPlusInit6TotalCash] MONEY
,	[XTRPlusTotalVolumeOfSales]  DECIMAL(18,4)
,	[XTRPlusTotalTotalCash] MONEY
,	XTRVolumeOfSales  DECIMAL(18,4)
,	XTRTotalCash MONEY
,	ExtVolumeOfSales  DECIMAL(18,4)
,	ExtTotalCash MONEY
,	PostExtVolumeOfSales  DECIMAL(18,4)
,	PostExtTotalCash MONEY
,	SurgeryVolumeOfSales  DECIMAL(18,4)
,	SurgeryTotalCash MONEY
,	RestorInkVolumeOfSales  DECIMAL(18,4)
,	RestorInkTotalCash MONEY
,	TotalNewCustomerVolumeOfSales  DECIMAL(18,4)
,	TotalNewCustomerTotalCash MONEY
,	NewStyleDays INT
,	Conversions INT
,	[XTRPlusConversions] INT
,	XTRConversions INT
,	ExtConversions INT
,	PCPRevenue MONEY
)


CREATE TABLE #Budget (
	DateDesc VARCHAR(50)
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales  DECIMAL(18,4)
,	[XTRPlusInitVolumeOfSales]  DECIMAL(18,4)
,	[XTRPlusInitTotalCash] MONEY
,	[XTRPlusInitCashPerSale] MONEY
,	[XTRPlusInit6VolumeOfSales]   DECIMAL(18,4)
,	[XTRPlusInit6TotalCash] MONEY
,	[XTRPlusInit6CashPerSale] MONEY
,	[XTRPlusTotalVolumeOfSales]  DECIMAL(18,4)
,	[XTRPlusTotalTotalCash] MONEY
,	[XTRPlusTotalCashPerSale] MONEY
,	XTRVolumeOfSales  DECIMAL(18,4)
,	XTRTotalCash MONEY
,	XTRCashPerSale MONEY
,	ExtVolumeOfSales  DECIMAL(18,4)
,	ExtTotalCash MONEY
,	ExtCashPerSale MONEY
,	PostExtVolumeOfSales  DECIMAL(18,4)
,	PostExtTotalCash MONEY
,	PostExtCashPerSale MONEY
,	SurgeryVolumeOfSales  DECIMAL(18,4)
,	SurgeryTotalCash MONEY
,	SurgeryCashPerSale MONEY
,	RestorInkVolumeOfSales  DECIMAL(18,4)
,	RestorInkTotalCash MONEY
,	RestorInkCashPerSale MONEY
,	TotalNewCustomerVolumeOfSales  DECIMAL(18,4)
,	TotalNewCustomerTotalCash MONEY
,	TotalNewCustomerCashPerSale MONEY
,	NewStyleDays INT
,	Conversions INT
,	[XTRPlusConversions] INT
,	XTRConversions INT
,	ExtConversions INT
,	PCPRevenue MONEY
)


CREATE TABLE #TmpApptShow(
	DateDesc VARCHAR(50)
,	Appointments INT
,	Consultation INT
,	BeBacks INT
,	BeBacksToExclude INT
)


CREATE TABLE #Final (
	DateDesc VARCHAR(50)
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales  DECIMAL(18,4)
,	SalesToLeads DECIMAL(18,4)
,	ConsultsToAppointments DECIMAL(18,4)
,	SalesToConsultations DECIMAL(18,4)
,	[XTRPlusInitVolumeOfSales] DECIMAL(18,4)
,	[XTRPlusInitTotalCash] MONEY
,	[XTRPlusInitCashPerSale] DECIMAL(18,4)
,	[XTRPlusInitSalesMix] DECIMAL(18,4)
,	[XTRPlusInit6VolumeOfSales] DECIMAL(18,4)
,	[XTRPlusInit6TotalCash] MONEY
,	[XTRPlusInit6CashPerSale] DECIMAL(18,4)
,	[XTRPlusInit6SalesMix] DECIMAL(18,4)
,	[XTRPlusTotalVolumeOfSales] DECIMAL(18,4)
,	[XTRPlusTotalTotalCash] MONEY
,	[XTRPlusTotalCashPerSale]  DECIMAL(18,4)
,	[XTRPlusTotalSalesMix] DECIMAL(18,4)
,	XTRVolumeOfSales DECIMAL(18,4)
,	XTRTotalCash MONEY
,	XTRCashPerSale DECIMAL(18,4)
,	XTRSalesMix DECIMAL(18,4)
,	ExtVolumeOfSales DECIMAL(18,4)
,	ExtTotalCash MONEY
,	ExtCashPerSale DECIMAL(18,4)
,	ExtSalesMix DECIMAL(18,4)
,	PostExtVolumeOfSales DECIMAL(18,4)
,	PostExtTotalCash MONEY
,	PostExtCashPerSale DECIMAL(18,4)
,	PostExtSalesMix DECIMAL(18,4)
,	SurgeryVolumeOfSales DECIMAL(18,4)
,	SurgeryTotalCash MONEY
,	SurgeryCashPerSale DECIMAL(18,4)
,	SurgerySalesMix DECIMAL(18,4)
,	[RestorInkVolumeOfSales] DECIMAL(18,4)
,	[RestorInkTotalCash] MONEY
,	[RestorInkCashPerSale] DECIMAL(18,4)
,	RestorInkSalesMix DECIMAL(18,4)
,	TotalNewCustomerVolumeOfSales DECIMAL(18,4)
,	TotalNewCustomerTotalCash MONEY
,	TotalNewCustomerCashPerSale DECIMAL(18,4)
,	NewStyleDays INT
,	NSDToSales DECIMAL(18,4)
,	Conversions INT
,	ConvsToNSD DECIMAL(18,4)
,	[XTRPlusConversions] INT
,	XTRConversions INT
,	ExtConversions INT
,	[XTRPlusConvsToNSD] DECIMAL(18,4)
,	XTRConvsToSales DECIMAL(18,4)
,	ExtConvsToSales DECIMAL(18,4)
,	PCPRevenue MONEY
)


CREATE TABLE #SSRS(
	Metric	NVARCHAR(150)
,   CurrentMonth DECIMAL(18,4)
,   OneMonthBack  DECIMAL(18,4)
,   TwoMonthsBack  DECIMAL(18,4)
,   ThreeMonthsBack  DECIMAL(18,4)
,   OneYearBack  DECIMAL(18,4)
,   TwoYearsBack  DECIMAL(18,4)
,   CurrentFiscalYear  DECIMAL(18,4)
,   PriorFiscalYear  DECIMAL(18,4)
,   CurrentMonthBudget  DECIMAL(18,4)
,   CurrentFiscalYearBudget  DECIMAL(18,4)
,	CurrentMonthActualToBudget  DECIMAL(18,4)
,	Variance  DECIMAL(18,4)
,	YTDToBudget  DECIMAL(18,4)
,   Bold INT
,   RowOrder INT
,   RowValue INT
)


CREATE TABLE #Format(
	Metric	NVARCHAR(150)
,   CurrentMonth NVARCHAR(150)
,   OneMonthBack  NVARCHAR(150)
,   TwoMonthsBack  NVARCHAR(150)
,   ThreeMonthsBack  NVARCHAR(150)
,   OneYearBack  NVARCHAR(150)
,   TwoYearsBack  NVARCHAR(150)
,   CurrentFiscalYear  NVARCHAR(150)
,   PriorFiscalYear  NVARCHAR(150)
,   CurrentMonthBudget  NVARCHAR(150)
,   CurrentFiscalYearBudget  NVARCHAR(150)
,	CurrentMonthActualToBudget  NVARCHAR(150)
,	Variance  NVARCHAR(150)
,	YTDToBudget  NVARCHAR(150)
,   Bold INT
,   RowOrder INT
,   RowValue INT
)

/************ Create indexes on temp tables *******************************/

CREATE NONCLUSTERED INDEX [IDX_tmpCenters] ON #Centers(CenterNumber ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpDates] ON #Dates(DateID ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpData] ON #Data(DateDesc ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpBudget] ON #Budget(DateDesc ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpApptShow] ON #TmpApptShow(DateDesc ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpFinal] ON #Final(DateDesc ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpSSRS] ON #SSRS(Metric ASC)
CREATE NONCLUSTERED INDEX [IDX_tmpFormat] ON #Format(Metric ASC)

/******************************** Set variables **************************************************************************************************/

IF @Filter = 'Joint Venture' SET @Filter='Joint'

IF @Filter LIKE '%(without Canada)%'
BEGIN
	SET @Filter = REPLACE(@Filter, ' (without Canada)', '')
	SELECT @Country = @Country + CASE WHEN LEN(@Country) > 0 THEN ',' ELSE '' END + CountryRegionDescriptionShort
	FROM ( SELECT DISTINCT CountryRegionDescriptionShort FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c WHERE CountryRegionDescriptionShort <> 'CA' ) tbl
END
ELSE IF @Filter = 'Canada'
	SELECT @Filter = NULL
	,	@Country = 'CA'
ELSE
	SELECT @Country = @Country + CASE WHEN LEN(@Country) > 0 THEN ',' ELSE '' END + CountryRegionDescriptionShort
	FROM ( SELECT DISTINCT CountryRegionDescriptionShort FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c ) tbl


IF (@Filter = 'FranJV')
BEGIN
	SET @Filter1 = 'Franchise'
	SET @Filter2 = 'Joint'
END
ELSE
BEGIN
	SET @Filter1 = @Filter
	SET @Filter2 = @Filter
END

/****************** Populate #Centers *************************************************************************************************************/

IF @ReportType=1		--Corporate or Franchise or Joint Venture
	BEGIN
		INSERT INTO #Centers
		SELECT c.CenterNumber
		,	c.CenterSSID
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
				ON c.CenterTypeKey = t.CenterTypeKey
		WHERE t.CenterTypeDescriptionShort IN( 'C','F','JV')
			AND t.CenterTypeDescription IN (RTRIM(@Filter1), RTRIM(@Filter2))
		AND c.Active = 'Y'
	END
ELSE IF @ReportType=2	--Center number (201, 203, ...)
	BEGIN
		INSERT INTO #Centers
		SELECT c.CenterNumber
		,	c.CenterSSID
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		WHERE CONVERT(VARCHAR, c.CenterSSID) = @Filter
		AND c.Active = 'Y'
	END
ELSE IF @ReportType=3	-- By Region
	BEGIN
		INSERT INTO #Centers
		SELECT c.CenterNumber
		,	c.CenterSSID
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				ON c.RegionKey = r.RegionKey
		WHERE r.RegionDescription LIKE RTRIM(@Filter) + '%'
			OR @Filter IS NULL
		AND c.Active = 'Y'
	END


IF @ReportType IN (1, 3)
	BEGIN
		SET @ReportCenters = @Filter
	END
ELSE IF @ReportType=2
	BEGIN
		SELECT @ReportCenters = CenterDescriptionNumber
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
		WHERE  CenterNumber IN (
			SELECT CenterNumber
			FROM #Centers
		)
	END


/*********************** Set date variables ****************************************************************************/

SET @TempDate = CAST(CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year) AS DATETIME)

SELECT @CurrentMonthStart = CAST(CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year) AS DATETIME)
,	@CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

,	@OneMonthBackStart = DATEADD(MONTH, -1, @CurrentMonthStart)
,	@OneMonthBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @OneMonthBackStart))

,	@TwoMonthsBackStart = DATEADD(MONTH, -2, @CurrentMonthStart)
,	@TwoMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwoMonthsBackStart))

,	@ThreeMonthsBackStart = DATEADD(MONTH, -3, @CurrentMonthStart)
,	@ThreeMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @ThreeMonthsBackStart))

,	@OneYearBackStart = DATEADD(YEAR, -1, @CurrentMonthStart)
,	@OneYearBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @OneYearBackStart))

,	@TwoYearsBackStart = DATEADD(YEAR, -2, @CurrentMonthStart)
,	@TwoYearsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwoYearsBackStart))

SET @CurrentFiscalYearStart = (
	SELECT CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, CalendarYear))
	FROM HC_BI_ENT_DDS.bief_dds.DimDate
	WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @CurrentMonthStart, 101))
	)
SET @CurrentFiscalYearEnd = @CurrentMonthEnd

SET @PriorFiscalYearStart = DATEADD(YEAR, -1, @CurrentFiscalYearStart)
SET @PriorFiscalYearEnd = DATEADD(YEAR, -1, @CurrentMonthEnd)
SET @Country = ''


INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (1, 'CurrentMonth', @CurrentMonthStart, @CurrentMonthEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (2, 'OneMonthBack', @OneMonthBackStart, @OneMonthBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (3, 'TwoMonthsBack', @TwoMonthsBackStart, @TwoMonthsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (4, 'ThreeMonthsBack', @ThreeMonthsBackStart, @ThreeMonthsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (5, 'OneYearBack', @OneYearBackStart, @OneYearBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (6, 'TwoYearsBack', @TwoYearsBackStart, @TwoYearsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (7, 'CurrentFiscalYear', @CurrentFiscalYearStart, @CurrentFiscalYearEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (8, 'PriorFiscalYear', @PriorFiscalYearStart, @PriorFiscalYearEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (9, 'CurrentMonthBudget', @CurrentMonthStart, @CurrentMonthEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (10, 'CurrentFiscalYearBudget', @CurrentFiscalYearStart, @CurrentFiscalYearEnd)


IF (@Month = MONTH(GETDATE()) AND @Year = YEAR(GETDATE()))
BEGIN
	-- Current month-day vs. total month-days (based on calendar days)
	SET @MonthTotalDays = (SELECT MAX(DAY(FullDate)) FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE MONTH(FullDate) = @Month AND YEAR(FullDate) = @Year)
	SET @CurrentDay = (SELECT DAY(GETDATE()))

	IF @CurrentDay >= 2
	BEGIN
		SET @CurrentDay = @CurrentDay - 1
	END

	SET @CurrentToTotal = (@CurrentDay / @MonthTotalDays)

	-- Current month-day vs. total month-days (based on work days)
	SET @MonthWorkdays = (SELECT [MonthWorkdaysTotal] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = (CONVERT(VARCHAR, @Month) + '/01/' + CONVERT(VARCHAR, @Year)))
	SET @CummWorkdays = (SELECT [CummWorkdays] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(VARCHAR, GETDATE(), 101))
	SET @CummToMonth = (@CummWorkdays / @MonthWorkdays)
	SET @TempDate = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/' + CONVERT(VARCHAR, DAY(GETDATE())) + '/' + CONVERT(VARCHAR, YEAR(@PriorFiscalYearEnd)))
	SET @CurrentToTotalYTD = dbo.DIVIDE_DECIMAL(DATEDIFF(DAY, @PriorFiscalYearStart, @TempDate), 365)
END
ELSE
BEGIN
	SET @CummToMonth = 1
	SET @CurrentToTotal = 1
	SET @CurrentToTotalYTD = 1
END

PRINT '@CummToMonth = ' + CAST(@CummToMonth AS NVARCHAR(12))

/********************************** Get Budget Data *****************************************************/

INSERT INTO #Data
(DateDesc
,	Leads
,	Appointments
,	Shows
,	Sales
,	XTRPlusInitVolumeOfSales
,	XTRPlusInitTotalCash
,	XTRPlusInit6VolumeOfSales
,	XTRPlusInit6TotalCash
,	XTRPlusTotalVolumeOfSales
,	XTRPlusTotalTotalCash
,	XTRVolumeOfSales
,	XTRTotalCash
,	ExtVolumeOfSales
,	ExtTotalCash
,	PostExtVolumeOfSales
,	PostExtTotalCash
,	SurgeryVolumeOfSales
,	SurgeryTotalCash
,	[RestorInkVolumeOfSales]
,	[RestorInkTotalCash]
,	TotalNewCustomerVolumeOfSales
,	TotalNewCustomerTotalCash
,	NewStyleDays
,	Conversions
,	[XTRPlusConversions]
,	XTRConversions
,	ExtConversions
,	PCPRevenue
)

SELECT #Dates.DateDesc
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10155 ) THEN a.Budget ELSE 0 END, 0)) AS 'LeadsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10100 ) THEN a.Budget ELSE 0 END, 0)) AS 'AppointmentsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10110 ) THEN a.Budget ELSE 0 END, 0)) AS 'ShowsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205,10206,10210,10215,10220,10225,10901 ) THEN a.Budget ELSE 0 END, 0)) AS 'SalesBudget'  --Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRPlusInitVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10305 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRPlusInitTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10210 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRPlusInit6VolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10310 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRPlusInit6TotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10210 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRTotalVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10310 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRTotalTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10206 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10306 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10215 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10315 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'PostExtVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10325 ) THEN a.Budget ELSE 0 END, 0)) AS 'PostExtTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10220 ) THEN a.Budget ELSE 0 END, 0)) AS 'SurgeryVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10320 ) THEN a.Budget ELSE 0 END, 0)) AS 'SurgeryTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10901 ) THEN a.Budget ELSE 0 END, 0)) AS 'RestorInkVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10891 ) THEN a.Budget ELSE 0 END, 0)) AS 'RestorInkTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205,10206,10210,10215,10220,10225,10901 ) THEN a.Budget ELSE 0 END, 0)) AS 'TotalNewCustomerVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10305,10306,10310,10315,10320,10325,10552,10891 ) THEN a.Budget ELSE 0 END, 0)) AS 'TotalNewCustomerTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10240 ) THEN a.Budget ELSE 0 END, 0)) AS 'NewStyleDaysBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10440 ) THEN a.Budget ELSE 0 END, 0)) AS 'ConversionsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10430 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRPlusConversionsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10433 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRConversionsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10435 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtConversionsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN (10536) THEN a.Budget ELSE 0 END, 0)) AS 'PCPRevenueBudget'
FROM HC_Accounting.dbo.FactAccounting a WITH(NOLOCK)
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH(NOLOCK)
		ON a.[CenterID] = CTR.CenterNumber
	INNER JOIN #Dates
		ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN #Centers
		ON a.CenterID = #Centers.CenterNumber
WHERE #Dates.DateID IN (9, 10)
GROUP BY #Dates.DateDesc


INSERT INTO #Budget
(DateDesc
,   Leads
,   Appointments
,   Shows
,   Sales
,   XTRPlusInitVolumeOfSales
,   XTRPlusInitTotalCash
,   XTRPlusInitCashPerSale
,   XTRPlusInit6VolumeOfSales
,   XTRPlusInit6TotalCash
,   XTRPlusInit6CashPerSale
,   XTRPlusTotalVolumeOfSales
,   XTRPlusTotalTotalCash
,   XTRPlusTotalCashPerSale
,   XTRVolumeOfSales
,   XTRTotalCash
,   XTRCashPerSale
,   ExtVolumeOfSales
,   ExtTotalCash
,   ExtCashPerSale
,   PostExtVolumeOfSales
,   PostExtTotalCash
,   PostExtCashPerSale
,   SurgeryVolumeOfSales
,   SurgeryTotalCash
,   SurgeryCashPerSale
,   RestorInkVolumeOfSales
,   RestorInkTotalCash
,   RestorInkCashPerSale
,   TotalNewCustomerVolumeOfSales
,   TotalNewCustomerTotalCash
,   TotalNewCustomerCashPerSale
,	NewStyleDays
,	Conversions
,	[XTRPlusConversions]
,	XTRConversions
,	ExtConversions
,	PCPRevenue )
SELECT DateDesc
,   Leads
,   Appointments
,   Shows
,   Sales
,   XTRPlusInitVolumeOfSales
,   XTRPlusInitTotalCash
,   dbo.DIVIDE_DECIMAL(XTRPlusInitTotalCash,XTRPlusInitVolumeOfSales) AS XTRPlusInitCashPerSale
,   XTRPlusInit6VolumeOfSales
,   XTRPlusInit6TotalCash
,   dbo.DIVIDE_DECIMAL(XTRPlusInit6TotalCash,XTRPlusInit6VolumeOfSales) AS XTRPlusInit6CashPerSale
,   XTRPlusTotalVolumeOfSales
,   XTRPlusTotalTotalCash
,   dbo.DIVIDE_DECIMAL(XTRPlusTotalTotalCash,XTRPlusTotalVolumeOfSales) AS XTRPlusTotalCashPerSale
,   XTRVolumeOfSales
,   XTRTotalCash
,   dbo.DIVIDE_DECIMAL(XTRTotalCash,XTRVolumeOfSales) AS XTRCashPerSale
,   ExtVolumeOfSales
,   ExtTotalCash
,   dbo.DIVIDE_DECIMAL(ExtTotalCash,ExtVolumeOfSales) AS ExtCashPerSale
,   PostExtVolumeOfSales
,   PostExtTotalCash
,   dbo.DIVIDE_DECIMAL(PostExtTotalCash,PostExtVolumeOfSales) AS PostExtCashPerSale
,   SurgeryVolumeOfSales
,   SurgeryTotalCash
,   dbo.DIVIDE_DECIMAL(SurgeryTotalCash,SurgeryVolumeOfSales) AS SurgeryCashPerSale
,   RestorInkVolumeOfSales
,   RestorInkTotalCash
,   dbo.DIVIDE_DECIMAL(RestorInkTotalCash,RestorInkVolumeOfSales) AS RestorInkCashPerSale
,   TotalNewCustomerVolumeOfSales
,   TotalNewCustomerTotalCash
,   dbo.DIVIDE_DECIMAL(TotalNewCustomerTotalCash,TotalNewCustomerVolumeOfSales) AS TotalNewCustomerCashPerSale
,	NewStyleDays
,	Conversions
,	[XTRPlusConversions]
,	XTRConversions
,	ExtConversions
,	PCPRevenue
FROM #Data


/* Get Actual Data */
INSERT INTO #Data (
	DateDesc
,	Sales
,	[XTRPlusInitVolumeOfSales]
,	[XTRPlusInitTotalCash]
,	[XTRPlusInit6VolumeOfSales]
,	[XTRPlusInit6TotalCash]
,	[XTRPlusTotalVolumeOfSales]
,	[XTRPlusTotalTotalCash]
,	XTRVolumeOfSales
,	XTRTotalCash
,	ExtVolumeOfSales
,	ExtTotalCash
,	PostExtVolumeOfSales
,	PostExtTotalCash
,	SurgeryVolumeOfSales
,	SurgeryTotalCash
,	RestorInkVolumeOfSales
,	RestorInkTotalCash
,	TotalNewCustomerVolumeOfSales
,	TotalNewCustomerTotalCash
,	NewStyleDays
,	Conversions
,	[XTRPlusConversions]
,	XTRConversions
,	ExtConversions
,	PCPRevenue
)
SELECT #Dates.DateDesc
,	SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRCnt, 0))
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0))
		+ SUM(ISNULL(FST.NB_MDPCnt, 0)) --Add MDP
		+ SUM(ISNULL(FST.S_PRPCnt, 0))
	AS 'Sales'
,	SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'XTRPlusInitVolumeOfSales'
,	SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'XTRPlusInitTotalCash'
,	SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XTRPlusInit6VolumeOfSales'
,	SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'XTRPlusInit6TotalCash'
,	SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XTRPlusTotalVolumeOfSales'
,	SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'XTRPlusTotalTotalCash'
,	SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'XTRVolumeOfSales'
,	SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'XTRTotalCash'
,	SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'EXTVolumeOfSales'
,	SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'EXTTotalCash'
,	SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostExtVolumeOfSales'
,	SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostExtTotalCash'
,	SUM(ISNULL(FST.S_SurCnt, 0)) + SUM(ISNULL(FST.S_PRPCnt, 0)) AS 'SurgeryVolumeOfSales'
,	SUM(ISNULL(FST.S_SurAmt, 0)) + SUM(ISNULL(FST.S_PRPAmt, 0)) AS 'SurgeryTotalCash'
,	SUM(ISNULL(FST.NB_MDPCnt, 0)) AS 'RestorInkVolumeOfSales'
,	SUM(ISNULL(FST.NB_MDPAmt, 0)) AS 'RestorInkTotalCash'
,	SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRCnt, 0))
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0))
		+ SUM(ISNULL(FST.NB_MDPCnt, 0))
		+ SUM(ISNULL(FST.S_PRPCnt, 0))
	AS 'TotalNewCustomerVolumeOfSales'
,	SUM(ISNULL(FST.NB_TradAmt, 0))
		+ SUM(ISNULL(FST.NB_GradAmt, 0))
		+ SUM(ISNULL(FST.NB_XTRAmt, 0))
		+ SUM(ISNULL(FST.NB_ExtAmt, 0))
		+ SUM(ISNULL(FST.S_PostExtAmt, 0))
		+ SUM(ISNULL(FST.S_SurAmt, 0))
		+ SUM(ISNULL(FST.NB_LaserAmt, 0))
		+ SUM(ISNULL(FST.NB_MDPAmt,0))
		+ SUM(ISNULL(FST.S_PRPAmt, 0))
	AS 'TotalNewCustomerTotalCash'
,	SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NewStyleDays'
,	SUM(ISNULL(FST.NB_BIOConvCnt, 0))
		+ SUM(ISNULL(FST.NB_EXTConvCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRConvCnt, 0))
	AS 'Conversions'
,	SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'XTRPlusConversions'
,	SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'XTRConversions'
,	SUM(ISNULL(FST.NB_EXTConvCnt, 0)) AS 'EXTConversions'
,	NULL AS PCPRevenue
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH(NOLOCK)
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH(NOLOCK)
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM WITH(NOLOCK)
		ON FST.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M WITH(NOLOCK)
		ON FST.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C WITH(NOLOCK)
		ON CM.CenterKey = C.CenterKey						--KEEP Home center based
	INNER JOIN #Centers
		ON C.CenterNumber = #Centers.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC WITH(NOLOCK)
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH(NOLOCK)  --Added this to remove voided transactions
		ON DSO.SalesOrderKey = FST.SalesOrderKey
WHERE #Dates.DateID NOT IN (9, 10)
	AND SC.SalesCodeSSID NOT IN (686, 399, 713, 714)
	AND DSO.IsVoidedFlag = 0
	AND (FST.NB_AppsCnt <> 0
		OR FST.NB_TradCnt <> 0
		OR FST.NB_TradAmt <> 0
		OR FST.NB_GradCnt <> 0
		OR FST.NB_GradAmt <> 0
		OR FST.NB_ExtCnt <> 0
		OR FST.NB_ExtAmt <> 0
		OR FST.NB_XTRCnt <> 0
		OR FST.NB_XTRAmt <> 0
		OR FST.NB_MDPCnt <> 0
		OR FST.NB_MDPAmt <> 0
		OR FST.S_PostExtCnt <> 0
		OR FST.S_PostExtAmt <> 0
		OR FST.S_SurCnt <> 0
		OR FST.S_SurAmt <> 0
		OR FST.S_PRPCnt <> 0
		OR FST.S_PRPAmt <> 0
		OR FST.NB_BIOConvCnt <> 0
		OR FST.NB_XTRConvCnt <> 0
		OR FST.NB_EXTConvCnt <> 0
		OR FST.NB_LaserAmt <> 0
		)
GROUP BY #Dates.DateDesc


/* Get Actual Appointments and Shows Data */

INSERT INTO #TmpApptShow
SELECT #Dates.DateDesc
,	SUM(ISNULL(FAR.Appointments, 0)) as 'Appointments'
,	NULL AS 'Consultation'
,	NULL AS 'BeBacks'
,	NULL AS 'BeBacksToExclude'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FAR.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FAR.ActivityDueDateKey = DD.datekey
	INNER JOIN #Centers
		ON CTR.CenterNumber = #Centers.CenterNumber
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate

	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
		ON FAR.SourceKey = DS.SourceKey

WHERE CTR.Active = 'Y'
	AND #Dates.DateID NOT IN (9, 10)
	AND ResultCodeKey <> -1
	AND DS.OwnerType <> 'Bosley Consult'

GROUP BY #Dates.DateDesc

INSERT INTO #TmpApptShow
SELECT #Dates.DateDesc
,	NULL AS 'Appointments'
,	SUM(ISNULL(FAR.Consultation, 0)) as 'Consultation'
,	SUM(CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN 1 ELSE 0 END) AS 'BeBacks'
,	SUM(CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END END) AS 'BeBacksToExclude'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FAR.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FAR.ActivityDueDateKey = DD.datekey
	INNER JOIN #Centers
		ON CTR.CenterNumber = #Centers.CenterNumber
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate

	--INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
	--	ON FAR.SourceKey = DS.SourceKey

WHERE #Dates.DateID NOT IN (9, 10)
	AND ResultCodeKey <> -1
	AND FAR.Show=1
	--AND DS.OwnerType <> 'Bosley Consult'

GROUP BY #Dates.DateDesc


/* Get Actual Leads Data */

SELECT #Dates.DateDesc
,	SUM(FL.[Leads]) AS 'Leads'
INTO #TmpLead
FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FL.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FL.LeadCreationDateKey = DD.datekey
	INNER JOIN #Centers
		ON CTR.CenterNumber = #Centers.CenterNumber
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
		ON FL.SourceKey = DS.SourceKey

WHERE CTR.Active = 'Y'
	AND #Dates.DateID NOT IN (9, 10)
	AND DS.OwnerType <> 'Bosley Consult'

GROUP BY #Dates.DateDesc


/* Get PCP Revenue */

SELECT	#Dates.DateDesc
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10536 ) THEN a.Flash ELSE 0 END, 0)) AS 'PCPRevenue'
INTO #PCPRevenue
FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON a.CenterID = CTR.CenterSSID
	INNER JOIN #Dates
		ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN #Centers
		ON a.CenterID = #Centers.CenterSSID
WHERE #Dates.DateID NOT IN (9, 10)
	AND a.AccountID=10536
GROUP BY #Dates.DateDesc


/* UPDATE Appointments and Shows values in temp table */
UPDATE d
SET d.Appointments = t.Appointments
,	d.Shows = t.Consultation
,	d.BeBacks = t.BeBacks
,	d.BeBacksToExclude = t.BeBacksToExclude
FROM #Data d
	LEFT OUTER JOIN #TmpApptShow t
		ON d.DateDesc = t.DateDesc


/* UPDATE Leads values in temp table */
UPDATE d
SET d.Leads = t.Leads
FROM #Data d
	LEFT OUTER JOIN #TmpLead t
		ON d.DateDesc = t.DateDesc
WHERE d.Leads IS NULL

/* UPDATE PCP Revenue values in temp table */
UPDATE d
SET d.PCPRevenue = t.PCPRevenue
FROM #Data d
	LEFT OUTER JOIN #PCPRevenue t
		ON d.DateDesc = t.DateDesc
WHERE d.PCPRevenue IS NULL


/********* Allow for @CummToMonth except for 'CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget' ********/

INSERT INTO #Final (
	DateDesc
,	Leads
,	Appointments
,	Shows
,	Sales
,	SalesToLeads
,	ConsultsToAppointments
,	SalesToConsultations
,	XTRPlusInitVolumeOfSales
,	XTRPlusInitTotalCash
,	XTRPlusInitCashPerSale
,	XTRPlusInitSalesMix
,	XTRPlusInit6VolumeOfSales
,	XTRPlusInit6TotalCash
,	XTRPlusInit6CashPerSale
,	XTRPlusInit6SalesMix
,	XTRPlusTotalVolumeOfSales
,	XTRPlusTotalTotalCash
,	XTRPlusTotalCashPerSale
,	XTRPlusTotalSalesMix
,	XTRVolumeOfSales
,	XTRTotalCash
,	XTRCashPerSale
,	XTRSalesMix
,	ExtVolumeOfSales
,	ExtTotalCash
,	ExtCashPerSale
,	ExtSalesMix
,	PostExtVolumeOfSales
,	PostExtTotalCash
,	PostExtCashPerSale
,	PostExtSalesMix
,	SurgeryVolumeOfSales
,	SurgeryTotalCash
,	SurgeryCashPerSale
,	SurgerySalesMix
,	RestorInkVolumeOfSales
,	RestorInkTotalCash
,	RestorInkCashPerSale
,	RestorInkSalesMix
,	TotalNewCustomerVolumeOfSales
,	TotalNewCustomerTotalCash
,	TotalNewCustomerCashPerSale
,	NewStyleDays
,	NSDToSales
,	Conversions
,	ConvsToNSD
,	XTRPlusConversions
,	XTRConversions
,	ExtConversions
,	XTRPlusConvsToNSD
,	XTRConvsToSales
,	ExtConvsToSales
,	PCPRevenue
)
SELECT d.DateDesc
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.Leads,0) ELSE ISNULL(d.Leads,0) * @CurrentToTotal END AS 'Leads'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.Appointments,0) ELSE ISNULL(d.Appointments,0) * @CummToMonth END AS 'Appointments'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.Shows,0) ELSE ISNULL(d.Shows,0) * @CummToMonth END AS 'Shows'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.Sales,0) ELSE ISNULL(d.Sales,0) * @CummToMonth END AS 'Sales'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.Sales, d.Leads),0) AS 'SalesToLeads'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.Shows, d.Appointments),0) AS 'ConsultsToAppointments'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.Sales, (d.Shows-d.BeBacksToExclude)),0) AS 'SalesToConsultations'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusInitVolumeOfSales],0) ELSE ISNULL(d.[XTRPlusInitVolumeOfSales],0) * @CummToMonth END AS 'XTRPlusInitVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusInitTotalCash],0) ELSE ISNULL(d.[XTRPlusInitTotalCash],0) * @CummToMonth END AS 'XTRPlusInitTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusInitTotalCash], d.[XTRPlusInitVolumeOfSales]),0) AS 'XTRPlusInitCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusInitVolumeOfSales], d.[XTRPlusTotalVolumeOfSales]),0) AS 'XTRPlusInitSalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusInit6VolumeOfSales],0) ELSE ISNULL(d.[XTRPlusInit6VolumeOfSales],0) * @CummToMonth END AS [XTRPlusInit6VolumeOfSales]
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusInit6TotalCash],0) ELSE ISNULL(d.[XTRPlusInit6TotalCash],0) * @CummToMonth END AS 'XTRPlusInit6TotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusInit6TotalCash], d.[XTRPlusInit6VolumeOfSales]),0) AS 'XTRPlusInit6CashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusInit6VolumeOfSales], d.[XTRPlusTotalVolumeOfSales]),0) AS 'XTRPlusInit6SalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusTotalVolumeOfSales],0) ELSE ISNULL(d.[XTRPlusTotalVolumeOfSales],0) * @CummToMonth END AS 'XTRPlusTotalVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusTotalTotalCash],0) ELSE ISNULL(d.[XTRPlusTotalTotalCash],0) * @CummToMonth END AS 'XTRPlusTotalTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusTotalTotalCash], d.[XTRPlusTotalVolumeOfSales]),0) AS 'XTRPlusTotalCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusTotalVolumeOfSales], d.TotalNewCustomerVolumeOfSales),0) AS 'XTRPlusTotalSalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.XTRVolumeOfSales,0) ELSE ISNULL(d.XTRVolumeOfSales,0) * @CummToMonth END AS 'XTRVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.XTRTotalCash,0) ELSE ISNULL(d.XTRTotalCash,0) * @CummToMonth END AS 'XTRTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.XTRTotalCash, d.XTRVolumeOfSales),0) AS 'XTRCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.XTRVolumeOfSales, d.TotalNewCustomerVolumeOfSales),0) AS 'XTRSalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.ExtVolumeOfSales,0) ELSE ISNULL(d.ExtVolumeOfSales,0) * @CummToMonth END AS 'ExtVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.ExtTotalCash,0) ELSE ISNULL(d.ExtTotalCash,0) * @CummToMonth END AS 'ExtTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.ExtTotalCash, d.ExtVolumeOfSales),0) AS 'ExtCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.ExtVolumeOfSales, d.TotalNewCustomerVolumeOfSales),0) AS 'ExtSalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.PostExtVolumeOfSales,0) ELSE ISNULL(d.PostExtVolumeOfSales,0) * @CummToMonth END AS 'PostExtVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.PostExtTotalCash,0) ELSE ISNULL(d.PostExtTotalCash,0) * @CummToMonth END AS 'PostExtTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.PostExtTotalCash, d.PostExtVolumeOfSales),0) AS 'PostExtCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.PostExtVolumeOfSales, d.TotalNewCustomerVolumeOfSales),0) AS 'PostExtSalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.SurgeryVolumeOfSales,0) ELSE ISNULL(d.SurgeryVolumeOfSales,0) * @CummToMonth END AS 'SurgeryVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.SurgeryTotalCash,0) ELSE ISNULL(d.SurgeryTotalCash,0) * @CummToMonth END AS 'SurgeryTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.SurgeryTotalCash, d.SurgeryVolumeOfSales),0) AS 'SurgeryCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.SurgeryVolumeOfSales, d.TotalNewCustomerVolumeOfSales),0) AS 'SurgerySalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.RestorInkVolumeOfSales,0) ELSE ISNULL(d.RestorInkVolumeOfSales,0) * @CummToMonth END AS 'RestorInkVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.RestorInkTotalCash,0) ELSE ISNULL(d.RestorInkTotalCash,0) * @CummToMonth END AS 'RestorInkTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.RestorInkTotalCash, d.RestorInkVolumeOfSales),0) AS 'RestorInkCashPerSale'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.RestorInkVolumeOfSales, d.TotalNewCustomerVolumeOfSales),0) AS 'RestorInkSalesMix'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.TotalNewCustomerVolumeOfSales,0) ELSE ISNULL(d.TotalNewCustomerVolumeOfSales,0) * @CummToMonth END AS 'TotalNewCustomerVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.TotalNewCustomerTotalCash,0) ELSE ISNULL(d.TotalNewCustomerTotalCash,0) * @CummToMonth END AS 'TotalNewCustomerTotalCash'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.TotalNewCustomerTotalCash, d.TotalNewCustomerVolumeOfSales),0) AS 'TotalNewCustomerCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.NewStyleDays,0) ELSE ISNULL(d.NewStyleDays,0) * @CummToMonth END AS 'NewStyleDays'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.NewStyleDays, d.[XTRPlusTotalVolumeOfSales]),0) AS 'NSDToSales'
,	ISNULL(d.Conversions,0) AS Conversions
,	ISNULL(dbo.DIVIDE_DECIMAL(d.Conversions, d.NewStyleDays),0) AS 'ConvsToNSD'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.[XTRPlusConversions],0) ELSE ISNULL(d.[XTRPlusConversions],0) * @CummToMonth END AS 'XTRPlusConversions'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.XTRConversions,0) ELSE ISNULL(d.XTRConversions,0) * @CummToMonth END AS 'XTRConversions'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.ExtConversions,0) ELSE ISNULL(d.ExtConversions,0) * @CummToMonth END AS 'ExtConversions'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.[XTRPlusConversions], d.NewStyleDays),0) AS 'XTRPlusConvsToNSD'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.XTRConversions, d.XTRVolumeOfSales),0) AS 'XTRConvsToSales'
,	ISNULL(dbo.DIVIDE_DECIMAL(d.ExtConversions, d.ExtVolumeOfSales),0) AS 'ExtConvsToSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN ISNULL(d.PCPRevenue,0) ELSE ISNULL(d.PCPRevenue,0) * @CummToMonth END AS 'PCPRevenue'

FROM #Data d

--SELECT '#Final' AS tablename,* FROM #Final

/******************** Add addtional columns CurrentMonthActualToBudget, Variance, and YTDToBudget ******************************************************/
/******* These columns were erroring in the report, so they have been moved to inside this stored procedure.  The next large section of code is populating these values. ******************************/
INSERT INTO #Final
SELECT 'CurrentMonthActualToBudget',NULL,NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL

INSERT INTO #Final
SELECT   'Variance',NULL,NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL

INSERT INTO #Final
SELECT 'YTDToBudget',NULL,NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL




/*
	Unpivot query results to get in desired format
*/

SELECT DateDesc
,	Metric
,	Value
INTO #Unpivot
FROM (
	SELECT DateDesc
	,	CONVERT(VARCHAR(50), [Leads]) AS [Leads]
	,	CONVERT(VARCHAR(50), [Appointments]) AS [Appointments]
	,	CONVERT(VARCHAR(50), [Shows]) AS [Shows]
	,	CONVERT(VARCHAR(50), [Sales]) AS [Sales]
	,	CONVERT(VARCHAR(50), [SalesToLeads]) AS [SalesToLeads]
	,	CONVERT(VARCHAR(50), [ConsultsToAppointments]) AS [ConsultsToAppointments]
	,	CONVERT(VARCHAR(50), [SalesToConsultations]) AS [SalesToConsultations]
	,	CONVERT(VARCHAR(50), [XTRPlusInitVolumeOfSales]) AS [XTR+InitVolumeOfSales]
	,	CONVERT(VARCHAR(50), [XTRPlusInitTotalCash]) AS [XTR+InitTotalCash]
	,	CONVERT(VARCHAR(50), [XTRPlusInitCashPerSale]) AS [XTR+InitCashPerSale]
	,	CONVERT(VARCHAR(50), [XTRPlusInitSalesMix]) AS [XTR+InitSalesMix]
	,	CONVERT(VARCHAR(50), [XTRPlusInit6VolumeOfSales]) AS [XTR+Init6VolumeOfSales]
	,	CONVERT(VARCHAR(50), [XTRPlusInit6TotalCash]) AS [XTR+Init6TotalCash]
	,	CONVERT(VARCHAR(50), [XTRPlusInit6CashPerSale]) AS [XTR+Init6CashPerSale]
	,	CONVERT(VARCHAR(50), [XTRPlusInit6SalesMix]) AS [XTR+Init6SalesMix]
	,	CONVERT(VARCHAR(50), [XTRPlusTotalVolumeOfSales]) AS [XTR+TotalVolumeOfSales]
	,	CONVERT(VARCHAR(50), [XTRPlusTotalTotalCash]) AS [XTR+TotalTotalCash]
	,	CONVERT(VARCHAR(50), [XTRPlusTotalCashPerSale]) AS [XTR+TotalCashPerSale]
	,	CONVERT(VARCHAR(50), [XTRPlusTotalSalesMix]) AS [XTR+TotalSalesMix]
	,	CONVERT(VARCHAR(50), [XTRVolumeOfSales]) AS [XTRVolumeOfSales]
	,	CONVERT(VARCHAR(50), [XTRTotalCash]) AS [XTRTotalCash]
	,	CONVERT(VARCHAR(50), [XTRCashPerSale]) AS [XTRCashPerSale]
	,	CONVERT(VARCHAR(50), [XTRSalesMix]) AS [XTRSalesMix]
	,	CONVERT(VARCHAR(50), [ExtVolumeOfSales]) AS [ExtVolumeOfSales]
	,	CONVERT(VARCHAR(50), [ExtTotalCash]) AS [ExtTotalCash]
	,	CONVERT(VARCHAR(50), [ExtCashPerSale]) AS [ExtCashPerSale]
	,	CONVERT(VARCHAR(50), [ExtSalesMix]) AS [ExtSalesMix]
	,	CONVERT(VARCHAR(50), [PostExtVolumeOfSales]) AS [PostExtVolumeOfSales]
	,	CONVERT(VARCHAR(50), [PostExtTotalCash]) AS [PostExtTotalCash]
	,	CONVERT(VARCHAR(50), [PostExtCashPerSale]) AS [PostExtCashPerSale]
	,	CONVERT(VARCHAR(50), [PostExtSalesMix]) AS [PostExtSalesMix]
	,	CONVERT(VARCHAR(50), [SurgeryVolumeOfSales]) AS [SurgeryVolumeOfSales]
	,	CONVERT(VARCHAR(50), [SurgeryTotalCash]) AS [SurgeryTotalCash]
	,	CONVERT(VARCHAR(50), [SurgeryCashPerSale]) AS [SurgeryCashPerSale]
	,	CONVERT(VARCHAR(50), [SurgerySalesMix]) AS [SurgerySalesMix]
	,	CONVERT(VARCHAR(50), [RestorInkVolumeOfSales]) AS [RestorInkVolumeOfSales]
	,	CONVERT(VARCHAR(50), [RestorInkTotalCash]) AS [RestorInkTotalCash]
	,	CONVERT(VARCHAR(50), [RestorInkCashPerSale]) AS [RestorInkCashPerSale]
	,	CONVERT(VARCHAR(50), [RestorInkSalesMix]) AS [RestorInkSalesMix]
	,	CONVERT(VARCHAR(50), [TotalNewCustomerVolumeOfSales]) AS [TotalNewCustomerVolumeOfSales]
	,	CONVERT(VARCHAR(50), [TotalNewCustomerTotalCash]) AS [TotalNewCustomerTotalCash]
	,	CONVERT(VARCHAR(50), [TotalNewCustomerCashPerSale]) AS [TotalNewCustomerCashPerSale]
	,	CONVERT(VARCHAR(50), [NewStyleDays]) AS [NewStyleDays]
	,	CONVERT(VARCHAR(50), [NSDToSales]) AS [NSDToSales]
	,	CONVERT(VARCHAR(50), [Conversions]) AS [Conversions]
	,	CONVERT(VARCHAR(50), [ConvsToNSD]) AS [ConvsToNSD]
	,	CONVERT(VARCHAR(50), [XTRPlusConversions]) AS [XTR+Conversions]
	,	CONVERT(VARCHAR(50), [XTRConversions]) AS [XTRConversions]
	,	CONVERT(VARCHAR(50), [ExtConversions]) AS [ExtConversions]
	,	CONVERT(VARCHAR(50), [XTRPlusConvsToNSD]) AS [XTR+ConvsToNSD]
	,	CONVERT(VARCHAR(50), [XTRConvsToSales]) AS [XTRConvsToSales]
	,	CONVERT(VARCHAR(50), [ExtConvsToSales]) AS [ExtConvsToSales]
	,	CONVERT(VARCHAR(50), [PCPRevenue]) AS [PCPRevenue]
	FROM #Final
) f
UNPIVOT(
	Value FOR Metric IN (
		Leads
	,	Appointments
	,	Shows
	,	Sales
	,	SalesToLeads
	,	ConsultsToAppointments
	,	SalesToConsultations
	,	[XTR+InitVolumeOfSales]
	,	[XTR+InitTotalCash]
	,	[XTR+InitCashPerSale]
	,	[XTR+InitSalesMix]
	,	[XTR+Init6VolumeOfSales]
	,	[XTR+Init6TotalCash]
	,	[XTR+Init6CashPerSale]
	,	[XTR+Init6SalesMix]
	,	[XTR+TotalVolumeOfSales]
	,	[XTR+TotalTotalCash]
	,	[XTR+TotalCashPerSale]
	,	[XTR+TotalSalesMix]
	,	XTRVolumeOfSales
	,	XTRTotalCash
	,	XTRCashPerSale
	,	XTRSalesMix
	,	ExtVolumeOfSales
	,	ExtTotalCash
	,	ExtCashPerSale
	,	ExtSalesMix
	,	PostExtVolumeOfSales
	,	PostExtTotalCash
	,	PostExtCashPerSale
	,	PostExtSalesMix
	,	SurgeryVolumeOfSales
	,	SurgeryTotalCash
	,	SurgeryCashPerSale
	,	SurgerySalesMix
	,	RestorInkVolumeOfSales
	,	RestorInkTotalCash
	,	RestorInkCashPerSale
	,	RestorInkSalesMix
	,	TotalNewCustomerVolumeOfSales
	,	TotalNewCustomerTotalCash
	,	TotalNewCustomerCashPerSale
	,	NewStyleDays
	,	NSDToSales
	,	Conversions
	,	ConvsToNSD
	,	[XTR+Conversions]
	,	XTRConversions
	,	ExtConversions
	,	[XTR+ConvsToNSD]
	,	XTRConvsToSales
	,	ExtConvsToSales
	,	PCPRevenue
	)
) AS UnPVT



INSERT INTO #SSRS
SELECT [Metric]
,	[CurrentMonth]
,	[OneMonthBack]
,	[TwoMonthsBack]
,	[ThreeMonthsBack]
,	[OneYearBack]
,	[TwoYearsBack]
,	[CurrentFiscalYear]
,	[PriorFiscalYear]
,	[CurrentMonthBudget]
,	[CurrentFiscalYearBudget]
,	CurrentMonthActualToBudget
,	Variance
,	YTDToBudget
,	0 AS 'Bold'
,	0 AS 'RowOrder'
,	0 AS 'RowValue'
FROM #Unpivot
PIVOT(
	MAX(Value)
	FOR DateDesc IN (
		[CurrentMonth]
	,	[OneMonthBack]
	,	[TwoMonthsBack]
	,	[ThreeMonthsBack]
	,	[OneYearBack]
	,	[TwoYearsBack]
	,	[CurrentFiscalYear]
	,	[PriorFiscalYear]
	,	[CurrentMonthBudget]
	,	[CurrentFiscalYearBudget]
	,	CurrentMonthActualToBudget
,	Variance
,	YTDToBudget
	)
) AS PVT



/************************ Find the values for CurrentMonthActualToBudget, Variance and YTDToBudget per row *********************************/

/**  Conversions ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Consultations') FROM #SSRS WHERE #SSRS.Metric = 'Consultations'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Consultations') FROM #SSRS WHERE #SSRS.Metric = 'Consultations'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'Consultations') FROM #SSRS WHERE #SSRS.Metric = 'Consultations'
/**  Leads ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Leads') FROM #SSRS WHERE #SSRS.Metric = 'Leads'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Leads') FROM #SSRS WHERE #SSRS.Metric = 'Leads'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'Leads') FROM #SSRS WHERE #SSRS.Metric = 'Leads'
/**  Appointments ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Appointments') FROM #SSRS WHERE #SSRS.Metric = 'Appointments'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Appointments') FROM #SSRS WHERE #SSRS.Metric = 'Appointments'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'Appointments') FROM #SSRS WHERE #SSRS.Metric = 'Appointments'
/**  Shows ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Shows') FROM #SSRS WHERE #SSRS.Metric = 'Shows'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Shows') FROM #SSRS WHERE #SSRS.Metric = 'Shows'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'Shows') FROM #SSRS WHERE #SSRS.Metric = 'Shows'
/**  Sales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Sales') FROM #SSRS WHERE #SSRS.Metric = 'Sales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'Sales') FROM #SSRS WHERE #SSRS.Metric = 'Sales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'Sales') FROM #SSRS WHERE #SSRS.Metric = 'Sales'
/**  SalesToLeads ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SalesToLeads') FROM #SSRS WHERE #SSRS.Metric = 'SalesToLeads'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SalesToLeads') FROM #SSRS WHERE #SSRS.Metric = 'SalesToLeads'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'SalesToLeads') FROM #SSRS WHERE #SSRS.Metric = 'SalesToLeads'
/**  ConsultsToAppointments ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ConsultsToAppointments') FROM #SSRS WHERE #SSRS.Metric = 'ConsultsToAppointments'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ConsultsToAppointments') FROM #SSRS WHERE #SSRS.Metric = 'ConsultsToAppointments'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ConsultsToAppointments') FROM #SSRS WHERE #SSRS.Metric = 'ConsultsToAppointments'
/**  SalesToConsultations ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SalesToConsultations') FROM #SSRS WHERE #SSRS.Metric = 'SalesToConsultations'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SalesToConsultations') FROM #SSRS WHERE #SSRS.Metric = 'SalesToConsultations'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'SalesToConsultations') FROM #SSRS WHERE #SSRS.Metric = 'SalesToConsultations'
/**  XTR+InitVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+InitVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitVolumeOfSales'
/**  XTR+InitSalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitSalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitSalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+InitSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitSalesMix'
/**  XTR+InitTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+InitTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitTotalCash'
/**  XTR+InitCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+InitCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+InitCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+InitCashPerSale'
/**  XTR+Init6VolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6VolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6VolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6VolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6VolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+Init6VolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6VolumeOfSales'
/**  XTR+Init6SalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6SalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6SalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6SalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6SalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+Init6SalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6SalesMix'
/**  XTR+Init6TotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6TotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6TotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6TotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6TotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+Init6TotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6TotalCash'
/**  XTR+Init6CashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6CashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6CashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Init6CashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6CashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+Init6CashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Init6CashPerSale'
/**  XTR+TotalVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+TotalVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalVolumeOfSales'
/**  XTR+TotalSalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalSalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalSalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+TotalSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalSalesMix'
/**  XTR+TotalTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+TotalTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalTotalCash'
/**  XTR+TotalCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+TotalCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+TotalCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTR+TotalCashPerSale'

/**  XTRVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTRVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTRVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTRVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'XTRVolumeOfSales'
/**  XtrSalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XtrSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XtrSalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XtrSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XtrSalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XtrSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'XtrSalesMix'
/**  XTRTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTRTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTRTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTRTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'XTRTotalCash'
/**  XTRCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTRCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTRCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTRCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'XTRCashPerSale'
/**  ExtVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'ExtVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'ExtVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ExtVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'ExtVolumeOfSales'
/**  ExtSalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'ExtSalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'ExtSalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ExtSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'ExtSalesMix'
/**  ExtTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'ExtTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'ExtTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ExtTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'ExtTotalCash'
/**  ExtCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'ExtCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'ExtCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ExtCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'ExtCashPerSale'
/**  PostExtVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'PostExtVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'PostExtVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'PostExtVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'PostExtVolumeOfSales'
/**  PostExtSalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'PostExtSalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'PostExtSalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'PostExtSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'PostExtSalesMix'
/**  PostExtTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'PostExtTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'PostExtTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'PostExtTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'PostExtTotalCash'
/**  PostExtCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'PostExtCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PostExtCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'PostExtCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'PostExtCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'PostExtCashPerSale'

/**  SurgeryVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgeryVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgeryVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'SurgeryVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryVolumeOfSales'
/**  SurgerySalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgerySalesMix') FROM #SSRS WHERE #SSRS.Metric = 'SurgerySalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgerySalesMix') FROM #SSRS WHERE #SSRS.Metric = 'SurgerySalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'SurgerySalesMix') FROM #SSRS WHERE #SSRS.Metric = 'SurgerySalesMix'
/**  SurgeryTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgeryTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgeryTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'SurgeryTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryTotalCash'
/**  SurgeryCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgeryCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'SurgeryCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'SurgeryCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'SurgeryCashPerSale'
/**  RestorInkVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'RestorInkVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkVolumeOfSales'
/**  RestorInkSalesMix ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkSalesMix'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkSalesMix'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'RestorInkSalesMix') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkSalesMix'
/**  RestorInkTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'RestorInkTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkTotalCash'
/**  RestorInkCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'RestorInkCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'RestorInkCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'RestorInkCashPerSale'
/**  TotalNewCustomerVolumeOfSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerVolumeOfSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerVolumeOfSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerVolumeOfSales') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerVolumeOfSales'
/**  TotalNewCustomerTotalCash ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerTotalCash'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerTotalCash'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerTotalCash') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerTotalCash'
/**  TotalNewCustomerCashPerSale ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerCashPerSale'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerCashPerSale'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'TotalNewCustomerCashPerSale') FROM #SSRS WHERE #SSRS.Metric = 'TotalNewCustomerCashPerSale'

/**  NewStyleDays ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'NewStyleDays') FROM #SSRS WHERE #SSRS.Metric = 'NewStyleDays'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'NewStyleDays') FROM #SSRS WHERE #SSRS.Metric = 'NewStyleDays'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'NewStyleDays') FROM #SSRS WHERE #SSRS.Metric = 'NewStyleDays'
/**  NSDToSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'NSDToSales') FROM #SSRS WHERE #SSRS.Metric = 'NSDToSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'NSDToSales') FROM #SSRS WHERE #SSRS.Metric = 'NSDToSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'NSDToSales') FROM #SSRS WHERE #SSRS.Metric = 'NSDToSales'
/**  XTR+Conversions ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Conversions') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Conversions'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+Conversions') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Conversions'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+Conversions') FROM #SSRS WHERE #SSRS.Metric = 'XTR+Conversions'
/**  XTRConversions ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRConversions') FROM #SSRS WHERE #SSRS.Metric = 'XTRConversions'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRConversions') FROM #SSRS WHERE #SSRS.Metric = 'XTRConversions'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTRConversions') FROM #SSRS WHERE #SSRS.Metric = 'XTRConversions'
/**  EXTConversions ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtConversions') FROM #SSRS WHERE #SSRS.Metric = 'ExtConversions'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtConversions') FROM #SSRS WHERE #SSRS.Metric = 'ExtConversions'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ExtConversions') FROM #SSRS WHERE #SSRS.Metric = 'ExtConversions'


/**  XTR+ConvsToNSD ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+ConvsToNSD') FROM #SSRS WHERE #SSRS.Metric = 'XTR+ConvsToNSD'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTR+ConvsToNSD') FROM #SSRS WHERE #SSRS.Metric = 'XTR+ConvsToNSD'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTR+ConvsToNSD') FROM #SSRS WHERE #SSRS.Metric = 'XTR+ConvsToNSD'
/**  XTRConvsToSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRConvsToSales') FROM #SSRS WHERE #SSRS.Metric = 'XTRConvsToSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'XTRConvsToSales') FROM #SSRS WHERE #SSRS.Metric = 'XTRConvsToSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'XTRConvsToSales') FROM #SSRS WHERE #SSRS.Metric = 'XTRConvsToSales'
/**  ExtConvsToSales ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtConvsToSales') FROM #SSRS WHERE #SSRS.Metric = 'ExtConvsToSales'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'ExtConvsToSales') FROM #SSRS WHERE #SSRS.Metric = 'ExtConvsToSales'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'ExtConvsToSales') FROM #SSRS WHERE #SSRS.Metric = 'ExtConvsToSales'
/**  PCPRevenue ***/
UPDATE #SSRS SET CurrentMonthActualToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentMonth,CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PCPRevenue') FROM #SSRS WHERE #SSRS.Metric = 'PCPRevenue'
UPDATE #SSRS SET Variance = (SELECT (CurrentMonth - CurrentMonthBudget) FROM #SSRS WHERE Metric = 'PCPRevenue') FROM #SSRS WHERE #SSRS.Metric = 'PCPRevenue'
UPDATE #SSRS SET YTDToBudget = (SELECT dbo.DIVIDE_DECIMAL(CurrentFiscalYear,CurrentFiscalYearBudget) FROM #SSRS WHERE Metric = 'PCPRevenue') FROM #SSRS WHERE #SSRS.Metric = 'PCPRevenue'



/**********  Format each field in the row as Percent, Number or Currency *************************************************************/

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'Leads'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'Appointments'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ConsultsToAppointments'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'Consultations'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ConvsToNSD'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ExtCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ExtConversions'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ExtConvsToSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ExtSalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ExtTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'ExtVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'NewStyleDays'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'NSDToSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'PCPRevenue'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'PostExtCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'PostExtSalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'PostExtTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'PostExtVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'RestorInkCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'RestorInkSalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'RestorInkTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'RestorInkVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'Sales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'SalesToConsultations'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(ISNULL(CurrentMonthActualToBudget,0),'P0') as 'CurrentMonthActualToBudget'
,FORMAT(ISNULL(Variance,0),'P0') as 'Variance',FORMAT(ISNULL(YTDToBudget,0),'P0') as 'YTDToBudget' from #SSRS  where Metric = 'SalesToLeads'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'Shows'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'SurgeryCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'SurgerySalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'SurgeryTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'SurgeryVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'TotalNewCustomerCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'TotalNewCustomerTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'TotalNewCustomerVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+Conversions'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+ConvsToNSD'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+Init6CashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+Init6SalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+Init6TotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+Init6VolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+InitCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+InitSalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+InitTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+InitVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+TotalCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+TotalSalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+TotalTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTR+TotalVolumeOfSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTRCashPerSale'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTRConversions'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTRConvsToSales'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'P0') as 'CurrentMonth',FORMAT(OneMonthBack,'P0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'P0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'P0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'P0') as 'OneYearBack',FORMAT(TwoYearsBack,'P0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'P0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'P0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'P0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'P0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'P0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTRSalesMix'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'C0') as 'CurrentMonth',FORMAT(OneMonthBack,'C0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'C0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'C0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'C0') as 'OneYearBack',FORMAT(TwoYearsBack,'C0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'C0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'C0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'C0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'C0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'C0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTRTotalCash'

INSERT INTO #Format
(Metric,CurrentMonth, OneMonthBack,TwoMonthsBack,ThreeMonthsBack,OneYearBack,TwoYearsBack,CurrentFiscalYear,PriorFiscalYear,CurrentMonthBudget,CurrentFiscalYearBudget,CurrentMonthActualToBudget,Variance,YTDToBudget)select Metric,FORMAT(CurrentMonth,'N0') as 'CurrentMonth',FORMAT(OneMonthBack,'N0') as 'OneMonthBack',FORMAT(TwoMonthsBack,'N0') as 'TwoMonthsBack',FORMAT(ThreeMonthsBack,'N0') as 'ThreeMonthsBack'
,FORMAT(OneYearBack,'N0') as 'OneYearBack',FORMAT(TwoYearsBack,'N0') as 'TwoYearsBack',FORMAT(CurrentFiscalYear,'N0') as 'CurrentFiscalYear',FORMAT(PriorFiscalYear,'N0') as 'PriorFiscalYear',FORMAT(CurrentMonthBudget,'N0') as 'CurrentMonthBudget',FORMAT(CurrentFiscalYearBudget,'N0') as 'CurrentFiscalYearBudget',FORMAT(CurrentMonthActualToBudget,'P0') as 'CurrentMonthActualToBudget'
,FORMAT(Variance,'N0') as 'Variance',FORMAT(YTDToBudget,'P0') as 'YTDToBudget' from #SSRS  where Metric = 'XTRVolumeOfSales'



/**************  Set row order as this will be used in the report ******************************************/


INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('', 0, 8, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('XTR+Init', 1, 9, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('XTR+Init6', 1, 14, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('XTR+Total', 1, 19, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('Xtrands', 1, 24, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('EXT', 1, 29, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('Post EXT', 1, 34, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('Surgery', 1, 39, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('RestorInk', 1, 44, 1)
INSERT INTO #Format (Metric, Bold, RowOrder, RowValue) VALUES ('Total New Customer', 1, 49, 1)
UPDATE #Format SET Bold=1 WHERE [Metric] IN (	'SalesToConsultations')
UPDATE #Format SET RowOrder=1, Metric='Leads' WHERE Metric='Leads'
UPDATE #Format SET RowOrder=2, Metric='Appointments' WHERE Metric='Appointments'
UPDATE #Format SET RowOrder=3, Metric='Consultations' WHERE Metric='Shows'
UPDATE #Format SET RowOrder=4, Metric='Sales' WHERE Metric='Sales'
UPDATE #Format SET RowOrder=5, RowValue = 1, Metric='Sales to Leads %' WHERE Metric='SalesToLeads'
UPDATE #Format SET RowOrder=6, RowValue = 1, Metric='Consults to Appointments %' WHERE Metric='ConsultsToAppointments'
UPDATE #Format SET RowOrder=7, RowValue = 1, Metric='Sales to Consultations' WHERE Metric='SalesToConsultations'
UPDATE #Format SET RowOrder=10, Metric='Volume of Sales' WHERE Metric='XTR+InitVolumeOfSales'
UPDATE #Format SET RowOrder=11, Metric='Sales Mix' WHERE Metric='XTR+InitSalesMix'
UPDATE #Format SET RowOrder=12, Metric='Cash per Sale'  WHERE Metric='XTR+InitCashPerSale'
UPDATE #Format SET RowOrder=13, Metric='Total Cash' WHERE Metric='XTR+InitTotalCash'
UPDATE #Format SET RowOrder=15, Metric='Volume of Sales' WHERE Metric='XTR+Init6VolumeOfSales'
UPDATE #Format SET RowOrder=16, Metric='Sales Mix'  WHERE Metric='XTR+Init6SalesMix'
UPDATE #Format SET RowOrder=17, Metric='Cash per Sale' WHERE Metric='XTR+Init6CashPerSale'
UPDATE #Format SET RowOrder=18, Metric='Total Cash'  WHERE Metric='XTR+Init6TotalCash'
UPDATE #Format SET RowOrder=20, Metric='Volume of Sales' WHERE Metric='XTR+TotalVolumeOfSales'
UPDATE #Format SET RowOrder=21, Metric='Sales Mix' WHERE Metric='XTR+TotalSalesMix'
UPDATE #Format SET RowOrder=22, Metric='Cash per Sale' WHERE Metric='XTR+TotalCashPerSale'
UPDATE #Format SET RowOrder=23, Metric='Total Cash' WHERE Metric='XTR+TotalTotalCash'
UPDATE #Format SET RowOrder=25, Metric='Volume of Sales' WHERE Metric='XTRVolumeOfSales'
UPDATE #Format SET RowOrder=26, Metric='Sales Mix' WHERE Metric='XTRSalesMix'
UPDATE #Format SET RowOrder=27, Metric='Cash per Sale' WHERE Metric='XTRCashPerSale'
UPDATE #Format SET RowOrder=28, Metric='Total Cash' WHERE Metric='XTRTotalCash'
UPDATE #Format SET RowOrder=30, Metric='Volume of Sales' WHERE Metric='ExtVolumeOfSales'
UPDATE #Format SET RowOrder=31, Metric='Sales Mix' WHERE Metric='ExtSalesMix'
UPDATE #Format SET RowOrder=32, Metric='Cash per Sale' WHERE Metric='ExtCashPerSale'
UPDATE #Format SET RowOrder=33, Metric='Total Cash' WHERE Metric='ExtTotalCash'
UPDATE #Format SET RowOrder=35, Metric='Volume of Sales' WHERE Metric='PostExtVolumeOfSales'
UPDATE #Format SET RowOrder=36, Metric='Sales Mix' WHERE Metric='PostExtSalesMix'
UPDATE #Format SET RowOrder=37, Metric='Cash per Sale' WHERE Metric='PostExtCashPerSale'
UPDATE #Format SET RowOrder=38, Metric='Total Cash' WHERE Metric='PostExtTotalCash'
UPDATE #Format SET RowOrder=40, Metric='Volume of Sales' WHERE Metric='SurgeryVolumeOfSales'
UPDATE #Format SET RowOrder=41, Metric='Sales Mix' WHERE Metric='SurgerySalesMix'
UPDATE #Format SET RowOrder=42, Metric='Cash per Sale' WHERE Metric='SurgeryCashPerSale'
UPDATE #Format SET RowOrder=43, Metric='Total Cash' WHERE Metric='SurgeryTotalCash'
UPDATE #Format SET RowOrder=45, Metric='Volume of Sales' WHERE Metric='RestorInkVolumeOfSales'
UPDATE #Format SET RowOrder=46, Metric='Sales Mix' WHERE Metric='RestorInkSalesMix'
UPDATE #Format SET RowOrder=47, Metric='Cash per Sale' WHERE Metric='RestorInkCashPerSale'
UPDATE #Format SET RowOrder=48, Metric='Total Cash' WHERE Metric='RestorInkTotalCash'
UPDATE #Format SET RowOrder=50, Metric='Volume of Sales' WHERE Metric='TotalNewCustomerVolumeOfSales'
UPDATE #Format SET RowOrder=51, Metric='Cash per Sale' WHERE Metric='TotalNewCustomerCashPerSale'
UPDATE #Format SET RowOrder=52, Metric='Total Cash' WHERE Metric='TotalNewCustomerTotalCash'
UPDATE #Format SET RowOrder=53, Metric='NewStyleDays', Bold=1 WHERE Metric='NewStyleDays'
UPDATE #Format SET RowOrder=54, RowValue = 1, Metric='NSD to Sales %' WHERE Metric='NSDToSales'
UPDATE #Format SET RowOrder=55, Metric='Conversion-XTR+', Bold=1 WHERE Metric='XTR+Conversions'
UPDATE #Format SET RowOrder=56, RowValue = 1, Metric='XTR+ Convs to NSD %' WHERE Metric='XTR+ConvsToNSD'
UPDATE #Format SET RowOrder=57, Metric='Conversions-XTR', Bold=1 WHERE Metric='XTRConversions'
UPDATE #Format SET RowOrder=58, RowValue = 1, Metric='XTR Convs to Sales %' WHERE Metric='XTRConvsToSales'
UPDATE #Format SET RowOrder=59, Metric='Conversions-EXT', Bold=1 WHERE Metric='ExtConversions'
UPDATE #Format SET RowOrder=60, RowValue = 1, Metric='EXT Convs to Sales %' WHERE Metric='ExtConvsToSales'
UPDATE #Format SET RowOrder=61, Metric='PCP Revenue' WHERE Metric='PCPRevenue'

UPDATE #Format SET Bold = 0 WHERE Bold IS NULL
UPDATE #Format SET RowValue = 0 WHERE RowValue IS NULL

SELECT Metric
,   CurrentMonth
,   OneMonthBack
,   TwoMonthsBack
,   ThreeMonthsBack
,   OneYearBack
,   TwoYearsBack
,   CurrentFiscalYear
,   PriorFiscalYear
,   CurrentMonthBudget
,   CurrentMonthActualToBudget
,   Variance
,   CurrentFiscalYearBudget
,   YTDToBudget
,   Bold
,   RowOrder
,   RowValue
,	@ReportCenters AS 'ReportCenters'
,	DATENAME(MONTH, @CurrentMonthStart) + ' ' + CONVERT(VARCHAR, @Year) AS 'ReportDate'
FROM #Format
WHERE RowOrder>=1
ORDER BY RowOrder


/************ DROP indexes on temp tables *******************************/

DROP INDEX [IDX_tmpCenters] ON #Centers
DROP INDEX [IDX_tmpDates] ON #Dates
DROP INDEX [IDX_tmpData] ON #Data
DROP INDEX [IDX_tmpBudget] ON #Budget
DROP INDEX [IDX_tmpApptShow] ON #TmpApptShow
DROP INDEX [IDX_tmpFinal] ON #Final
DROP INDEX [IDX_tmpSSRS] ON #SSRS
DROP INDEX [IDX_tmpFormat] ON #Format


END
GO
