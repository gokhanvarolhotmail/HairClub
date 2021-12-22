/*
==============================================================================

PROCEDURE:				spRpt_RichMatrix_TEST

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
=============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_RichMatrix_TEST] 4, 2016, 1, 'Corporate'

EXEC [spRpt_RichMatrix_TEST] 1, 2017, 2, '201'

EXEC [spRpt_RichMatrix_TEST] 2, 2016, 3, '4'

EXEC [spRpt_RichMatrix_TEST] 1, 2017, 1, 'Corporate'

==============================================================================
*/
CREATE PROCEDURE [dbo].spRpt_RichMatrix_TEST (
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
,	Sales INT
,	GWPVolumeOfSales INT
,	GWPTotalCash MONEY
,	GVolumeOfSales INT
,	GTotalCash MONEY
,	XTRVolumeOfSales INT
,	XTRTotalCash MONEY
,	ExtVolumeOfSales INT
,	ExtTotalCash MONEY
,	PostExtVolumeOfSales INT
,	PostExtTotalCash MONEY
,	SurgeryVolumeOfSales INT
,	SurgeryTotalCash MONEY
,	TotalNewCustomerVolumeOfSales INT
,	TotalNewCustomerTotalCash MONEY
,	GWPGradVolumeOfSales INT
,	NewStyleDays INT
,	Conversions INT
,	[Service] MONEY
,	PcpClients INT
,	[XTR+Conversions] INT
,	XTRConversions INT
,	ExtConversions INT
,	PCP_NB2Amt MONEY
)


CREATE TABLE #TmpApptShow(
	DateDesc VARCHAR(50)
,	Appointments INT
,	Consultation INT )

CREATE TABLE #Final (
	DateDesc VARCHAR(50)
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales INT
,	SalesToLeads NUMERIC(20, 5)
,	ConsultsToAppointments NUMERIC(20, 5)
,	SalesToConsultations NUMERIC(20, 5)
,	GWPVolumeOfSales INT
,	GWPTotalCash MONEY
,	GWPCashPerSale NUMERIC(20, 5)
,	GVolumeOfSales INT
,	GTotalCash MONEY
,	GCashPerSale NUMERIC(20, 5)
,	XTRVolumeOfSales INT
,	XTRTotalCash MONEY
,	XTRCashPerSale NUMERIC(20, 5)
,	ExtVolumeOfSales INT
,	ExtTotalCash MONEY
,	ExtCashPerSale NUMERIC(20, 5)
,	PostExtVolumeOfSales INT
,	PostExtTotalCash MONEY
,	PostExtCashPerSale NUMERIC(20, 5)
,	SurgeryVolumeOfSales INT
,	SurgeryTotalCash MONEY
,	SurgeryCashPerSale NUMERIC(20, 5)
,	TotalNewCustomerVolumeOfSales INT
,	TotalNewCustomerTotalCash MONEY
,	TotalNewCustomerCashPerSale NUMERIC(20, 5)
,	NewStyleDays INT
,	NSDToSales NUMERIC(20, 5)
,	Conversions INT
,	ConvsToNSD NUMERIC(20, 5)
,	[Service] MONEY
,	PcpClients INT
,	[XTR+Conversions] INT
,	XTRConversions INT
,	ExtConversions INT
,	[XTR+ConvsToNSD] NUMERIC(20, 5)
,	XTRConvsToSales NUMERIC(20, 5)
,	ExtConvsToSales NUMERIC(20, 5)
,	PCP_NB2Amt MONEY
)

CREATE TABLE #Centers (
	CenterID INT
)

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


IF @ReportType=1
	BEGIN
		INSERT INTO #Centers
		SELECT c.CenterSSID
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				ON c.RegionSSID = r.RegionSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
				ON c.CenterTypeKey = t.CenterTypeKey
		WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%'
			AND t.CenterTypeDescription IN (RTRIM(@Filter1), RTRIM(@Filter2))
		AND c.Active = 'Y'
	END
ELSE IF @ReportType=2
	BEGIN
		INSERT INTO #Centers
		SELECT c.CenterSSID
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				ON c.RegionSSID = r.RegionSSID
		WHERE CONVERT(VARCHAR, c.CenterSSID) = @Filter
		--AND c.Active = 'Y'
	END
