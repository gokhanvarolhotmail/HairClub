/* CreateDate: 01/08/2021 15:21:54.180 , ModifyDate: 05/12/2021 16:27:52.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bief_dds].[DimDate](
	[DateKey] [int] NOT NULL,
	[FullDate] [date] NULL,
	[ISODate] [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[YearNumber] [smallint] NULL,
	[YearQuarterNumber] [int] NULL,
	[YearMonthNumber] [int] NULL,
	[YearQuarterMonthNumber] [int] NULL,
	[YearWeekNumber] [int] NULL,
	[DateName] [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekName] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekNameWithYear] [char](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekShortName] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekShortNameWithYear] [char](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekNumber] [smallint] NULL,
	[FirstDateOfWeek] [datetime] NULL,
	[LastDateOfWeek] [datetime] NULL,
	[DayOfWeek] [smallint] NULL,
	[DayOfWeekName] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsWeekday] [bit] NULL,
	[IsWeekend] [bit] NULL,
	[MonthName] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthNameWithYear] [char](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthShortName] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthShortNameWithYear] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthNumber] [smallint] NULL,
	[FirstDateOfMonth] [datetime] NULL,
	[LastDateOfMonth] [datetime] NULL,
	[DayOfMonth] [smallint] NULL,
	[DayOfMonthName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsLastDayOfMonth] [bit] NULL,
	[QuarterName] [char](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuarterNameWithYear] [char](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuarterShortName] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuarterShortNameWithYear] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuarterNumber] [smallint] NULL,
	[FirstDateOfQuarter] [datetime] NULL,
	[LastDateOfQuarter] [datetime] NULL,
	[DayOfQuarter] [smallint] NULL,
	[DayOfQuarterName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HalfName] [char](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HalfNameWithYear] [char](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HalfShortName] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HalfShortNameWithYear] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HalfNumber] [smallint] NULL,
	[YearHalfNumber] [int] NULL,
	[FirstDateOfHalf] [datetime] NULL,
	[LastDateOfHalf] [datetime] NULL,
	[DayOfHalf] [smallint] NULL,
	[DayOfHalfName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[YearName] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[YearShortName] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstDateOfYear] [datetime] NULL,
	[LastDateOfYear] [datetime] NULL,
	[DayOfYear] [smallint] NULL,
	[DayOfYearName] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CalendarQuarter] [smallint] NULL,
	[CalendarYear] [smallint] NULL,
	[CalendarYearMonth] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CalendarYearQtr] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalYear] [smallint] NULL,
	[FiscalWeek] [smallint] NULL,
	[FiscalPeriod] [smallint] NULL,
	[FiscalMonth] [smallint] NULL,
	[FiscalQuarter] [smallint] NULL,
	[FiscalYearFiscalWeek] [int] NULL,
	[FiscalYearFiscalPeriod] [int] NULL,
	[FiscalYearFiscalMonth] [int] NULL,
	[FiscalYearFiscalQuarter] [int] NULL,
	[FiscalYearFiscalQuarterFiscalMonth] [int] NULL,
	[FiscalYearName] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalYearLongName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalYearShortName] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalQuarterName] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalQuarterLongName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalQuarterNameWithYear] [char](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalQuarterLongNameWithYear] [char](34) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalQuarterShortName] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalQuarterShortNameWithYear] [char](21) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalMonthName] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalMonthNameWithYear] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalMonthShortName] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalMonthShortNameWithYear] [char](14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalMonthCalendarShortName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalMonthCalendarShortNameWithYear] [char](22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalWeekName] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalWeekLongName] [char](14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalWeekNameWithYear] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalWeekLongNameWithYear] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalWeekShortName] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalWeekShortNameWithYear] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodName] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodLongName] [char](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodNameWithYear] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodLongNameWithYear] [char](22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodShortName] [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalPeriodShortNameWithYear] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[CummWorkdays] [int] NULL,
	[MonthWorkdays] [int] NULL,
	[MonthWorkdaysTotal] [int] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimDate] ON [bief_dds].[DimDate]
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimDate_FullDate] ON [bief_dds].[DimDate]
(
	[FullDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimDate_FullDate_INCL] ON [bief_dds].[DimDate]
(
	[FullDate] ASC
)
INCLUDE([DayOfWeekName],[MonthNumber],[FirstDateOfMonth],[LastDateOfMonth],[DayOfMonth]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
