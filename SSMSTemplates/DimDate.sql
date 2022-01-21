SELECT TOP 10
[DateKey]
, [FullDate]
, [ISODate]
, [YearNumber]
, [YearQuarterNumber]
, [YearMonthNumber]
, [YearQuarterMonthNumber]
, [YearWeekNumber]
, [DateName]
, [WeekName]
, [WeekNameWithYear]
, [WeekShortName]
, [WeekShortNameWithYear]
, [WeekNumber]
, [FirstDateOfWeek]
, [LastDateOfWeek]
, [DayOfWeek]
, [DayOfWeekName]
, [IsWeekday]
, [IsWeekend]
, [MonthName]
, [MonthNameWithYear]
, [MonthShortName]
, [MonthShortNameWithYear]
, [MonthNumber]
, [FirstDateOfMonth]
, [LastDateOfMonth]
, [DayOfMonth]
, [DayOfMonthName]
, [IsLastDayOfMonth]
, [QuarterName]
, [QuarterNameWithYear]
, [QuarterShortName]
, [QuarterShortNameWithYear]
, [QuarterNumber]
, [FirstDateOfQuarter]
, [LastDateOfQuarter]
, [DayOfQuarter]
, [DayOfQuarterName]
, [HalfName]
, [HalfNameWithYear]
, [HalfShortName]
, [HalfShortNameWithYear]
, [HalfNumber]
, [YearHalfNumber]
, [FirstDateOfHalf]
, [LastDateOfHalf]
, [DayOfHalf]
, [DayOfHalfName]
, [YearName]
, [YearShortName]
, [FirstDateOfYear]
, [LastDateOfYear]
, [DayOfYear]
, [DayOfYearName]
, [CalendarQuarter]
, [CalendarYear]
, [CalendarYearMonth]
, [CalendarYearQtr]
, [FiscalYear]
, [FiscalWeek]
, [FiscalPeriod]
, [FiscalMonth]
, [FiscalQuarter]
, [FiscalYearFiscalWeek]
, [FiscalYearFiscalPeriod]
, [FiscalYearFiscalMonth]
, [FiscalYearFiscalQuarter]
, [FiscalYearFiscalQuarterFiscalMonth]
, [FiscalYearName]
, [FiscalYearLongName]
, [FiscalYearShortName]
, [FiscalQuarterName]
, [FiscalQuarterLongName]
, [FiscalQuarterNameWithYear]
, [FiscalQuarterLongNameWithYear]
, [FiscalQuarterShortName]
, [FiscalQuarterShortNameWithYear]
, [FiscalMonthName]
, [FiscalMonthNameWithYear]
, [FiscalMonthShortName]
, [FiscalMonthShortNameWithYear]
, [FiscalMonthCalendarShortName]
, [FiscalMonthCalendarShortNameWithYear]
, [FiscalWeekName]
, [FiscalWeekLongName]
, [FiscalWeekNameWithYear]
, [FiscalWeekLongNameWithYear]
, [FiscalWeekShortName]
, [FiscalWeekShortNameWithYear]
, [FiscalPeriodName]
, [FiscalPeriodLongName]
, [FiscalPeriodNameWithYear]
, [FiscalPeriodLongNameWithYear]
, [FiscalPeriodShortName]
, [FiscalPeriodShortNameWithYear]
, [CummWorkdays]
, [MonthWorkdays]
, [MonthWorkdaysTotal]
, [IsHoliday]
, [MonthOfQuarter]
, [BroadcastYearBroadcastQuarter]
, [BroadcastYearBroadcastMonth]
, [BroadcastYearBroadcastWeek]
, [BroadcastYearQtrMonthWeekDay]
, [BroadcastYearQtrMonth]
, [BroadcastYearShortName]
, [BroadcastYearLongName]
, [BroadcastYeartName]
, [BroadcastQuarterName]
, [BroadcastWeekName]
, [BroadcastDayName]
, [msrepl_tran_version]
, [DWH_LoadDate]
, [DWH_LastUpdateDate]
, [SourceSystem]
FROM [dbo].[DimDate] ;