ELSE IF @ReportType=3
	BEGIN
		INSERT INTO #Centers
		SELECT c.CenterSSID
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				ON c.RegionSSID = r.RegionSSID
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
		WHERE CenterSSID IN (
			SELECT CenterID
			FROM #Centers
		)
	END

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
--SET @PriorFiscalYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @PriorFiscalYearStart))
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


/* Get Actual Data */
INSERT INTO #Data (
	DateDesc
,	Sales
,	GWPVolumeOfSales
,	GWPTotalCash
,	GVolumeOfSales
,	GTotalCash
,	XTRVolumeOfSales
,	XTRTotalCash
,	ExtVolumeOfSales
,	ExtTotalCash
,	PostExtVolumeOfSales
,	PostExtTotalCash
,	SurgeryVolumeOfSales
,	SurgeryTotalCash
,	TotalNewCustomerVolumeOfSales
,	TotalNewCustomerTotalCash
,	GWPGradVolumeOfSales
,	NewStyleDays
,	Conversions
,	[Service]
,	[XTR+Conversions]
,	XTRConversions
,	ExtConversions
,	PCP_NB2Amt
)
SELECT #Dates.DateDesc
,	SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRCnt, 0)) --Added RH 12/1/2014
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0))
	AS 'Sales'
,	SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'GWPVolumeOfSales'
,	SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'GWPTotalCash'
,	SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'GVolumeOfSales'
,	SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'GTotalCash'
	,	SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'XTRVolumeOfSales'
,	SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'XTRTotalCash'
,	SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'EXTVolumeOfSales'
,	SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'EXTTotalCash'
,	SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostExtVolumeOfSales'
,	SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostExtTotalCash'
,	SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgeryVolumeOfSales'
,	SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgeryTotalCash'
,	SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_GradCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRCnt, 0))
		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
		+ SUM(ISNULL(FST.S_PostExtCnt, 0))
		+ SUM(ISNULL(FST.S_SurCnt, 0))
	AS 'TotalNewCustomerVolumeOfSales'
,	SUM(ISNULL(FST.NB_TradAmt, 0))
		+ SUM(ISNULL(FST.NB_GradAmt, 0))
		+ SUM(ISNULL(FST.NB_XTRAmt, 0))
		+ SUM(ISNULL(FST.NB_ExtAmt, 0))
		+ SUM(ISNULL(FST.S_PostExtAmt, 0))
		+ SUM(ISNULL(FST.S_SurAmt, 0))
	AS 'TotalNewCustomerTotalCash'
,	SUM(ISNULL(FST.NB_TradCnt, 0))
		+ SUM(ISNULL(FST.NB_GradCnt, 0))
	AS 'GWPGradVolumeOfSales'
,	SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NewStyleDays'
,	SUM(ISNULL(FST.NB_BIOConvCnt, 0))
		+ SUM(ISNULL(FST.NB_EXTConvCnt, 0))
		+ SUM(ISNULL(FST.NB_XTRConvCnt, 0))
	AS 'Conversions'
,	SUM(ISNULL(FST.ServiceAmt, 0)) AS 'Service'
,	SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'XTR+Conversions'
,	SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'XTRConversions'
,	SUM(ISNULL(FST.NB_EXTConvCnt, 0)) AS 'EXTConversions'
,   SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'PCP_NB2Amt'  --Includes Non-Program
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON FST.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		--ON FST.CenterKey = c.CenterKey
		ON CM.CenterKey = C.CenterKey						--KEEP Home center based	06/24/2015	RH
	INNER JOIN #Centers
		ON C.ReportingCenterSSID = #Centers.CenterID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
WHERE #Dates.DateID NOT IN (9, 10)
	AND SC.SalesCodeSSID NOT IN (686, 399, 713, 714)
GROUP BY #Dates.DateDesc



/* Get Actual Appointments and Shows Data */



INSERT INTO #TmpApptShow
SELECT #Dates.DateDesc
,	SUM(ISNULL(FAR.Appointments, 0)) as 'Appointments'
,	NULL AS 'Consultation'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR  --Changed RH 06/09/2015
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FAR.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FAR.ActivityDueDateKey = DD.datekey
	INNER JOIN #Centers
		ON CTR.CenterSSID = #Centers.CenterID
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
WHERE CTR.Active = 'Y'
	AND #Dates.DateID NOT IN (9, 10)
	AND ResultCodeKey <> -1
GROUP BY #Dates.DateDesc

