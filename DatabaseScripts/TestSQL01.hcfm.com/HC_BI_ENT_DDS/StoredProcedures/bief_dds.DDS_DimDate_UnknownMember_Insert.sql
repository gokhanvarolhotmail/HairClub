/* CreateDate: 05/03/2010 12:08:53.303 , ModifyDate: 09/24/2014 11:41:44.750 */
GO
CREATE PROCEDURE [bief_dds].[DDS_DimDate_UnknownMember_Insert]


AS
-------------------------------------------------------------------------
-- [DDS_DimDate_UnknownMember_Insert] is used to add
-- the unknown member to the table.
--
--
--   exec [bief_dds].[DDS_DimDate_UnknownMember_Insert]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0                 RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	INSERT INTO [bief_dds].[DimDate] (DateKey, FullDate, DateName, ISODate, WeekName
			, WeekNameWithYear, WeekShortName, WeekShortNameWithYear, WeekNumber, FirstDateOfWeek
			, LastDateOfWeek, DayOfWeek, DayOfWeekName, IsWeekday, IsWeekend, MonthName
			, MonthNameWithYear, MonthShortName, MonthShortNameWithYear, MonthNumber
			, FirstDateOfMonth, LastDateOfMonth, DayOfMonth, DayOfMonthName, IsLastDayOfMonth
			, QuarterName, QuarterNameWithYear, QuarterShortName, QuarterShortNameWithYear
			, QuarterNumber, FirstDateOfQuarter, LastDateOfQuarter, DayOfQuarter, DayOfQuarterName
			, HalfName, HalfNameWithYear, HalfShortName, HalfShortNameWithYear, HalfNumber
			, FirstDateOfHalf, LastDateOfHalf, DayOfHalf, DayOfHalfName, YearName, YearShortName
			, YearNumber, FirstDateOfYear, LastDateOfYear, DayOfYear, DayOfYearName, CalendarQuarter
			, CalendarYear, CalendarYearMonth, CalendarYearQtr
			, [FiscalYear], [FiscalWeek], [FiscalPeriod], [FiscalMonth],[FiscalQuarter]
            , [FiscalYearFiscalWeek], [FiscalYearFiscalPeriod], [FiscalYearFiscalMonth],[FiscalYearFiscalQuarter]
            , [FiscalYearFiscalQuarterFiscalMonth], [FiscalYearName], [FiscalYearLongName], [FiscalYearShortName]
            , [FiscalQuarterName], [FiscalQuarterLongName], [FiscalQuarterNameWithYear], [FiscalQuarterLongNameWithYear]
            , [FiscalQuarterShortName], [FiscalQuarterShortNameWithYear], [FiscalMonthName], [FiscalMonthNameWithYear]
            , [FiscalMonthShortName], [FiscalMonthShortNameWithYear], [FiscalMonthCalendarShortName]
            , [FiscalMonthCalendarShortNameWithYear], [FiscalWeekName], [FiscalWeekLongName], [FiscalWeekNameWithYear]
            , [FiscalWeekShortName], [FiscalWeekShortNameWithYear], [FiscalPeriodName]
            , [FiscalPeriodLongName], [FiscalPeriodNameWithYear], [FiscalPeriodLongNameWithYear]
            , [FiscalPeriodShortName], [FiscalPeriodShortNameWithYear])
	VALUES (-1, '1/1/1753', 'NA', 'NA', 'NA'
			, 'NA', 'NA', 'NA', -1, '1/1/1753'
			, '1/1/1753', -1, 'NA', 0, 0, 'NA'
			, 'NA', 'NA', 'NA', -1
			, '1/1/1753', '1/1/1753', -1, 'NA', 0
			, 'NA', 'NA', 'NA', 'NA'
			, -1, '1/1/1753', '1/1/1753', -1, 'NA'
			, 'NA', 'NA', 'NA', 'NA', -1
			, '1/1/1753', '1/1/1753', -1, 'NA', 'NA', 'NA'
			, -1, '1/1/1753', '1/1/1753', -1, 'NA', -1
			, -1, 'NA', 'NA'
			, -1, -1, -1, -1, -1
			, -1, -1, -1, -1
			, -1, 'NA', 'NA', 'NA'
            , '', 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA'
            , 'NA', 'NA')


	INSERT INTO [bief_dds].[DimDate] (DateKey, FullDate, DateName, ISODate, WeekName
			, WeekNameWithYear, WeekShortName, WeekShortNameWithYear, WeekNumber, FirstDateOfWeek
			, LastDateOfWeek, DayOfWeek, DayOfWeekName, IsWeekday, IsWeekend, MonthName
			, MonthNameWithYear, MonthShortName, MonthShortNameWithYear, MonthNumber
			, FirstDateOfMonth, LastDateOfMonth, DayOfMonth, DayOfMonthName, IsLastDayOfMonth
			, QuarterName, QuarterNameWithYear, QuarterShortName, QuarterShortNameWithYear
			, QuarterNumber, FirstDateOfQuarter, LastDateOfQuarter, DayOfQuarter, DayOfQuarterName
			, HalfName, HalfNameWithYear, HalfShortName, HalfShortNameWithYear, HalfNumber
			, FirstDateOfHalf, LastDateOfHalf, DayOfHalf, DayOfHalfName, YearName, YearShortName
			, YearNumber, FirstDateOfYear, LastDateOfYear, DayOfYear, DayOfYearName, CalendarQuarter
			, CalendarYear, CalendarYearMonth, CalendarYearQtr
			, [FiscalYear], [FiscalWeek], [FiscalPeriod], [FiscalMonth],[FiscalQuarter]
            , [FiscalYearFiscalWeek], [FiscalYearFiscalPeriod], [FiscalYearFiscalMonth],[FiscalYearFiscalQuarter]
            , [FiscalYearFiscalQuarterFiscalMonth], [FiscalYearName], [FiscalYearLongName], [FiscalYearShortName]
            , [FiscalQuarterName], [FiscalQuarterLongName], [FiscalQuarterNameWithYear], [FiscalQuarterLongNameWithYear]
            , [FiscalQuarterShortName], [FiscalQuarterShortNameWithYear], [FiscalMonthName], [FiscalMonthNameWithYear]
            , [FiscalMonthShortName], [FiscalMonthShortNameWithYear], [FiscalMonthCalendarShortName]
            , [FiscalMonthCalendarShortNameWithYear], [FiscalWeekName], [FiscalWeekLongName], [FiscalWeekNameWithYear]
            , [FiscalWeekShortName], [FiscalWeekShortNameWithYear], [FiscalPeriodName]
            , [FiscalPeriodLongName], [FiscalPeriodNameWithYear], [FiscalPeriodLongNameWithYear]
            , [FiscalPeriodShortName], [FiscalPeriodShortNameWithYear])
	VALUES (-2, '12/31/9999', 'NA', 'NA', 'NA'
			, 'NA', 'NA', 'NA', -1, '1/1/1753'
			, '1/1/1753', -1, 'NA', 0, 0, 'NA'
			, 'NA', 'NA', 'NA', -1
			, '1/1/1753', '1/1/1753', -1, 'NA', 0
			, 'NA', 'NA', 'NA', 'NA'
			, -1, '1/1/1753', '1/1/1753', -1, 'NA'
			, 'NA', 'NA', 'NA', 'NA', -1
			, '1/1/1753', '1/1/1753', -1, 'NA', 'NA', 'NA'
			, -1, '1/1/1753', '1/1/1753', -1, 'NA', -1
			, -1, 'NA', 'NA'
			, -1, -1, -1, -1, -1
			, -1, -1, -1, -1
			, -1, 'NA', 'NA', 'NA'
            , '', 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA'
            , 'NA', 'NA', 'NA'
            , 'NA', 'NA')

	-- Cleanup
	-- Reset SET NOCOUNT to OFF.
	SET NOCOUNT OFF

	-- Cleanup temp tables

	-- Return success
	RETURN 0

END
GO
