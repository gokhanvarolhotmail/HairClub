/* CreateDate: 06/09/2015 12:21:07.787 , ModifyDate: 06/09/2015 12:21:07.787 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_PriorDates]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		06/09/2015

==============================================================================
DESCRIPTION: This stored procedure is used to find the Prior Dates.  These may be used as a dataset for the reports.
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_PriorDates] 5, 2015

==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_PriorDates] (
	@Month			INT
,	@Year			INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


	DECLARE	@TempDate DATETIME

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

	SET @Month = 5
	SET @Year = 2015
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


	SELECT * FROM #Dates

END
GO