INSERT INTO #TmpApptShow
SELECT #Dates.DateDesc
,	NULL AS 'Appointments'
,	SUM(ISNULL(FAR.Consultation, 0)) as 'Consultation'
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR  --Changed RH 06/09/2015
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FAR.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FAR.ActivityDueDateKey = DD.datekey
	INNER JOIN #Centers
		ON CTR.CenterSSID = #Centers.CenterID
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
WHERE CTR.Active = 'Y'
	AND #Dates.DateID NOT IN (9, 10)
	AND ResultCodeKey <> -1
	AND FAR.BeBack <> 1
	AND FAR.Show=1
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
		ON CTR.CenterSSID = #Centers.CenterID
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
WHERE CTR.Active = 'Y'
	AND #Dates.DateID NOT IN (9, 10)
GROUP BY #Dates.DateDesc


/* Get Actual PCP Data */


SELECT	#Dates.DateDesc
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10410 ) THEN a.Flash ELSE 0 END, 0)) AS 'PcpClients'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10410 ) THEN a.Budget ELSE 0 END, 0)) AS 'PcpClients_Budget'
INTO #TmpPCP
FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON a.[CenterID] = CTR.CenterSSID
	INNER JOIN #Dates
		ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN #Centers
		ON a.CenterID = #Centers.CenterID
WHERE #Dates.DateID NOT IN (9, 10)
	AND a.AccountID=10410
GROUP BY #Dates.DateDesc


	--Request of 6/22/2015 WO#115208 - Change Active PCP Clients for CurrentFiscalYear to be the counts for the prior month

	UPDATE  tmp1
	SET tmp1.PCPClients = tmp2.PCPClients, tmp1.PcpClients_Budget = tmp2.PcpClients_Budget
	FROM #TmpPCP tmp1, #TmpPCP tmp2
	WHERE tmp2.DateDesc = 'OneMonthBack'
	AND tmp1.DateDesc = 'CurrentFiscalYear'

	--Request of 6/22/2015 WO#115208 - Change Active PCP Clients for PriorFiscalYear to be the counts for OneYearBack

	UPDATE  tmp1
	SET tmp1.PCPClients = tmp2.PCPClients
	FROM #TmpPCP tmp1, #TmpPCP tmp2
	WHERE tmp2.DateDesc = 'OneYearBack'
	AND tmp1.DateDesc = 'PriorFiscalYear'

	INSERT INTO #TmpPCP --Request of 6/22/2015 WO#115208 - Change PCP Clients budget for CurrentFiscalYearBudget to be the counts for Budget One Month Back
	(DateDesc,
	PcpClients,
	PcpClients_Budget)
	SELECT	'CurrentFiscalYearBudget' AS DateDesc
	,	PcpClients_Budget AS PcpClients
	,	0 AS PcpClients_Budget
	FROM #TmpPCP
	WHERE DateDesc = 'OneMonthBack'

	INSERT INTO #TmpPCP --Request of 6/22/2015 WO#115208 - Change PCP Clients budget for CurrentFiscalYearBudget to be the counts for Budget One Month Back
	(DateDesc,
	PcpClients,
	PcpClients_Budget)
	SELECT 	'CurrentMonthBudget' AS DateDesc
	,	PcpClients_Budget AS PcpClients
	,	0 AS PcpClients_Budget
	FROM #TmpPCP
	WHERE DateDesc = 'CurrentMonth'


/* UPDATE Appointments and Shows values in temp table */
UPDATE d
SET d.Appointments = t.Appointments
,	d.Shows = t.Consultation
FROM #Data d
	LEFT OUTER JOIN #TmpApptShow t
		ON d.DateDesc = t.DateDesc


/* UPDATE Leads values in temp table */
UPDATE d
SET d.Leads = t.Leads
FROM #Data d
	LEFT OUTER JOIN #TmpLead t
		ON d.DateDesc = t.DateDesc


/* UPDATE PCP values in temp table */
UPDATE d
SET d.PcpClients = t.PcpClients
FROM #Data d
	LEFT OUTER JOIN #TmpPCP t
		ON d.DateDesc = t.DateDesc


