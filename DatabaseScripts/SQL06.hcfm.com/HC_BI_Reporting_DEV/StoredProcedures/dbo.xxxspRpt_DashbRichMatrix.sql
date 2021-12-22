/*
==============================================================================

PROCEDURE:				spRpt_DashbRichMatrix

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		01/06/2015

==============================================================================
DESCRIPTION:	Dashboard for the Rich Matrix Report
==============================================================================
NOTES:	This report changes according to the day it is run if it is run in the current month.  It
calculates the portion of the current month and adjusts all of the totals accordingly. (@CummWorkdays / @MonthWorkdays)
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_DashbRichMatrix] 'C',201,'12/1/2014','12/31/2014'


==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxspRpt_DashbRichMatrix] (
@CenterType CHAR(1)
,	@CenterSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @Month INT
	,	@Year INT
	,	@TempDate DATETIME

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
	--,	TVolumeOfSales INT
	--,	TTotalCash MONEY
	--,	GVolumeOfSales INT
	--,	GTotalCash MONEY
	--,	XTRVolumeOfSales INT
	--,	XTRTotalCash MONEY
	--,	ExtVolumeOfSales INT
	--,	ExtTotalCash MONEY
	--,	PostExtVolumeOfSales INT
	--,	PostExtTotalCash MONEY
	--,	SurgeryVolumeOfSales INT
	--,	SurgeryTotalCash MONEY
	--,	TotalNewCustomerVolumeOfSales INT
	--,	TotalNewCustomerTotalCash MONEY
	--,	TradGradVolumeOfSales INT
	,	Applications INT
	,	Conversions INT
	,	[Service] MONEY
	,	PcpClients INT
	,	BioConversions INT
	,	XTRConversions INT
	,	ExtConversions INT
	)

	CREATE TABLE #Final (
		DateDesc VARCHAR(50)
	,	DateOrder INT
	,	Leads INT
	,	Appointments INT
	,	Shows INT
	,	Sales INT
	,	SalesToLeads NUMERIC(20, 5)
	,	ConsultsToAppointments NUMERIC(20, 5)
	,	SalesToConsultations NUMERIC(20, 5)
	--,	TVolumeOfSales INT
	--,	TTotalCash MONEY
	--,	TCashPerSale NUMERIC(20, 5)
	--,	GVolumeOfSales INT
	--,	GTotalCash MONEY
	--,	GCashPerSale NUMERIC(20, 5)
	--	,	XTRVolumeOfSales INT
	--,	XTRTotalCash MONEY
	--,	XTRCashPerSale NUMERIC(20, 5)
	--,	ExtVolumeOfSales INT
	--,	ExtTotalCash MONEY
	--,	ExtCashPerSale NUMERIC(20, 5)
	--,	PostExtVolumeOfSales INT
	--,	PostExtTotalCash MONEY
	--,	PostExtCashPerSale NUMERIC(20, 5)
	--,	SurgeryVolumeOfSales INT
	--,	SurgeryTotalCash MONEY
	--,	SurgeryCashPerSale NUMERIC(20, 5)
	--,	TotalNewCustomerVolumeOfSales INT
	--,	TotalNewCustomerTotalCash MONEY
	--,	TotalNewCustomerCashPerSale NUMERIC(20, 5)
	,	Applications INT
	--,	AppsToSales NUMERIC(20, 5)
	,	Conversions INT
	,	ConvsToApps NUMERIC(20, 5)
	,	[Service] MONEY
	,	PcpClients INT
	,	BioConversions INT
	,	XTRConversions INT
	,	ExtConversions INT
	,	BioConvsToApps NUMERIC(20, 5)
	--,	XTRConvsToSales NUMERIC(20, 5)
	--,	ExtConvsToSales NUMERIC(20, 5)
	)

	CREATE TABLE #Centers (
		CenterSSID INT
	)

	INSERT INTO #Centers
	SELECT CenterSSID
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	WHERE CenterSSID LIKE CASE WHEN @CenterType = 'C' THEN '[2]%' ELSE '[78]%' END
	AND DC.Active = 'Y'


	SET @Month = MONTH(@StartDate)
	SET @Year = YEAR(@StartDate)
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
	--,	TVolumeOfSales
	--,	TTotalCash
	--,	GVolumeOfSales
	--,	GTotalCash
	--,	XTRVolumeOfSales
	--,	XTRTotalCash
	--,	ExtVolumeOfSales
	--,	ExtTotalCash
	--,	PostExtVolumeOfSales
	--,	PostExtTotalCash
	--,	SurgeryVolumeOfSales
	--,	SurgeryTotalCash
	--,	TotalNewCustomerVolumeOfSales
	--,	TotalNewCustomerTotalCash
	--,	TradGradVolumeOfSales
	,	Applications
	,	Conversions
	,	[Service]
	,	BioConversions
	,	XTRConversions
	,	ExtConversions
	)
	SELECT #Dates.DateDesc
	,	SUM(ISNULL(FST.NB_TradCnt, 0))
			+ SUM(ISNULL(FST.NB_GradCnt, 0))
			+ SUM(ISNULL(FST.NB_XTRCnt, 0)) --Added RH 12/1/2014
			+ SUM(ISNULL(FST.NB_ExtCnt, 0))
			+ SUM(ISNULL(FST.S_PostExtCnt, 0))
			+ SUM(ISNULL(FST.S_SurCnt, 0))
		AS 'Sales'
	--,	SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'TVolumeOfSales'
	--,	SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'TTotalCash'
	--,	SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'GVOlumeOfSales'
	--,	SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'GTotalCash'
	--	,	SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'XTRVolumeOfSales' --Added RH 12/1/2014
	--,	SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'XTRTotalCash' --Added RH 12/1/2014
	--,	SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'EXTVolumeOfSales'
	--,	SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'EXTTotalCash'
	--,	SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostExtVolumeOfSales'
	--,	SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostExtTotalCash'
	--,	SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgeryVolumeOfSales'
	--,	SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgeryTotalCash'
	--,	SUM(ISNULL(FST.NB_TradCnt, 0))
	--		+ SUM(ISNULL(FST.NB_GradCnt, 0))
	--		+ SUM(ISNULL(FST.NB_XTRCnt, 0)) --Added RH 12/1/2014
	--		+ SUM(ISNULL(FST.NB_ExtCnt, 0))
	--		+ SUM(ISNULL(FST.S_PostExtCnt, 0))
	--		+ SUM(ISNULL(FST.S_SurCnt, 0))
	--	AS 'TotalNewCustomerVolumeOfSales'
	--,	SUM(ISNULL(FST.NB_TradAmt, 0))
	--		+ SUM(ISNULL(FST.NB_GradAmt, 0))
	--		+ SUM(ISNULL(FST.NB_XTRAmt, 0))  --Added RH 12/1/2014
	--		+ SUM(ISNULL(FST.NB_ExtAmt, 0))
	--		+ SUM(ISNULL(FST.S_PostExtAmt, 0))
	--		+ SUM(ISNULL(FST.S_SurAmt, 0))
	--	AS 'TotalNewCustomerTotalCash'
	--,	SUM(ISNULL(FST.NB_TradCnt, 0))
	--		+ SUM(ISNULL(FST.NB_GradCnt, 0))
	--	AS 'TradGradVolumeOfSales'
	,	SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'Applications'
	,	SUM(ISNULL(FST.NB_BIOConvCnt, 0))
			+ SUM(ISNULL(FST.NB_EXTConvCnt, 0))
			+ SUM(ISNULL(FST.NB_XTRConvCnt, 0))  --Added RH 12/1/2014
		AS 'Conversions'
	,	SUM(ISNULL(FST.ServiceAmt, 0)) AS 'Service'
	,	SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'BioConversions'
	,	SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'XTRConversions'   --Added RH 12/1/2014
	,	SUM(ISNULL(FST.NB_EXTConvCnt, 0)) AS 'EXTConversions'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Dates
			ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
	WHERE #Dates.DateID NOT IN (9, 10)
		AND SC.SalesCodeSSID NOT IN (686, 399, 697, 713, 714)
	GROUP BY #Dates.DateDesc


	/* Get Actual Appointments and Shows Data */
	SELECT #Dates.DateDesc
	,	SUM(ISNULL(FAR.Appointments, 0)) as 'Appointments'
	,	SUM(ISNULL(FAR.Consultation, 0)) as 'Consultation'
	INTO #TmpApptShow
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FAR.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = DD.datekey
		INNER JOIN #Centers
			ON CTR.CenterSSID = #Centers.CenterSSID
		INNER JOIN #Dates
			ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	WHERE CTR.Active = 'Y'
		AND #Dates.DateID NOT IN (9, 10)
		AND ResultCodeKey <> -1
	GROUP BY #Dates.DateDesc


	/* Get Actual Leads Data */
	SELECT #Dates.DateDesc
	,	COUNT(1) as 'Leads'
	INTO #TmpLead
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FL.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FL.LeadCreationDateKey = DD.datekey
		INNER JOIN #Centers
			ON CTR.CenterSSID = #Centers.CenterSSID
		INNER JOIN #Dates
			ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	WHERE CTR.Active = 'Y'
		AND #Dates.DateID NOT IN (9, 10)
	GROUP BY #Dates.DateDesc


	/* Get Actual PCP Data */
	SELECT #Dates.DateDesc
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10410 ) THEN a.Flash ELSE 0 END, 0)) AS 'PcpClients'
	INTO #TmpPCP
	FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON a.[CenterID] = CTR.CenterSSID
		INNER JOIN #Dates
			ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN #Centers
			ON a.CenterID = #Centers.CenterSSID
	WHERE #Dates.DateID NOT IN (9, 10)
		AND a.AccountID=10410
	GROUP BY #Dates.DateDesc


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
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205, 10210, 10215, 10220, 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'SalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205 ) THEN a.Budget ELSE 0 END, 0)) AS 'TVolumeOfSalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10305 ) THEN a.Budget ELSE 0 END, 0)) AS 'TTotalCashBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10210 ) THEN a.Budget ELSE 0 END, 0)) AS 'GVolumeOfSalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10310 ) THEN a.Budget ELSE 0 END, 0)) AS 'GTotalCashBudget'
	--	,	0 AS 'XTRVolumeOfSalesBudget' --Will be added after there are Budget amounts for Xtrands - Jan 2015
	--,	0 AS 'XTRTotalCashBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10215 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtVolumeOfSalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10315 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtTotalCashBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'PostExtVolumeOfSalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10325 ) THEN a.Budget ELSE 0 END, 0)) AS 'PostExtTotalCashBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10220 ) THEN a.Budget ELSE 0 END, 0)) AS 'SurgeryVolumeOfSalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10320 ) THEN a.Budget ELSE 0 END, 0)) AS 'SurgeryTotalCashBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205, 10210, 10215, 10220, 10225 ) THEN a.Budget ELSE 0 END, 0)) AS 'TotalNewCustomerVolumeOfSalesBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10305, 10310, 10315, 10320, 10325 ) THEN a.Budget ELSE 0 END, 0)) AS 'TotalNewCustomerTotalCashBudget'
	--,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10205, 10210 ) THEN a.Budget ELSE 0 END, 0)) AS 'TradGradVolumeOfSalesBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10240 ) THEN a.Budget ELSE 0 END, 0)) AS 'ApplicationsBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10440 ) THEN a.Budget ELSE 0 END, 0)) AS 'ConversionsBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 3080 ) THEN ABS(a.Budget) ELSE 0 END, 0)) AS 'ServiceBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10410 ) THEN a.Budget ELSE 0 END, 0)) AS 'PcpClientsBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10430 ) THEN a.Budget ELSE 0 END, 0)) AS 'BioConversionsBudget'
	,	0 AS 'XTRConversionsBudget'
	,	SUM(ISNULL(CASE WHEN a.[AccountID] IN ( 10435 ) THEN a.Budget ELSE 0 END, 0)) AS 'ExtConversionsBudget'
	FROM HC_Accounting.dbo.FactAccounting a
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON a.[CenterID] = CTR.CenterSSID
		INNER JOIN #Dates
			ON a.PartitionDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN #Centers
			ON a.CenterID = #Centers.CenterSSID
	WHERE #Dates.DateID IN (9, 10)
	GROUP BY #Dates.DateDesc


	INSERT INTO #Final (
		DateDesc
	,	DateOrder
	,	Leads
	,	Appointments
	,	Shows
	,	Sales
	,	SalesToLeads
	,	ConsultsToAppointments
	,	SalesToConsultations
	--,	TVolumeOfSales
	--,	TTotalCash
	--,	TCashPerSale
	--,	GVolumeOfSales
	--,	GTotalCash
	--,	GCashPerSale
	--	,	XTRVolumeOfSales
	--,	XTRTotalCash
	--,	XTRCashPerSale
	--,	ExtVolumeOfSales
	--,	ExtTotalCash
	--,	ExtCashPerSale
	--,	PostExtVolumeOfSales
	--,	PostExtTotalCash
	--,	PostExtCashPerSale
	--,	SurgeryVolumeOfSales
	--,	SurgeryTotalCash
	--,	SurgeryCashPerSale
	--,	TotalNewCustomerVolumeOfSales
	--,	TotalNewCustomerTotalCash
	--,	TotalNewCustomerCashPerSale
	,	Applications
	--,	AppsToSales
	,	Conversions
	,	ConvsToApps
	,	[Service]
	,	PcpClients
	,	BioConversions
	,	XTRConversions
	,	ExtConversions
	,	BioConvsToApps
	--,	XTRConvsToSales
	--,	ExtConvsToSales
	)

	SELECT d.DateDesc
	,	CASE WHEN DateDesc = 'CurrentMonthBudget' THEN 1
	WHEN DateDesc = 'CurrentMonth' THEN 2
	WHEN DateDesc = 'OneMonthBack' THEN 3
	WHEN DateDesc = 'TwoMonthsBack' THEN 4
	WHEN DateDesc = 'ThreeMonthsBack' THEN 5
	ELSE 6 END AS DateOrder
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Leads ELSE d.Leads * @CurrentToTotal END AS 'Leads'
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Appointments ELSE d.Appointments * @CummToMonth END AS 'Appointments'
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Shows ELSE d.Shows * @CummToMonth END AS 'Shows'
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Sales ELSE d.Sales * @CummToMonth END AS 'Sales'
	,	dbo.DIVIDE_DECIMAL(d.Sales, d.Leads) AS 'SalesToLeads'
	,	dbo.DIVIDE_DECIMAL(d.Shows, d.Appointments) AS 'ConsultsToAppointments'
	,	dbo.DIVIDE_DECIMAL(d.Sales, d.Shows) AS 'SalesToConsultations'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.TVolumeOfSales ELSE d.TVolumeOfSales * @CummToMonth END AS 'TVolumeOfSales'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.TTotalCash ELSE d.TTotalCash * @CummToMonth END AS 'TTotalCash'
	--,	dbo.DIVIDE_DECIMAL(d.TTotalCash, d.TVolumeOfSales) AS 'TCashPerSale'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.GVolumeOfSales ELSE d.GVolumeOfSales * @CummToMonth END AS 'GVolumeOfSales'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.GTotalCash ELSE d.GTotalCash * @CummToMonth END AS 'GTotalCash'
	--,	dbo.DIVIDE_DECIMAL(d.GTotalCash, d.GVolumeOfSales) AS 'GCashPerSale'
	--	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.XTRVolumeOfSales ELSE d.XTRVolumeOfSales * @CummToMonth END AS 'XTRVolumeOfSales'   --Added RH 12/1/2014
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.XTRTotalCash ELSE d.XTRTotalCash * @CummToMonth END AS 'XTRTotalCash'   --Added RH 12/1/2014
	--,	dbo.DIVIDE_DECIMAL(d.XTRTotalCash, d.XTRVolumeOfSales) AS 'XTRCashPerSale'   --Added RH 12/1/2014
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.ExtVolumeOfSales ELSE d.ExtVolumeOfSales * @CummToMonth END AS 'ExtVolumeOfSales'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.ExtTotalCash ELSE d.ExtTotalCash * @CummToMonth END AS 'ExtTotalCash'
	--,	dbo.DIVIDE_DECIMAL(d.ExtTotalCash, d.ExtVolumeOfSales) AS 'ExtCashPerSale'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.PostExtVolumeOfSales ELSE d.PostExtVolumeOfSales * @CummToMonth END AS 'PostExtVolumeOfSales'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.PostExtTotalCash ELSE d.PostExtTotalCash * @CummToMonth END AS 'PostExtTotalCash'
	--,	dbo.DIVIDE_DECIMAL(d.PostExtTotalCash, d.PostExtVolumeOfSales) AS 'PostExtCashPerSale'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.SurgeryVolumeOfSales ELSE d.SurgeryVolumeOfSales * @CummToMonth END AS 'SurgeryVolumeOfSales'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.SurgeryTotalCash ELSE d.SurgeryTotalCash * @CummToMonth END AS 'SurgeryTotalCash'
	--,	dbo.DIVIDE_DECIMAL(d.SurgeryTotalCash, d.SurgeryVolumeOfSales) AS 'SurgeryCashPerSale'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.TotalNewCustomerVolumeOfSales ELSE d.TotalNewCustomerVolumeOfSales * @CummToMonth END AS 'TotalNewCustomerVolumeOfSales'
	--,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.TotalNewCustomerTotalCash ELSE d.TotalNewCustomerTotalCash * @CummToMonth END AS 'TotalNewCustomerTotalCash'
	--,	dbo.DIVIDE_DECIMAL(d.TotalNewCustomerTotalCash, d.TotalNewCustomerVolumeOfSales) AS 'TotalNewCustomerCashPerSale'
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.Applications ELSE d.Applications * @CummToMonth END AS 'Applications'
	--,	dbo.DIVIDE_DECIMAL(d.Applications, d.TradGradVolumeOfSales) AS 'AppsToSales'
	,	d.Conversions
	,	dbo.DIVIDE_DECIMAL(d.Conversions, d.Applications) AS 'ConvsToApps'
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.[Service] ELSE d.[Service] * @CummToMonth END AS 'Service'
	,	d.PcpClients
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.BioConversions ELSE d.BioConversions * @CummToMonth END AS 'BioConversions'
		,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.XTRConversions ELSE d.XTRConversions * @CummToMonth END AS 'XTRConversions'
	,	CASE WHEN d.DateDesc IN ('CurrentMonth', 'CurrentFiscalYear', 'PriorFiscalYear', 'CurrentFiscalYearBudget') THEN d.ExtConversions ELSE d.ExtConversions * @CummToMonth END AS 'ExtConversions'
	,	dbo.DIVIDE_DECIMAL(d.BioConversions, d.Applications) AS 'BioConvsToApps'
	--,	dbo.DIVIDE_DECIMAL(d.XTRConversions, d.XTRVolumeOfSales) AS 'XTRConvsToSales'   --Added RH 12/1/2014
	--,	dbo.DIVIDE_DECIMAL(d.ExtConversions, d.ExtVolumeOfSales) AS 'ExtConvsToSales'
	FROM #Data d

	SELECT
	DateDesc
	,	DateOrder
	,	Leads
	,	Appointments
	,	Shows
	,	Sales
	,	SalesToLeads
	,	ConsultsToAppointments
	,	SalesToConsultations
	--,	TVolumeOfSales
	--,	TTotalCash
	--,	TCashPerSale
	--,	GVolumeOfSales
	--,	GTotalCash
	--,	GCashPerSale
	--	,	XTRVolumeOfSales
	--,	XTRTotalCash
	--,	XTRCashPerSale
	--,	ExtVolumeOfSales
	--,	ExtTotalCash
	--,	ExtCashPerSale
	--,	PostExtVolumeOfSales
	--,	PostExtTotalCash
	--,	PostExtCashPerSale
	--,	SurgeryVolumeOfSales
	--,	SurgeryTotalCash
	--,	SurgeryCashPerSale
	--,	TotalNewCustomerVolumeOfSales
	--,	TotalNewCustomerTotalCash
	--,	TotalNewCustomerCashPerSale
	,	Applications
	--,	AppsToSales
	,	Conversions
	,	ConvsToApps
	,	[Service]
	,	PcpClients
	,	BioConversions
	,	XTRConversions
	,	ExtConversions
	,	BioConvsToApps
	--,	XTRConvsToSales
	--,	ExtConvsToSales
	FROM #Final

END
