/* CreateDate: 05/03/2010 12:08:53.253 , ModifyDate: 04/08/2020 16:10:48.950 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [bief_dds].[DDS_DimDate_Populate]
		  @StartDate	datetime = '07/01/2008'
		, @EndDate		datetime = '07/01/2009'

AS
-------------------------------------------------------------------------
-- [DDS_DimDate_Populate] is used to load the Date Dimension
--
--
--
--   EXEC [bief_dds].[DDS_DimDate_Populate] '01/01/2021', '12/31/2021'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DELETE [bief_dds].[DimDate]

	--INSERT INTO [bief_dds].[DimDate] (DateKey, FullDate, DateName, ISODate, WeekName, WeekNameWithYear, WeekShortName, WeekShortNameWithYear, WeekNumber, FirstDateOfWeek, LastDateOfWeek, DayOfWeek, DayOfWeekName, IsWeekday, IsWeekend, MonthName, MonthNameWithYear, MonthShortName, MonthShortNameWithYear, MonthNumber, FirstDateOfMonth, LastDateOfMonth, DayOfMonth, DayOfMonthName, IsLastDayOfMonth, QuarterName, QuarterNameWithYear, QuarterShortName, QuarterShortNameWithYear, QuarterNumber, FirstDateOfQuarter, LastDateOfQuarter, DayOfQuarter, DayOfQuarterName, HalfName, HalfNameWithYear, HalfShortName, HalfShortNameWithYear, HalfNumber, FirstDateOfHalf, LastDateOfHalf, DayOfHalf, DayOfHalfName, YearName, YearShortName, YearNumber, FirstDateOfYear, LastDateOfYear, DayOfYear, DayOfYearName, CalendarQuarter, CalendarYear, CalendarYearMonth, CalendarYearQtr, FiscalMonth, FiscalQuarter, FiscalYear)
	--VALUES (-1, '1/1/1753', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 0, 0, 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 0, 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 'NA', 'NA', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', -1, -1, 'Unknown', 'Unknown', -1, -1, -1)

	DECLARE @DateKey int
	DECLARE @FullDate DateTime
	DECLARE @DateName char(12)
	DECLARE @ISODate char(8)

	DECLARE	@WeekName varchar(7)
	DECLARE	@WeekNameWithYear varchar(13)
	DECLARE	@WeekShortName char(4)
	DECLARE	@WeekShortNameWithYear char(9)
	DECLARE	@WeekNumber tinyint
	DECLARE @FirstDateOfWeek as datetime
	DECLARE @LastDateOfWeek as datetime
	DECLARE	@DayOfWeek tinyint
	DECLARE	@DayOfWeekName varchar(9)
	DECLARE @IsWeekday bit
	DECLARE @IsWeekend bit

	DECLARE @YearNumberWeekNumber int
	DECLARE @YearNumberMonthNumber int
	DECLARE @YearNumberQuarterNumber int
	DECLARE @YearQuarterMonthNumber int
	DECLARE @YearNumberHalfNumber int

	DECLARE	@MonthName varchar(9)
	DECLARE	@MonthNameWithYear varchar(15)
	DECLARE	@MonthShortName varchar(3)
	DECLARE	@MonthShortNameWithYear char(8)
	DECLARE	@MonthNumber tinyint
	DECLARE @FirstDateOfMonth as datetime
	DECLARE @LastDateOfMonth as datetime
	DECLARE @DayOfMonth tinyint
	DECLARE @DayOfMonthName varchar(16)
	DECLARE @IsLastDayOfMonth bit

	DECLARE	@QuarterName char(9)
	DECLARE	@QuarterNameWithYear char(15)
	DECLARE	@QuarterShortName char(2)
	DECLARE	@QuarterShortNameWithYear char(7)
	DECLARE	@QuarterNumber tinyint
	DECLARE @FirstDateOfQuarter as datetime
	DECLARE @LastDateOfQuarter as datetime
	DECLARE @DayOfQuarter tinyint
	DECLARE @DayOfQuarterName varchar(20)

	DECLARE	@HalfName char(6)
	DECLARE	@HalfNameWithYear char(12)
	DECLARE	@HalfShortName char(2)
	DECLARE	@HalfShortNameWithYear char(7)
	DECLARE	@HalfNumber tinyint
	DECLARE @FirstDateOfHalf as datetime
	DECLARE @LastDateOfHalf as datetime
	DECLARE @DayOfHalf tinyint
	DECLARE @DayOfHalfName varchar(20)

	DECLARE	@YearName char(4)
	DECLARE	@YearShortName char(2)
	DECLARE	@YearNumber smallint
	DECLARE @FirstDateOfYear as datetime
	DECLARE @LastDateOfYear as datetime
	DECLARE @DayOfYear smallint
	DECLARE @DayOfYearName varchar(20)

	DECLARE @CalendarQuarter tinyint
	DECLARE @CalendarYear smallint
	DECLARE @CalendarYearMonth char(7)
	DECLARE @CalendarYearQtr char(7)

	DECLARE @FiscalYear smallint
	DECLARE @FiscalWeek smallint
	DECLARE @FiscalMonth smallint
	DECLARE @FiscalPeriod smallint
	DECLARE @FiscalQuarter smallint

	DECLARE @FYFiscalWeek int
	DECLARE @FYFiscalMonth int
	DECLARE @FYFiscaPeriod int
	DECLARE @FYFiscalQuarter int
	DECLARE @FYFQFiscalMonth int

	DECLARE @FiscalYearName varchar(4)
	DECLARE @FiscalYearLongName varchar(16)
	DECLARE	@FiscalYearShortName varchar(6)

	DECLARE	@FiscalQuarterName varchar(1)
	DECLARE	@FiscalQuarterLongName varchar(16)
	DECLARE	@FiscalQuarterNameWithYear varchar(7)
	DECLARE	@FiscalQuarterLongNameWithYear varchar(34)
	DECLARE	@FiscalQuarterShortName varchar(3)
	DECLARE	@FiscalQuarterShortNameWithYear varchar(21)

	DECLARE	@FiscalMonthName varchar(2)
	DECLARE	@FiscalMonthNameWithYear varchar(8)
	DECLARE	@FiscalMonthShortName varchar(4)
	DECLARE	@FiscalMonthShortNameWithYear varchar(14)
	DECLARE	@FiscalMonthCalendarShortName varchar(16)
	DECLARE	@FiscalMonthCalendarShortNameWithYear varchar(22)

	DECLARE @FiscalYearWeekName varchar(8)
	DECLARE @FiscalYearMonthName varchar(9)
	DECLARE @FiscalYearQuarterName varchar(8)

	DECLARE	@FiscalWeekName varchar(2)
	DECLARE	@FiscalWeekLongName varchar(14)
	DECLARE	@FiscalWeekNameWithYear varchar(8)
	DECLARE	@FiscalWeekLongNameWithYear varchar(20)
	DECLARE	@FiscalWeekShortName varchar(4)
	DECLARE	@FiscalWeekShortNameWithYear varchar(10)

	DECLARE	@FiscalPeriodName varchar(2)
	DECLARE	@FiscalPeriodLongName varchar(16)
	DECLARE	@FiscalPeriodNameWithYear varchar(8)
	DECLARE	@FiscalPeriodLongNameWithYear varchar(22)
	DECLARE	@FiscalPeriodShortName varchar(4)
	DECLARE	@FiscalPeriodShortNameWithYear varchar(10)



	SET @FullDate = @StartDate

	WHILE DateDiff(day,@FullDate,@EndDate) >= 0
	BEGIN
		--  This will give sequential number 1,2,3
		--SET @DateKey = DateDiff(day,@StartDate,@EndDate) - DateDiff(day,@FullDate,@EndDate) + 1
		-- This will give sequential number in format yyyymmdd
		SET @DateKey = cast(convert(char(8),@FullDate,112) as int)
		SET @ISODate = convert(char(8),@FullDate,112)
		SET @DateName = convert(char(12),@FullDate,107)

		SET @YearNumber = DATEPART(yy,@FullDate)
		SET @YearName = right('0000' + cast(@YearNumber as varchar(4)),4)
		SET @YearShortName = right('0000' + cast(@YearNumber as varchar(4)),2)
		SET @FirstDateOfYear = cast(@YearName + '-01-01' as datetime)
		SET @LastDateOfYear = cast(@YearName + '-12-31' as datetime)
		SET @DayOfYear = DATEPART(dy, @FullDate)

		SET @QuarterNumber = DATEPART(q, @FullDate)
		SET @QuarterName = 'Quarter ' + cast(@QuarterNumber as char(1))
		SET @QuarterNameWithYear = @QuarterName + ', ' + @YearName
		SET @QuarterShortName = 'Q' + cast(@QuarterNumber as char(1))
		SET @QuarterShortNameWithYear = @QuarterShortName + ' ' + @YearName
		SET @FirstDateOfQuarter =
			CASE @QuarterNumber
			WHEN 1 THEN cast(@YearName + '-01-01' as datetime)
			WHEN 2 THEN cast(@YearName + '-04-01' as datetime)
			WHEN 3 THEN cast(@YearName + '-07-01' as datetime)
			WHEN 4 THEN cast(@YearName + '-10-01' as datetime)
			END
		SET @LastDateOfQuarter = dateadd(day,-1,dateadd(q,1,@FirstDateOfQuarter))
		SET @DayOfQuarter = DateDiff(day,@FirstDateOfQuarter, @FullDate) + 1
		SET @DayOfQuarterName = 'Day ' + cast(DateDiff(day,@FirstDateOfQuarter, @FullDate) + 1 as varchar(2)) + ' of Q' + cast(@QuarterNumber as char(1))

		SET @HalfNumber = CASE WHEN DATEPART(q, @FullDate) <= 2 THEN 1 ELSE 2 END
		SET @HalfName = 'Half ' + cast(@HalfNumber as char(1))
		SET @HalfNameWithYear = @HalfName + ', ' + @YearName
		SET @HalfShortName = 'H' + cast(@HalfNumber as char(1))
		SET @HalfShortNameWithYear = @HalfShortName + ' ' + @YearName
		SET @FirstDateOfHalf =
			CASE @HalfNumber
			WHEN 1 THEN cast(@YearName + '-01-01' as datetime)
			WHEN 2 THEN cast(@YearName + '-07-01' as datetime)
			END
		SET @LastDateOfHalf =
			CASE @HalfNumber
			WHEN 1 THEN cast(@YearName + '-06-30' as datetime)
			WHEN 2 THEN cast(@YearName + '-12-31' as datetime)
			END
		SET @DayOfHalf = DateDiff(day,@FirstDateOfHalf, @FullDate) + 1
		SET @DayOfHalfName = 'Day ' + cast(DateDiff(day,@FirstDateOfHalf, @FullDate) + 1 as varchar(3)) + ' of H' + cast(@HalfNumber as char(1))

		SET @MonthName = DATENAME(mm, @FullDate)
		SET @MonthNameWithYear = @MonthName + ', ' + @YearName
		SET @MonthShortName = DATENAME(m, @FullDate)
		SET @MonthShortNameWithYear = @MonthShortName + ' ' + @YearName
		SET @MonthNumber = DATEPART(m, @FullDate)
		SET @FirstDateOfMonth = cast(@YearName + '-'+@MonthShortName+'-01' as datetime)
		SET @LastDateOfMonth = dateadd(day,-1,dateadd(m,1,@FirstDateOfMonth))
		SET @DayOfMonth = DATEPART(d, @FullDate)
		SET @DayOfMonthName = datename(m,@FullDate) + ' ' +
			cast(datepart(d,@FullDate) as varchar(2)) +
			CASE left(right('00' + cast(datepart(d,@FullDate) as varchar(2)),2),1)
			WHEN '1' THEN
				'th'
			ELSE
				CASE right(right('00' + cast(datepart(d,@FullDate) as varchar(2)),2),1)
				WHEN '1' THEN 'st'
				WHEN '2' THEN 'nd'
				WHEN '3' THEN 'rd'
				ELSE 'th'
				END
			END
		SET @DayOfYearName = @DayOfMonthName + ', ' + @YearName

		SET @WeekName = 'Week ' + datename(wk,@FullDate)
		SET @WeekNameWithYear =@WeekName + ', ' + @YearName
		SET @WeekShortName = 'WK'+right('00'+datename(wk,@FullDate),2)
		SET @WeekShortNameWithYear = @WeekShortName + ' ' + @YearName
		SET @WeekNumber = datepart(wk,@FullDate)

		SET @FirstDateOfWeek = dateadd(day,(datepart(dw,@FullDate)-1)*-1,@FullDate)
		SET @LastDateOfWeek = dateadd(day,-1,dateadd(wk,1,@FirstDateOfWeek))
		SET @DayOfWeek = DATEPART(dw, @FullDate)
		SET @DayOfWeekName = DATENAME(dw, @FullDate)
		SET @IsWeekday = CASE @DayOfWeek WHEN 1 THEN 0 WHEN 7 THEN 0 ELSE 1 END
		SET @IsWeekend = CASE @DayOfWeek WHEN 1 THEN 1 WHEN 7 THEN 1 ELSE 0 END


		SET @IsLastDayOfMonth = CASE DateDiff(day,@FullDate,@LastDateOfMonth) WHEN 0 THEN 1 ELSE 0 END
		SET @CalendarQuarter = DATEPART(q, @FullDate)
		SET @CalendarYear = DATEPART(yy,@FullDate)
		SET @CalendarYearMonth = @YearName + '-' + right('00' +CAST(DATEPART(m,@FullDate) as varchar(2)),2)
		SET @CalendarYearQtr = @YearName + @QuarterShortName

		SET @YearNumberWeekNumber = cast(cast(@YearNumber as varchar(4)) + right('00' + cast(@WeekNumber as varchar(2)),2) as int)
		SET @YearNumberMonthNumber = cast(cast(@YearNumber as varchar(4)) + right('00' + cast(@MonthNumber as varchar(2)),2) as int)
		SET @YearNumberQuarterNumber = cast(cast(@YearNumber as varchar(4)) + right('00' + cast(@QuarterNumber as varchar(2)),2) as int)
		SET @YearNumberHalfNumber  = cast(cast(@YearNumber as varchar(4)) + right('00' + cast(@HalfNumber as varchar(2)),2) as int)
		SET @YearQuarterMonthNumber = cast(cast(@YearNumber as varchar(4)) + right('00' + cast(@QuarterNumber as varchar(2)),2) + right('00' + cast(@MonthNumber as varchar(2)),2) as int)


		-- Fiscal Year begins July 1
		SET @FiscalYear = bief_dds.DDS_DimDate_FiscalYear(@FullDate)
		SET @FiscalWeek = bief_dds.DDS_DimDate_FiscalWeek(@FullDate)
		SET @FiscalMonth = bief_dds.[DDS_DimDate_FiscalMonth](@FullDate)
		SET @FiscalPeriod = [bief_dds].[DDS_DimDate_FiscalPeriod](@FiscalWeek)
		-------SET @FiscalQuarter = FLOOR(@FiscalPeriod / 3.0 + 0.9)
		SET @FiscalQuarter = FLOOR(@FiscalMonth / 3.0 + 0.9)

		SET @FYFiscalWeek = cast(cast(@FiscalYear as varchar(4)) + right('00' + cast(@FiscalWeek as varchar(2)),2) as int)
		SET @FYFiscalMonth = cast(cast(@FiscalYear as varchar(4)) + right('00' + cast(@FiscalMonth as varchar(2)),2) as int)
		SET @FYFiscaPeriod =  cast(cast(@FiscalYear as varchar(4)) + right('00' + cast(@FiscalPeriod as varchar(2)),2) as int)
		SET @FYFiscalQuarter = cast(cast(@FiscalYear as varchar(4)) + right('00' + cast(@FiscalQuarter as varchar(2)),2) as int)
		SET @FYFQFiscalMonth = cast(cast(@FiscalYear as varchar(4)) + right('00' + cast(@FiscalQuarter as varchar(2)),2) + right('00' + cast(@FiscalMonth as varchar(2)),2) as int)


		SET @FiscalYearName = right('0000' + cast(@FiscalYear as varchar(4)),4)
		SET @FiscalYearLongName = 'Fiscal Year ' + right('0000' + cast(@FiscalYear as varchar(4)),4)
		SET @FiscalYearShortName = 'FY' + right('0000' + cast(@FiscalYear as varchar(4)),4)

		SET @FiscalQuarterName = cast(@FiscalQuarter as char(1))
		SET @FiscalQuarterLongName = 'Fiscal Quarter ' + cast(@FiscalQuarter as char(1))
		SET @FiscalQuarterNameWithYear = @FiscalQuarterName + ', ' + @FiscalYearName
		SET @FiscalQuarterLongNameWithYear = @FiscalQuarterLongName + ', ' + @FiscalYearName
		SET @FiscalQuarterShortName = 'FQ' + cast(@FiscalQuarter as char(1))
		SET @FiscalQuarterShortNameWithYear = @FiscalQuarterShortName + ', ' + @FiscalYearName

		SET @FiscalMonthName = right('00' + cast(@FiscalMonth as varchar(2)),2)
		SET @FiscalMonthNameWithYear = @FiscalMonthName + ', ' + cast(@FiscalYear as varchar(4))
		SET @FiscalMonthShortName = 'FM' + right('00' + cast(@FiscalMonth as varchar(2)),2)
		SET @FiscalMonthShortNameWithYear = @FiscalMonthShortName + ', ' + cast(@FiscalYear as varchar(4))
		SET @FiscalMonthCalendarShortName = 'Fiscal ' + DATENAME(mm, @FullDate)
		SET @FiscalMonthCalendarShortNameWithYear = @FiscalMonthCalendarShortName + ', ' + cast(@FiscalYear as varchar(4))

		SET @FiscalWeekName = right('00' + cast(@FiscalWeek as varchar(2)),2)
		SET @FiscalWeekLongName = 'Fiscal Week ' + right('00' + cast(@FiscalWeek as varchar(2)),2)
		SET @FiscalWeekNameWithYear = @FiscalWeekName + ', ' + cast(@FiscalYear as varchar(4))
		SET @FiscalWeekLongNameWithYear = @FiscalWeekLongName + ', ' + cast(@FiscalYear as varchar(4))
		SET @FiscalWeekShortName = 'FW' + right('00' + cast(@FiscalWeek as varchar(2)),2)
		SET @FiscalWeekShortNameWithYear = 'FW' + right('00' + cast(@FiscalWeek as varchar(2)),2) + ', ' + cast(@FiscalYear as varchar(4))

		SET @FiscalPeriodName = right('00' + cast(@FiscalPeriod as varchar(2)),2)
		SET @FiscalPeriodLongName = 'Fiscal Period ' + right('00' + cast(@FiscalPeriod as varchar(2)),2)
		SET @FiscalPeriodNameWithYear = @FiscalPeriodName + ', ' + cast(@FiscalYear as varchar(4))
		SET @FiscalPeriodLongNameWithYear = @FiscalPeriodLongName + ', ' + cast(@FiscalYear as varchar(4))
		SET @FiscalPeriodShortName = 'FP' + right('00' + cast(@FiscalPeriod as varchar(2)),2)
		SET @FiscalPeriodShortNameWithYear = 'FP' + right('00' + cast(@FiscalPeriod as varchar(2)),2) + ', ' + cast(@FiscalYear as varchar(4))


		INSERT INTO bief_dds.[DimDate]
		(
			[DateKey],
			[FullDate],
			[DateName],
			[ISODate],

			[WeekName],
			[WeekNameWithYear],
			[WeekShortName],
			[WeekShortNameWithYear],
			[WeekNumber],
			[YearWeekNumber],

			[FirstDateOfWeek],
			[LastDateOfWeek],
			[DayOfWeek],
			[DayOfWeekName],
			[IsWeekday],
			[IsWeekend],

			[MonthName],
			[MonthNameWithYear],
			[MonthShortName],
			[MonthShortNameWithYear],
			[MonthNumber],
			[YearMonthNumber],

			[FirstDateOfMonth],
			[LastDateOfMonth],
			[DayOfMonth],
			[DayOfMonthName],
			[IsLastDayOfMonth],

			[QuarterName],
			[QuarterNameWithYear],
			[QuarterShortName],
			[QuarterShortNameWithYear],
			[QuarterNumber],
			[YearQuarterNumber],

			[FirstDateOfQuarter],
			[LastDateOfQuarter],
			[DayOfQuarter],
			[DayOfQuarterName],

			[HalfName],
			[HalfNameWithYear],
			[HalfShortName],
			[HalfShortNameWithYear],
			[HalfNumber],
			[YearHalfNumber],

			[FirstDateOfHalf],
			[LastDateOfHalf],
			[DayOfHalf],
			[DayOfHalfName],

			[YearName],
			[YearShortName],
			[YearNumber],
			[FirstDateOfYear],
			[LastDateOfYear],
			[DayOfYear],
			[DayOfYearName],
			[CalendarQuarter],
			[CalendarYear],
			[CalendarYearMonth],
			[CalendarYearQtr],
			[YearQuarterMonthNumber],

            [FiscalYear],
            [FiscalWeek],
            [FiscalPeriod],
            [FiscalMonth],
            [FiscalQuarter],

			[FiscalYearFiscalWeek],
			[FiscalYearFiscalMonth],
			[FiscalYearFiscalPeriod],
			[FiscalYearFiscalQuarter],
			[FiscalYearFiscalQuarterFiscalMonth],

            [FiscalYearName],
            [FiscalYearLongName],
            [FiscalYearShortName],

            [FiscalQuarterName],
            [FiscalQuarterLongName],
            [FiscalQuarterNameWithYear],
            [FiscalQuarterLongNameWithYear],
            [FiscalQuarterShortName],
            [FiscalQuarterShortNameWithYear],

            [FiscalMonthName],
            [FiscalMonthNameWithYear],
            [FiscalMonthShortName],
            [FiscalMonthShortNameWithYear],
            [FiscalMonthCalendarShortName],
            [FiscalMonthCalendarShortNameWithYear],

            [FiscalWeekName],
            [FiscalWeekLongName],
            [FiscalWeekNameWithYear],
            [FiscalWeekLongNameWithYear],
            [FiscalWeekShortName],
            [FiscalWeekShortNameWithYear],

            [FiscalPeriodName],
            [FiscalPeriodLongName],
            [FiscalPeriodNameWithYear],
            [FiscalPeriodLongNameWithYear],
            [FiscalPeriodShortName],
            [FiscalPeriodShortNameWithYear]

		)
		VALUES
		(
			@DateKey,
			@FullDate,
			@DateName,
			@ISODate,

			@WeekName,
			@WeekNameWithYear,
			@WeekShortName,
			@WeekShortNameWithYear,
			@WeekNumber,
			@YearNumberWeekNumber,

			@FirstDateOfWeek,
			@LastDateOfWeek,
			@DayOfWeek,
			@DayOfWeekName,
			@IsWeekday,
			@IsWeekend,


			@MonthName,
			@MonthNameWithYear,
			@MonthShortName,
			@MonthShortNameWithYear,
			@MonthNumber,
			@YearNumberMonthNumber,

			@FirstDateOfMonth,
			@LastDateOfMonth,
			@DayOfMonth,
			@DayOfMonthName,
			@IsLastDayOfMonth,

			@QuarterName,
			@QuarterNameWithYear,
			@QuarterShortName,
			@QuarterShortNameWithYear,
			@QuarterNumber,
			@YearNumberQuarterNumber,

			@FirstDateOfQuarter,
			@LastDateOfQuarter,
			@DayOfQuarter,
			@DayOfQuarterName,

			@HalfName,
			@HalfNameWithYear,
			@HalfShortName,
			@HalfShortNameWithYear,
			@HalfNumber,
			@YearNumberHalfNumber,

			@FirstDateOfHalf,
			@LastDateOfHalf,
			@DayOfHalf,
			@DayOfHalfName,

			@YearName,
			@YearShortName,
			@YearNumber,
			@FirstDateOfYear,
			@LastDateOfYear,
			@DayOfYear,
			@DayOfYearName,
			@CalendarQuarter,
			@CalendarYear,
			@CalendarYearMonth,
			@CalendarYearQtr,
			@YearQuarterMonthNumber,

			@FiscalYear,
            @FiscalWeek,
            @FiscalPeriod,
            @FiscalMonth,
            @FiscalQuarter,

			@FYFiscalWeek,
			@FYFiscalMonth,
			@FYFiscaPeriod,
			@FYFiscalQuarter,
			@FYFQFiscalMonth,

            @FiscalYearName,
            @FiscalYearLongName,
            @FiscalYearShortName,

            @FiscalQuarterName,
            @FiscalQuarterLongName,
            @FiscalQuarterNameWithYear,
            @FiscalQuarterLongNameWithYear,
            @FiscalQuarterShortName,
            @FiscalQuarterShortNameWithYear,

            @FiscalMonthName,
            @FiscalMonthNameWithYear,
            @FiscalMonthShortName,
            @FiscalMonthShortNameWithYear,
            @FiscalMonthCalendarShortName,
            @FiscalMonthCalendarShortNameWithYear,

            @FiscalWeekName,
            @FiscalWeekLongName,
            @FiscalWeekNameWithYear,
            @FiscalWeekLongNameWithYear,
            @FiscalWeekShortName,
            @FiscalWeekShortNameWithYear,

            @FiscalPeriodName,
            @FiscalPeriodLongName,
            @FiscalPeriodNameWithYear,
            @FiscalPeriodLongNameWithYear,
            @FiscalPeriodShortName,
            @FiscalPeriodShortNameWithYear


		)

		SET @FullDate = DATEADD(day, 1, @FullDate)
	END


	-- Cleanup
	-- Reset SET NOCOUNT to OFF.
	SET NOCOUNT OFF

	-- Cleanup temp tables

	-- Return success
	RETURN 0

END
GO