--/* Get Budget Data */
INSERT INTO #Data
SELECT #Dates.DateDesc
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10155 ) THEN a.Budget ELSE 0 END, 0)) AS 'LeadsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10100 ) THEN a.Budget ELSE 0 END, 0)) AS 'AppointmentsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10110 ) THEN a.Budget ELSE 0 END, 0)) AS 'ShowsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205, 10206, 10210, 10215, 10220, 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'SalesBudget'  --Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205 ) THEN a.Budget ELSE 0 END, 0)) AS 'GWPVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10305 ) THEN a.Budget ELSE 0 END, 0)) AS 'GWPTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10210 ) THEN a.Budget ELSE 0 END, 0)) AS 'GVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10310 ) THEN a.Budget ELSE 0 END, 0)) AS 'GTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10206 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRVolumeOfSalesBudget'	--Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10306 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRTotalCashBudget'		--Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10215 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10315 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'PostExtVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10325 ) THEN a.Budget ELSE 0 END, 0)) AS 'PostExtTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10220 ) THEN a.Budget ELSE 0 END, 0)) AS 'SurgeryVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10320 ) THEN a.Budget ELSE 0 END, 0)) AS 'SurgeryTotalCashBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205, 10206, 10210, 10215, 10220, 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'TotalNewCustomerVolumeOfSalesBudget'  --Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10305, 10306, 10310, 10315, 10320, 10325 ) THEN a.Budget ELSE 0 END, 0)) AS 'TotalNewCustomerTotalCashBudget'		--Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205, 10210 ) THEN a.Budget ELSE 0 END, 0)) AS 'GWPGradVolumeOfSalesBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10240 ) THEN a.Budget ELSE 0 END, 0)) AS 'NewStyleDaysBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10440 ) THEN a.Budget ELSE 0 END, 0)) AS 'ConversionsBudget'
--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 3080 ) THEN ABS(a.Budget) ELSE 0 END, 0)) AS 'ServiceBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10575 ) THEN ABS(a.Budget) ELSE 0 END, 0)) AS 'ServiceBudget'  --Changed 06/09/2015 RH

--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10410 ) THEN a.Budget ELSE 0 END, 0)) AS 'PcpClientsBudget'
,	NULL AS PCPClientsBudget
--,	SUM(ISNULL(tmp.PcpClients,0))  AS 'PcpClientsBudget' --Request of 6/22/2015 WO#115208 - Change PCP Clients budget for CurrentFiscalYearBudget to be the counts for Budget One Month Back

,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10430 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTR+ConversionsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10433 ) THEN a.Budget ELSE 0 END, 0)) AS 'XTRConversionsBudget'  --Added Xtr RH 1/13/2015
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10435 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtConversionsBudget'
,	SUM(ISNULL(CASE WHEN a.[AccountID] IN (10530) THEN a.Budget ELSE 0 END, 0)) AS 'PCP_NB2AmtBudget'
FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON a.[CenterID] = CTR.CenterSSID
	INNER JOIN #Dates
		ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN #Centers
		ON a.CenterID = #Centers.CenterID
WHERE #Dates.DateID IN (9, 10)
GROUP BY #Dates.DateDesc



--SELECT * FROM #Data

INSERT INTO #Final (
	DateDesc
