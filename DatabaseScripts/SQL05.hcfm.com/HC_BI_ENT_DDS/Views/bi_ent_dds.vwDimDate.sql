/* CreateDate: 05/03/2010 12:08:49.200 , ModifyDate: 04/09/2020 08:32:43.270 */
GO
CREATE VIEW [bi_ent_dds].[vwDimDate]
AS
-------------------------------------------------------------------------
-- [vwDimDate] is used to retrieve a
-- list of Dates
--
--   SELECT * FROM [bi_ent_dds].[vwDimDate]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
--          04/10.2012  EKnapp       Add DateCalcs field
--			07/21/2015  KMurdoch     Added Workdays
-------------------------------------------------------------------------

	SELECT	  DD.[DateKey]
			, DD.[FullDate]
			, CAST(DD.[FullDate] AS DATE) AS 'DateUS'
			, DD.[ISODate]
			, DD.[YearNumber]
			, DD.[YearQuarterNumber]
			, DD.[YearMonthNumber]
			, DD.[YearWeekNumber]
			, DD.[DateName]
			, DD.[WeekName]
			, DD.[WeekNameWithYear]
			, DD.[WeekShortName]
			, DD.[WeekShortNameWithYear]
			, DD.[WeekNumber]
			, DD.[FirstDateOfWeek]
			, DD.[LastDateOfWeek]
			, DD.[DayOfWeek]
			, DD.[DayOfWeekName]
			, DD.[IsWeekday]
			, DD.[IsWeekend]
			, DD.[MonthName]
			, DD.[MonthNameWithYear]
			, DD.[MonthShortName]
			, DD.[MonthShortNameWithYear]
			, DD.[MonthNumber]
			, DD.[FirstDateOfMonth]
			, DD.[LastDateOfMonth]
			, DD.[DayOfMonth]
			, DD.[DayOfMonthName]
			, DD.[IsLastDayOfMonth]
			, DD.[QuarterName]
			, DD.[QuarterNameWithYear]
			, DD.[QuarterShortName]
			, DD.[QuarterShortNameWithYear]
			, DD.[QuarterNumber]
			, DD.[FirstDateOfQuarter]
			, DD.[LastDateOfQuarter]
			, DD.[DayOfQuarter]
			, DD.[DayOfQuarterName]
			, DD.[HalfName]
			, DD.[HalfNameWithYear]
			, DD.[HalfShortName]
			, DD.[HalfShortNameWithYear]
			, DD.[HalfNumber]
			, DD.[YearHalfNumber]
			, DD.[FirstDateOfHalf]
			, DD.[LastDateOfHalf]
			, DD.[DayOfHalf]
			, DD.[DayOfHalfName]
			, DD.[YearName]
			, DD.[YearShortName]
			, DD.[FirstDateOfYear]
			, DD.[LastDateOfYear]
			, DD.[DayOfYear]
			, DD.[DayOfYearName]
			, DD.[CalendarQuarter]
			, DD.[CalendarYear]
			, DD.[CalendarYearMonth]
			, DD.[CalendarYearQtr]
			, DD.[YearQuarterMonthNumber]
			, DD.[FiscalYear]
			, DD.[FiscalQuarter]
			, DD.[FiscalMonth]
			, DD.[FiscalWeek]
			, DD.[FiscalPeriod]
			, DD.[FiscalYearFiscalQuarter]
			, DD.[FiscalYearFiscalQuarterFiscalMonth]
			, DD.[FiscalYearFiscalMonth]
			, DD.[FiscalYearFiscalWeek]
			, DD.[FiscalYearFiscalPeriod]
			, DD.[FiscalYearName]
			, DD.[FiscalYearLongName]
			, DD.[FiscalYearShortName]
			, DD.[FiscalQuarterName]
			, DD.[FiscalQuarterLongName]
			, DD.[FiscalQuarterNameWithYear]
			, DD.[FiscalQuarterLongNameWithYear]
			, DD.[FiscalQuarterShortName]
			, DD.[FiscalQuarterShortNameWithYear]
			, DD.[FiscalMonthName]
			, DD.[FiscalMonthNameWithYear]
			, DD.[FiscalMonthShortName]
			, DD.[FiscalMonthShortNameWithYear]
			, DD.[FiscalMonthCalendarShortName]
			, DD.[FiscalMonthCalendarShortNameWithYear]
			, DD.[FiscalWeekName]
			, DD.[FiscalWeekLongName]
			, DD.[FiscalWeekNameWithYear]
			, DD.[FiscalWeekLongNameWithYear]
			, DD.[FiscalWeekShortName]
			, DD.[FiscalWeekShortNameWithYear]
			, DD.[FiscalPeriodName]
			, DD.[FiscalPeriodLongName]
			, DD.[FiscalPeriodNameWithYear]
			, DD.[FiscalPeriodLongNameWithYear]
			, DD.[FiscalPeriodShortName]
			, DD.[FiscalPeriodShortNameWithYear]
			, DBCD.[Year] AS [BroadcastYear]
			, DBCD.[Quarter] AS [BroadcastQuarter]
			, DBCD.[Month] AS [BroadcastMonth]
			, LTRIM(RTRIM(DBCD.[MonthName])) +', '+ CAST(DBCD.[YEAR] AS VARCHAR(4)) AS [BroadcastMonthName]
			, DBCD.[Week] AS [BroadcastWeek]
			, DBCD.[Day] AS [BroadcastDay]
			, DBCD.BroadcastYearBroadcastQuarter AS [BroadcastYearBroadcastQuarter]
			, DBCD.BroadcastYearBroadcastMonth AS [BroadcastYearBroadcastMonth]
			, DBCD.BroadcastYearBroadcastWeek AS [BroadcastYearBroadcastWeek]
			, DBCD.BroadcastYearQtrMonthWeekDay AS [BroadcastYearQtrMonthWeekDay]
			, DBCD.BroadcastYearQtrMonth AS [BroadcastYearQtrMonth]
			, DBCD.BroadcastYearShortName AS [BroadcastYearShortName]
			, DBCD.BroadcastYearLongName AS [BroadcastYearLongName]
			, DBCD.BroadcastYeartName AS [BroadcastYeartName]
			, DBCD.BroadcastQuarterName AS [BroadcastQuarterName]
			, DBCD.BroadcastWeekName AS [BroadcastWeekName]
			, DBCD.BroadcastDayName AS [BroadcastDayName]
			, DD.[FiscalMonthShortName] + ', ' + DD.[MonthShortNameWithYear] AS [FiscalMonthShortNameAlt]
			, 'Current Period' AS [DateCalcs]
			, DD.CummWorkdays
			, DD1.MonthWorkdays
			, DD1.MonthWorkdaysTotal
		FROM	[bief_dds].[DimDate] DD
			LEFT OUTER JOIN  bi_ent_dds.DimBroadcastDate DBCD
				ON DBCD.DateKey = DD.DateKey
            LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DIMDATE DD1
				ON CONVERT(VARCHAR(8),(LEFT(DD.DATEKEY,6) + '01')) = CONVERT(VARCHAR(8),DD1.DATEKEY)
		--WHERE DD.FullDate  > '12/31/2011'
GO
