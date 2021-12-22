/* CreateDate: 10/03/2019 23:03:43.590 , ModifyDate: 10/03/2019 23:03:43.590 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimDate]
AS
-------------------------------------------------------------------------
-- [vwDimDate] is used to retrieve a
-- list of Dates
--
--   SELECT * FROM [bi_cms_dds].[vwDimDate]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT
	DD1.DATEKEY,
	DD.[DateKey] AS DDATEKEY
			, DD.[FullDate]
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
			, DBCD.[MonthName] AS [BroadcastMonthName]
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
		FROM	[HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
			LEFT OUTER JOIN  [bi_cms_dds].[synHC_ENT_DDS_DimBroadcastDate] DBCD
				ON DBCD.DateKey = DD.DateKey
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DIMDATE DD1
				ON LEFT(DBCD.DATEKEY,6) + '01' = DD1.DATEKEY
GO