,	Leads
,	Appointments
,	Shows
,	Sales
,	SalesToLeads
,	ConsultsToAppointments
,	SalesToConsultations
,	GWPVolumeOfSales
,	GWPTotalCash
,	GWPCashPerSale
,	GVolumeOfSales
,	GTotalCash
,	GCashPerSale
,	XTRVolumeOfSales
,	XTRTotalCash
,	XTRCashPerSale
,	ExtVolumeOfSales
,	ExtTotalCash
,	ExtCashPerSale
,	PostExtVolumeOfSales
,	PostExtTotalCash
,	PostExtCashPerSale
,	SurgeryVolumeOfSales
,	SurgeryTotalCash
,	SurgeryCashPerSale
,	TotalNewCustomerVolumeOfSales
,	TotalNewCustomerTotalCash
,	TotalNewCustomerCashPerSale
,	NewStyleDays
,	NSDToSales
,	Conversions
,	ConvsToNSD
,	[Service]
,	PcpClients
,	[XTR+Conversions]
,	XTRConversions
,	ExtConversions
,	[XTR+ConvsToNSD]
,	XTRConvsToSales
,	ExtConvsToSales
,	PCP_NB2Amt)
SELECT d.DateDesc
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Leads ELSE d.Leads * @CurrentToTotal END AS 'Leads'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Appointments ELSE d.Appointments * @CummToMonth END AS 'Appointments'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Shows ELSE d.Shows * @CummToMonth END AS 'Shows'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Sales ELSE d.Sales * @CummToMonth END AS 'Sales'
,	dbo.DIVIDE_DECIMAL(d.Sales, d.Leads) AS 'SalesToLeads'
,	dbo.DIVIDE_DECIMAL(d.Shows, d.Appointments) AS 'ConsultsToAppointments'
,	dbo.DIVIDE_DECIMAL(d.Sales, d.Shows) AS 'SalesToConsultations'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.GWPVolumeOfSales ELSE d.GWPVolumeOfSales * @CummToMonth END AS 'GWPVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.GWPTotalCash ELSE d.GWPTotalCash * @CummToMonth END AS 'GWPTotalCash'
,	dbo.DIVIDE_DECIMAL(d.GWPTotalCash, d.GWPVolumeOfSales) AS 'GWPCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.GVolumeOfSales ELSE d.GVolumeOfSales * @CummToMonth END AS 'GVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.GTotalCash ELSE d.GTotalCash * @CummToMonth END AS 'GTotalCash'
,	dbo.DIVIDE_DECIMAL(d.GTotalCash, d.GVolumeOfSales) AS 'GCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.XTRVolumeOfSales ELSE d.XTRVolumeOfSales * @CummToMonth END AS 'XTRVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.XTRTotalCash ELSE d.XTRTotalCash * @CummToMonth END AS 'XTRTotalCash'
,	dbo.DIVIDE_DECIMAL(d.XTRTotalCash, d.XTRVolumeOfSales) AS 'XTRCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.ExtVolumeOfSales ELSE d.ExtVolumeOfSales * @CummToMonth END AS 'ExtVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.ExtTotalCash ELSE d.ExtTotalCash * @CummToMonth END AS 'ExtTotalCash'
,	dbo.DIVIDE_DECIMAL(d.ExtTotalCash, d.ExtVolumeOfSales) AS 'ExtCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.PostExtVolumeOfSales ELSE d.PostExtVolumeOfSales * @CummToMonth END AS 'PostExtVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.PostExtTotalCash ELSE d.PostExtTotalCash * @CummToMonth END AS 'PostExtTotalCash'
,	dbo.DIVIDE_DECIMAL(d.PostExtTotalCash, d.PostExtVolumeOfSales) AS 'PostExtCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.SurgeryVolumeOfSales ELSE d.SurgeryVolumeOfSales * @CummToMonth END AS 'SurgeryVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.SurgeryTotalCash ELSE d.SurgeryTotalCash * @CummToMonth END AS 'SurgeryTotalCash'
,	dbo.DIVIDE_DECIMAL(d.SurgeryTotalCash, d.SurgeryVolumeOfSales) AS 'SurgeryCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.TotalNewCustomerVolumeOfSales ELSE d.TotalNewCustomerVolumeOfSales * @CummToMonth END AS 'TotalNewCustomerVolumeOfSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.TotalNewCustomerTotalCash ELSE d.TotalNewCustomerTotalCash * @CummToMonth END AS 'TotalNewCustomerTotalCash'
,	dbo.DIVIDE_DECIMAL(d.TotalNewCustomerTotalCash, d.TotalNewCustomerVolumeOfSales) AS 'TotalNewCustomerCashPerSale'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.NewStyleDays ELSE d.NewStyleDays * @CummToMonth END AS 'NewStyleDays'
,	dbo.DIVIDE_DECIMAL(d.NewStyleDays, d.GWPGradVolumeOfSales) AS 'NSDToSales'
,	d.Conversions
,	dbo.DIVIDE_DECIMAL(d.Conversions, d.NewStyleDays) AS 'ConvsToNSD'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.[Service] ELSE d.[Service] * @CummToMonth END AS 'Service'
,	d.PcpClients
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.[XTR+Conversions] ELSE d.[XTR+Conversions] * @CummToMonth END AS 'XTR+Conversions'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.XTRConversions ELSE d.XTRConversions * @CummToMonth END AS 'XTRConversions'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.ExtConversions ELSE d.ExtConversions * @CummToMonth END AS 'ExtConversions'
,	dbo.DIVIDE_DECIMAL(d.[XTR+Conversions], d.NewStyleDays) AS 'XTR+ConvsToNSD'
,	dbo.DIVIDE_DECIMAL(d.XTRConversions, d.XTRVolumeOfSales) AS 'XTRConvsToSales'
,	dbo.DIVIDE_DECIMAL(d.ExtConversions, d.ExtVolumeOfSales) AS 'ExtConvsToSales'
,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.PCP_NB2Amt ELSE d.PCP_NB2Amt * @CummToMonth END AS 'PCP_NB2Amt'
FROM #Data d


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
	,	CONVERT(VARCHAR(50), [GWPVolumeOfSales]) AS [GWPVolumeOfSales]
	,	CONVERT(VARCHAR(50), [GWPTotalCash]) AS [GWPTotalCash]
	,	CONVERT(VARCHAR(50), [GWPCashPerSale]) AS [GWPCashPerSale]
	,	CONVERT(VARCHAR(50), [GVolumeOfSales]) AS [GVolumeOfSales]
	,	CONVERT(VARCHAR(50), [GTotalCash]) AS [GTotalCash]
	,	CONVERT(VARCHAR(50), [GCashPerSale]) AS [GCashPerSale]
	,	CONVERT(VARCHAR(50), [XTRVolumeOfSales]) AS [XTRVolumeOfSales]
	,	CONVERT(VARCHAR(50), [XTRTotalCash]) AS [XTRTotalCash]
	,	CONVERT(VARCHAR(50), [XTRCashPerSale]) AS [XTRCashPerSale]
	,	CONVERT(VARCHAR(50), [ExtVolumeOfSales]) AS [ExtVolumeOfSales]
	,	CONVERT(VARCHAR(50), [ExtTotalCash]) AS [ExtTotalCash]
	,	CONVERT(VARCHAR(50), [ExtCashPerSale]) AS [ExtCashPerSale]
	,	CONVERT(VARCHAR(50), [PostExtVolumeOfSales]) AS [PostExtVolumeOfSales]
	,	CONVERT(VARCHAR(50), [PostExtTotalCash]) AS [PostExtTotalCash]
	,	CONVERT(VARCHAR(50), [PostExtCashPerSale]) AS [PostExtCashPerSale]
	,	CONVERT(VARCHAR(50), [SurgeryVolumeOfSales]) AS [SurgeryVolumeOfSales]
	,	CONVERT(VARCHAR(50), [SurgeryTotalCash]) AS [SurgeryTotalCash]
	,	CONVERT(VARCHAR(50), [SurgeryCashPerSale]) AS [SurgeryCashPerSale]
	,	CONVERT(VARCHAR(50), [TotalNewCustomerVolumeOfSales]) AS [TotalNewCustomerVolumeOfSales]
	,	CONVERT(VARCHAR(50), [TotalNewCustomerTotalCash]) AS [TotalNewCustomerTotalCash]
	,	CONVERT(VARCHAR(50), [TotalNewCustomerCashPerSale]) AS [TotalNewCustomerCashPerSale]
	,	CONVERT(VARCHAR(50), [NewStyleDays]) AS [NewStyleDays]
	,	CONVERT(VARCHAR(50), [NSDToSales]) AS [NSDToSales]
	,	CONVERT(VARCHAR(50), [Conversions]) AS [Conversions]
	,	CONVERT(VARCHAR(50), [ConvsToNSD]) AS [ConvsToNSD]
	,	CONVERT(VARCHAR(50), [Service]) AS [Service]
	,	CONVERT(VARCHAR(50), [PcpClients]) AS [PcpClients]
	,	CONVERT(VARCHAR(50), [XTR+Conversions]) AS [XTR+Conversions]
	,	CONVERT(VARCHAR(50), [XTRConversions]) AS [XTRConversions]
	,	CONVERT(VARCHAR(50), [ExtConversions]) AS [ExtConversions]
	,	CONVERT(VARCHAR(50), [XTR+ConvsToNSD]) AS [XTR+ConvsToNSD]
	,	CONVERT(VARCHAR(50), [XTRConvsToSales]) AS [XTRConvsToSales]
	,	CONVERT(VARCHAR(50), [ExtConvsToSales]) AS [ExtConvsToSales]
	,	CONVERT(VARCHAR(50), [PCP_NB2Amt]) AS [PCP_NB2Amt]
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
	,	GWPVolumeOfSales
	,	GWPTotalCash
	,	GWPCashPerSale
	,	GVolumeOfSales
	,	GTotalCash
	,	GCashPerSale
	,	XTRVolumeOfSales
	,	XTRTotalCash
	,	XTRCashPerSale
	,	ExtVolumeOfSales
	,	ExtTotalCash
	,	ExtCashPerSale
	,	PostExtVolumeOfSales
	,	PostExtTotalCash
	,	PostExtCashPerSale
	,	SurgeryVolumeOfSales
	,	SurgeryTotalCash
	,	SurgeryCashPerSale
	,	TotalNewCustomerVolumeOfSales
	,	TotalNewCustomerTotalCash
	,	TotalNewCustomerCashPerSale
	,	NewStyleDays
	,	NSDToSales
	,	Conversions
	,	ConvsToNSD
	,	[Service]
	,	PcpClients
	,	[XTR+Conversions]
	,	XTRConversions
	,	ExtConversions
	,	[XTR+ConvsToNSD]
	,	XTRConvsToSales
	,	ExtConvsToSales
	,	PCP_NB2Amt
	)
) AS UnPVT


UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='Leads'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='Appointments'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='Shows'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='Sales'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='SalesToLeads'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='ConsultsToAppointments'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='SalesToConsultations'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='GWPVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='GWPTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='GWPCashPerSale'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='GVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='GTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='GCashPerSale'
	UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='XTRVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='XTRTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='XTRCashPerSale'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='ExtVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='ExtTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='ExtCashPerSale'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='PostExtVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='PostExtTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='PostExtCashPerSale'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='SurgeryVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='SurgeryTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='SurgeryCashPerSale'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='TotalNewCustomerVolumeOfSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='TotalNewCustomerTotalCash'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='TotalNewCustomerCashPerSale'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='NewStyleDays'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='NSDToSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='Service'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='PcpClients'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='XTR+Conversions'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='XTRConversions'
UPDATE #Unpivot SET Value=dbo.fxNumberToString(Value) WHERE Metric='ExtConversions'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='XTR+ConvsToNSD'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='XTRConvsToSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToPercentString(Value) WHERE Metric='ExtConvsToSales'
UPDATE #Unpivot SET Value=dbo.fxNumberToMoneySting(Value) WHERE Metric='PCP_NB2Amt'


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
,	0 AS 'Bold'
,	0 AS 'RowOrder'
,	0 AS 'RowValue'
INTO #SSRS
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
	)
) AS PVT