SELECT
    CAST(CONVERT(VARCHAR(30), [Date], 112) AS INT) AS [DateKey]
  , [Date] AS [FullDate]
  , CAST(CONVERT(VARCHAR(30), [Date], 112) AS INT) AS [IsoDate]
  , YEAR([Date]) AS [YearNumber]
  , CAST(CONCAT(YEAR([Date]), RIGHT(CONCAT('0', DATEPART(QUARTER, [Date])), 2)) AS INT) AS [YearQuarterNumber]
  , CAST(CONVERT(VARCHAR(6), [Date], 112) AS INT) AS [YearMonthNumber]
  , CAST(CONCAT(YEAR([Date]), RIGHT(CONCAT('0', DATEPART(QUARTER, [Date])), 2), RIGHT(CONCAT('0', DATEPART(MONTH, [Date])), 2)) AS INT) AS [YearQuarterMonthNumber]
  , CAST(CONCAT(YEAR([Date]), RIGHT(CONCAT('0', DATEPART(WEEK, [Date])), 2)) AS INT) AS [YearWeekNumber]
  , REPLACE(CONVERT(VARCHAR(30), [Date], 6), ' ', '-') AS [DateName]
  , CONCAT('Week ', DATEPART(WEEK, [Date])) AS [WeekName]
  , CONCAT('Week ', DATEPART(WEEK, [Date]), ', ', YEAR([Date])) AS [WeekNameWithYear]
  , CONCAT('WK', RIGHT(CONCAT('0', DATEPART(WEEK, [Date])), 2)) AS [WeekShortName]
  , CONCAT('WK', RIGHT(CONCAT('0', DATEPART(WEEK, [Date])), 2), ' ', YEAR([Date])) AS [WeekNameShortNameWithYear]
  , DATEPART(WEEK, [Date]) AS [WeekNumber]
  , DATEADD(dd, -( DATEPART(dw, [Date]) - 1 ), [Date]) AS [FirstDateOfWeek]
  , DATEADD(dd, 7 - ( DATEPART(dw, [Date])), [Date]) AS [LastDateOfWeek]
  , DATEPART(WEEKDAY, [Date]) AS [DayOfWeek]
  , DATENAME(WEEKDAY, [Date]) AS [DayOfWeekName]
  , CASE WHEN DATEPART(WEEKDAY, [Date]) IN (1, 7) THEN 0 ELSE 1 END AS [IsWeekDay]
  , CASE WHEN DATEPART(WEEKDAY, [Date]) IN (1, 7) THEN 1 ELSE 0 END AS [IsWeekend]
  , DATENAME(MONTH, [Date]) AS [MonthName]
  , CONCAT(DATENAME(MONTH, [Date]), ', ', YEAR([Date])) AS [MonthNameWithYear]
  , FORMAT([Date], 'MMM') AS [MonthShortName]
  , FORMAT([Date], 'MMM yyyy') AS [MonthShortNameWithYear]
  , DATEPART(MONTH, [Date]) AS [MonthNumber]
  , DATEADD(MONTH, DATEDIFF(MONTH, 0, [Date]), 0) AS [FirstDateOfMonth]
  , DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, [Date]) + 1, 0)) AS [LastDateOfMonth]
  , DAY([Date]) AS [DayOfMonth]
  , FORMAT([Date], 'MMMM d') AS [DayOfMonthName]
  , CASE WHEN [Date] = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, [Date]) + 1, 0)) THEN 1 ELSE 0 END AS [IsLastDayOfMonth]
  , CONCAT('Quarter ', DATEPART(QUARTER, [Date])) AS [QuarterName]
  , CONCAT('Quarter ', DATEPART(QUARTER, [Date]), ', ', YEAR([Date])) AS [QuarterNameWithYear]
  , CONCAT('Q', DATEPART(QUARTER, [Date])) AS [QuarterShortName]
  , CONCAT('Q', DATEPART(QUARTER, [Date]), ', ', YEAR([Date])) AS [QuarterShortNameWithYear]
  , DATEPART(QUARTER, [Date]) AS [QuarterNumber]
  , DATEADD(qq, DATEDIFF(qq, 0, [Date]), 0) AS [FirstDateOfQuarter]
  , DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, [Date]) + 1, 0)) AS [LastDateOfQuarter]
  , DATEDIFF(d, DATEADD(qq, DATEDIFF(qq, 0, [Date]), 0), [Date]) + 1 AS [DayOfQuarter]
  , CONCAT('Day ', DATEDIFF(d, DATEADD(qq, DATEDIFF(qq, 0, [Date]), 0), [Date]) + 1, ' of Q', DATEPART(QUARTER, [Date])) AS [DayOfQuarterName]
  --, 'HalfName' AS [HalfName]
  --, 'HalfNameWithYear' AS [HalfNameWithYear]
  --, 'HalfShortName' AS [HalfShortName]
  --, 'HalfShortNameWithYear' AS [HalfShortNameWithYear]
  --, 'HalfNumber' AS [HalfNumber]
  --, 'YearHalfNumber' AS [YearHalfNumber]
  --, 'FirstDateOfHalf' AS [FirstDateOfHalf]
  --, 'LastDateOfHalf' AS [LastDateOfHalf]
  --, 'DayOfHalf' AS [DayOfHalf]
  --, 'DayOfHalfName' AS [DayOfHalfName]
  --, 'YearName' AS [YearName]
  --, 'YearShortName' AS [YearShortName]
  --, 'FirstDateOfYear' AS [FirstDateOfYear]
  --, 'LastDateOfYear' AS [LastDateOfYear]
  --, 'DayOfYear' AS [DayOfYear]
  --, 'DayOfYearName' AS [DayOfYearName]
  --, 'CalendarQuarter' AS [CalendarQuarter]
  --, 'CalendarYear' AS [CalendarYear]
  --, 'CalendarYearMonth' AS [CalendarYearMonth]
  --, 'CalendarYearQtr' AS [CalendarYearQtr]
  --, 'FiscalYear' AS [FiscalYear]
  --, 'FiscalWeek' AS [FiscalWeek]
  --, 'FiscalPeriod' AS [FiscalPeriod]
  --, 'FiscalMonth' AS [FiscalMonth]
  --, 'FiscalQuarter' AS [FiscalQuarter]
  --, 'FiscalYearFiscalWeek' AS [FiscalYearFiscalWeek]
  --, 'FiscalYearFiscalPeriod' AS [FiscalYearFiscalPeriod]
  --, 'FiscalYearFiscalMonth' AS [FiscalYearFiscalMonth]
  --, 'FiscalYearFiscalQuarter' AS [FiscalYearFiscalQuarter]
  --, 'FiscalYearFiscalQuarterFiscalMonth' AS [FiscalYearFiscalQuarterFiscalMonth]
  --, 'FiscalYearName' AS [FiscalYearName]
  --, 'FiscalYearLongName' AS [FiscalYearLongName]
  --, 'FiscalYearShortName' AS [FiscalYearShortName]
  --, 'FiscalQuarterName' AS [FiscalQuarterName]
  --, 'FiscalQuarterLongName' AS [FiscalQuarterLongName]
  --, 'FiscalQuarterNameWithYear' AS [FiscalQuarterNameWithYear]
  --, 'FiscalQuarterLongNameWithYear' AS [FiscalQuarterLongNameWithYear]
  --, 'FiscalQuarterShortName' AS [FiscalQuarterShortName]
  --, 'FiscalQuarterShortNameWithYear' AS [FiscalQuarterShortNameWithYear]
  --, 'FiscalMonthName' AS [FiscalMonthName]
  --, 'FiscalMonthNameWithYear' AS [FiscalMonthNameWithYear]
  --, 'FiscalMonthShortName' AS [FiscalMonthShortName]
  --, 'FiscalMonthShortNameWithYear' AS [FiscalMonthShortNameWithYear]
  --, 'FiscalMonthCalendarShortName' AS [FiscalMonthCalendarShortName]
  --, 'FiscalMonthCalendarShortNameWithYear' AS [FiscalMonthCalendarShortNameWithYear]
  --, 'FiscalWeekName' AS [FiscalWeekName]
  --, 'FiscalWeekLongName' AS [FiscalWeekLongName]
  --, 'FiscalWeekNameWithYear' AS [FiscalWeekNameWithYear]
  --, 'FiscalWeekLongNameWithYear' AS [FiscalWeekLongNameWithYear]
  --, 'FiscalWeekShortName' AS [FiscalWeekShortName]
  --, 'FiscalWeekShortNameWithYear' AS [FiscalWeekShortNameWithYear]
  --, 'FiscalPeriodName' AS [FiscalPeriodName]
  --, 'FiscalPeriodLongName' AS [FiscalPeriodLongName]
  --, 'FiscalPeriodNameWithYear' AS [FiscalPeriodNameWithYear]
  --, 'FiscalPeriodLongNameWithYear' AS [FiscalPeriodLongNameWithYear]
  --, 'FiscalPeriodShortName' AS [FiscalPeriodShortName]
  --, 'FiscalPeriodShortNameWithYear' AS [FiscalPeriodShortNameWithYear]
  --, 'CummWorkdays' AS [CummWorkdays]
  --, 'MonthWorkdays' AS [MonthWorkdays]
  --, 'MonthWorkdaysTotal' AS [MonthWorkdaysTotal]
  , [IsHolidayUSA] AS [IsHoliday]
  --, 'MonthOfQuarter' AS [MonthOfQuarter]
  --, 'BroadcastYearBroadcastQuarter' AS [BroadcastYearBroadcastQuarter]
  --, 'BroadcastYearBroadcastMonth' AS [BroadcastYearBroadcastMonth]
  --, 'BroadcastYearBroadcastWeek' AS [BroadcastYearBroadcastWeek]
  --, 'BroadcastYearQtrMonthWeekDay' AS [BroadcastYearQtrMonthWeekDay]
  --, 'BroadcastYearQtrMonth' AS [BroadcastYearQtrMonth]
  --, 'BroadcastYearShortName' AS [BroadcastYearShortName]
  --, 'BroadcastYearLongName' AS [BroadcastYearLongName]
  --, 'BroadcastYeartName' AS [BroadcastYeartName]
  --, 'BroadcastQuarterName' AS [BroadcastQuarterName]
  --, 'BroadcastWeekName' AS [BroadcastWeekName]
  --, 'BroadcastDayName' AS [BroadcastDayName]
  , '44FA08F6-9371-4C5B-AC15-098FF361F92D' AS [msrepl_tran_version]
  , GETDATE() AS [DWH_LoadDate]
  , GETDATE() AS [DWH_LastUpdateDate]
  , 'DWH' AS [SourceSystem]
FROM [dw].[DimDate] ;