/****** Object:  Table [dbo].[DimDate_Temp]    Script Date: 2/10/2022 9:07:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[DimDate_Temp]
(
	[DateKey] [int] NULL,
	[FullDate] [date] NULL,
	[ISODate] [varchar](8000) NULL,
	[YearNumber] [int] NULL,
	[YearQuarterNumber] [int] NULL,
	[YearMonthNumber] [int] NULL,
	[YearQuarterMonthNumber] [int] NULL,
	[YearWeekNumber] [int] NULL,
	[DateName] [varchar](8000) NULL,
	[WeekName] [varchar](8000) NULL,
	[WeekNameWithYear] [varchar](8000) NULL,
	[WeekShortName] [varchar](8000) NULL,
	[WeekShortNameWithYear] [varchar](8000) NULL,
	[WeekNumber] [int] NULL,
	[FirstDateOfWeek] [date] NULL,
	[LastDateOfWeek] [date] NULL,
	[DayOfWeek] [int] NULL,
	[DayOfWeekName] [varchar](8000) NULL,
	[IsWeekday] [bit] NULL,
	[IsWeekend] [bit] NULL,
	[MonthName] [varchar](8000) NULL,
	[MonthNameWithYear] [varchar](8000) NULL,
	[MonthShortName] [varchar](8000) NULL,
	[MonthShortNameWithYear] [varchar](8000) NULL,
	[MonthNumber] [int] NULL,
	[FirstDateOfMonth] [date] NULL,
	[LastDateOfMonth] [date] NULL,
	[DayOfMonth] [int] NULL,
	[DayOfMonthName] [varchar](8000) NULL,
	[IsLastDayOfMonth] [bit] NULL,
	[QuarterName] [varchar](8000) NULL,
	[QuarterNameWithYear] [varchar](8000) NULL,
	[QuarterShortName] [varchar](8000) NULL,
	[QuarterShortNameWithYear] [varchar](8000) NULL,
	[QuarterNumber] [int] NULL,
	[FirstDateOfQuarter] [date] NULL,
	[LastDateOfQuarter] [date] NULL,
	[DayOfQuarter] [int] NULL,
	[DayOfQuarterName] [varchar](8000) NULL,
	[HalfName] [varchar](8000) NULL,
	[HalfNameWithYear] [varchar](8000) NULL,
	[HalfShortName] [varchar](8000) NULL,
	[HalfShortNameWithYear] [varchar](8000) NULL,
	[HalfNumber] [int] NULL,
	[YearHalfNumber] [int] NULL,
	[FirstDateOfHalf] [date] NULL,
	[LastDateOfHalf] [date] NULL,
	[DayOfHalf] [int] NULL,
	[DayOfHalfName] [varchar](8000) NULL,
	[YearName] [varchar](8000) NULL,
	[YearShortName] [varchar](8000) NULL,
	[FirstDateOfYear] [date] NULL,
	[LastDateOfYear] [date] NULL,
	[DayOfYear] [int] NULL,
	[DayOfYearName] [varchar](8000) NULL,
	[CalendarQuarter] [int] NULL,
	[CalendarYear] [int] NULL,
	[CalendarYearMonth] [varchar](8000) NULL,
	[CalendarYearQtr] [varchar](8000) NULL,
	[FiscalYear] [int] NULL,
	[FiscalWeek] [int] NULL,
	[FiscalPeriod] [int] NULL,
	[FiscalMonth] [int] NULL,
	[FiscalQuarter] [int] NULL,
	[FiscalYearFiscalWeek] [int] NULL,
	[FiscalYearFiscalPeriod] [int] NULL,
	[FiscalYearFiscalMonth] [int] NULL,
	[FiscalYearFiscalQuarter] [int] NULL,
	[FiscalYearFiscalQuarterFiscalMonth] [int] NULL,
	[FiscalYearName] [varchar](8000) NULL,
	[FiscalYearLongName] [varchar](8000) NULL,
	[FiscalYearShortName] [varchar](8000) NULL,
	[FiscalQuarterName] [varchar](8000) NULL,
	[FiscalQuarterLongName] [varchar](8000) NULL,
	[FiscalQuarterNameWithYear] [varchar](8000) NULL,
	[FiscalQuarterLongNameWithYear] [varchar](8000) NULL,
	[FiscalQuarterShortName] [varchar](8000) NULL,
	[FiscalQuarterShortNameWithYear] [varchar](8000) NULL,
	[FiscalMonthName] [varchar](8000) NULL,
	[FiscalMonthNameWithYear] [varchar](8000) NULL,
	[FiscalMonthShortName] [varchar](8000) NULL,
	[FiscalMonthShortNameWithYear] [varchar](8000) NULL,
	[FiscalMonthCalendarShortName] [varchar](8000) NULL,
	[FiscalMonthCalendarShortNameWithYear] [varchar](8000) NULL,
	[FiscalWeekName] [varchar](8000) NULL,
	[FiscalWeekLongName] [varchar](8000) NULL,
	[FiscalWeekNameWithYear] [varchar](8000) NULL,
	[FiscalWeekLongNameWithYear] [varchar](8000) NULL,
	[FiscalWeekShortName] [varchar](8000) NULL,
	[FiscalWeekShortNameWithYear] [varchar](8000) NULL,
	[FiscalPeriodName] [varchar](8000) NULL,
	[FiscalPeriodLongName] [varchar](8000) NULL,
	[FiscalPeriodNameWithYear] [varchar](8000) NULL,
	[FiscalPeriodLongNameWithYear] [varchar](8000) NULL,
	[FiscalPeriodShortName] [varchar](8000) NULL,
	[FiscalPeriodShortNameWithYear] [varchar](8000) NULL,
	[CummWorkdays] [int] NULL,
	[MonthWorkdays] [int] NULL,
	[MonthWorkdaysTotal] [int] NULL,
	[IsHoliday] [bit] NULL,
	[MonthOfQuarter] [int] NULL,
	[BroadcastYearBroadcastQuarter] [int] NULL,
	[BroadcastYearBroadcastMonth] [int] NULL,
	[BroadcastYearBroadcastWeek] [int] NULL,
	[BroadcastYearQtrMonthWeekDay] [int] NULL,
	[BroadcastYearQtrMonth] [int] NULL,
	[BroadcastYearShortName] [varchar](8000) NULL,
	[BroadcastYearLongName] [varchar](8000) NULL,
	[BroadcastYeartName] [varchar](8000) NULL,
	[BroadcastQuarterName] [varchar](8000) NULL,
	[BroadcastWeekName] [varchar](8000) NULL,
	[BroadcastDayName] [varchar](8000) NULL,
	[msrepl_tran_version] [varchar](8000) NULL,
	[DWH_LoadDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[SourceSystem] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-file-system-bi-dev_steimdatalakedev_dfs_core_windows_net],LOCATION = N'GenericFiles/DimDate.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