UPDATE #SSRS
SET Bold=1
WHERE [Metric] IN (
	'SalesToConsultations'
,	'PcpClients'
,	'PCP_NB2Amt'
)


INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('', 0, 8, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('GWP', 1, 9, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('Gradual', 1, 13, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('Xtrands', 1, 17, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('EXT', 1, 21, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('Post EXT', 1, 25, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('Surgery', 1, 29, 1)
INSERT INTO #SSRS (Metric, Bold, RowOrder, RowValue) VALUES ('Total New Customer', 1, 33, 1)


UPDATE #SSRS SET RowOrder=1, Metric='Leads' WHERE Metric='Leads'
UPDATE #SSRS SET RowOrder=2, Metric='Appointments' WHERE Metric='Appointments'
UPDATE #SSRS SET RowOrder=3, Metric='Consultations' WHERE Metric='Shows'
UPDATE #SSRS SET RowOrder=4, Metric='Sales' WHERE Metric='Sales'
UPDATE #SSRS SET RowOrder=5, RowValue = 1, Metric='Sales to Leads %' WHERE Metric='SalesToLeads'
UPDATE #SSRS SET RowOrder=6, RowValue = 1, Metric='Consults to Appointments %' WHERE Metric='ConsultsToAppointments'
UPDATE #SSRS SET RowOrder=7, RowValue = 1, Metric='Sales to Consultations' WHERE Metric='SalesToConsultations'

UPDATE #SSRS SET RowOrder=10, Metric='Volume of Sales' WHERE Metric='GWPVolumeOfSales'
UPDATE #SSRS SET RowOrder=11, Metric='Cash per Sale' WHERE Metric='GWPCashPerSale'
UPDATE #SSRS SET RowOrder=12, Metric='Total Cash' WHERE Metric='GWPTotalCash'

UPDATE #SSRS SET RowOrder=14, Metric='Volume of Sales' WHERE Metric='GVolumeOfSales'
UPDATE #SSRS SET RowOrder=15, Metric='Cash per Sale' WHERE Metric='GCashPerSale'
UPDATE #SSRS SET RowOrder=16, Metric='Total Cash' WHERE Metric='GTotalCash'

UPDATE #SSRS SET RowOrder=18, Metric='Volume of Sales' WHERE Metric='XTRVolumeOfSales' --Added RH 12/1/2014
UPDATE #SSRS SET RowOrder=19, Metric='Cash per Sale' WHERE Metric='XTRCashPerSale'
UPDATE #SSRS SET RowOrder=20, Metric='Total Cash' WHERE Metric='XTRTotalCash'

UPDATE #SSRS SET RowOrder=22, Metric='Volume of Sales' WHERE Metric='ExtVolumeOfSales'
UPDATE #SSRS SET RowOrder=23, Metric='Cash per Sale' WHERE Metric='ExtCashPerSale'
UPDATE #SSRS SET RowOrder=24, Metric='Total Cash' WHERE Metric='ExtTotalCash'

UPDATE #SSRS SET RowOrder=26, Metric='Volume of Sales' WHERE Metric='PostExtVolumeOfSales'
UPDATE #SSRS SET RowOrder=27, Metric='Cash per Sale' WHERE Metric='PostExtCashPerSale'
UPDATE #SSRS SET RowOrder=28, Metric='Total Cash' WHERE Metric='PostExtTotalCash'

UPDATE #SSRS SET RowOrder=30, Metric='Volume of Sales' WHERE Metric='SurgeryVolumeOfSales'
UPDATE #SSRS SET RowOrder=31, Metric='Cash per Sale' WHERE Metric='SurgeryCashPerSale'
UPDATE #SSRS SET RowOrder=32, Metric='Total Cash' WHERE Metric='SurgeryTotalCash'

UPDATE #SSRS SET RowOrder=34, Metric='Volume of Sales' WHERE Metric='TotalNewCustomerVolumeOfSales'
UPDATE #SSRS SET RowOrder=35, Metric='Cash per Sale' WHERE Metric='TotalNewCustomerCashPerSale'
UPDATE #SSRS SET RowOrder=36, Metric='Total Cash' WHERE Metric='TotalNewCustomerTotalCash'
UPDATE #SSRS SET RowOrder=37, Metric='NewStyleDays', Bold=1 WHERE Metric='NewStyleDays'
UPDATE #SSRS SET RowOrder=38, RowValue = 1, Metric='NSD to Sales %' WHERE Metric='NSDToSales'
UPDATE #SSRS SET RowOrder=39, Metric='Conversion-XTR+', Bold=1 WHERE Metric='XTR+Conversions'
UPDATE #SSRS SET RowOrder=40, RowValue = 1, Metric='XTR+ Convs to NSD %' WHERE Metric='XTR+ConvsToNSD'
UPDATE #SSRS SET RowOrder=41, Metric='Conversions-XTR', Bold=1 WHERE Metric='XTRConversions' --Added RH 12/1/2014
UPDATE #SSRS SET RowOrder=42, RowValue = 1, Metric='XTR Convs to Sales %' WHERE Metric='XTRConvsToSales'
UPDATE #SSRS SET RowOrder=43, Metric='Conversions-EXT', Bold=1 WHERE Metric='ExtConversions'
UPDATE #SSRS SET RowOrder=44, RowValue = 1, Metric='EXT Convs to Sales %' WHERE Metric='ExtConvsToSales'
UPDATE #SSRS SET RowOrder=45, Metric='PCP & Non Pgm' WHERE Metric='PCP_NB2Amt'
UPDATE #SSRS SET RowOrder=46, Metric='Service', Bold=1 WHERE Metric='Service'
UPDATE #SSRS SET RowOrder=47, Metric='Active PCP Clients' WHERE Metric='PcpClients'


--Update Current Fiscal Year Budget and Current Month Budget for ActivePCP
UPDATE #SSRS
SET #SSRS.CurrentFiscalYearBudget = FORMAT(tmp.PCPClients, '#,#')
FROM #TmpPCP tmp
WHERE #SSRS.Metric = 'Active PCP Clients'
	AND tmp.DateDesc = 'CurrentFiscalYearBudget'

UPDATE #SSRS
SET #SSRS.CurrentMonthBudget = FORMAT(tmp.PCPClients, '#,#')
FROM #TmpPCP tmp
WHERE #SSRS.Metric = 'Active PCP Clients'
	AND tmp.DateDesc = 'CurrentMonthBudget'


SELECT *
,	@ReportCenters AS 'ReportCenters'
,	DATENAME(MONTH, @CurrentMonthStart) + ' ' + CONVERT(VARCHAR, @Year) AS 'ReportDate'

FROM #SSRS
WHERE RowOrder>=1
ORDER BY RowOrder



END
