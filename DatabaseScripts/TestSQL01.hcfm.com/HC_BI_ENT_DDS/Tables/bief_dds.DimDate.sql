/* CreateDate: 05/03/2010 12:08:47.457 , ModifyDate: 09/16/2019 09:25:19.317 */
GO
CREATE TABLE [bief_dds].[DimDate](
	[DateKey] [int] NOT NULL,
	[FullDate] [datetime] NULL,
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
	[MonthWorkdaysTotal] [int] NULL,
 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimDate_FullDate] ON [bief_dds].[DimDate]
(
	[FullDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bief_dds].[DimDate] ADD  CONSTRAINT [MSrepl_tran_version_default_52AC4DAF_092F_44D0_9E39_3F4E8AB9BC32_2105058535]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
EXEC sys.sp_addextendedproperty @name=N'Comments', @value=N'In the form: yyyymmdd' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DateKey' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'20041123' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Full date as a SQL date (time=00:00:00)' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FullDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FullDate' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FullDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/23/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FullDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FullDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'String expression of the full date in ISO format' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ISODate'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'ISODate' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ISODate'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'20041123' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ISODate'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ISODate'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ISODate'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Year Number' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'YearNumber' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'2006,2007,.2100' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'String expression of the full date in users'' favored format' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DateName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/23/2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DateName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Week Name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Week 3' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Week Name With Year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Week 3, 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Week Short Name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekShortName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'WK03' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Week Short Name With Year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekShortNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'WK03 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Week Number' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekNumber' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..52 or 53' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'WeekNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'First Date of the Week' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FirstDateOfWeek' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/23/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Last Date of the Week' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'LastDateOfWeek' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/23/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day of week; Sunday = 1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfWeek' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..7' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeek'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of week' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfWeekName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Sunday' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfWeekName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Is today a weekday' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekday'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'IsWeekday' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekday'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1 or 0' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekday'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekday'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekday'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Is today a weekend' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekend'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'IsWeekend' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekend'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1 or 0' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekend'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekend'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsWeekend'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Month name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'November' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Month name with year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'November, 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Month short name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthShortName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Nov' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Month short name with year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthShortNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/1/2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Month Number' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthNumber' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, ., 12' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'MonthNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'First Date of the Month' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FirstDateOfWeek' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/23/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Last Date of the Month' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FirstDateOfMonth' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11/23/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the month' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfMonth' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..31' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of month' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfMonthName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'November 1st' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfMonthName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the last day of the calendar month?' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsLastDayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'IsLastDayOfMonth' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsLastDayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1 or 0' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsLastDayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsLastDayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'IsLastDayOfMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Quarter 2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter name with year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Quarter 2, 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter short name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterShortName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Q2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter short name with year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterShortNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Q2 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter Number' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterNumber' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, 4' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'QuarterNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'First Date of the Quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FirstDateOfQuarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'4/1/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Last Date of the Quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'LastDateOfQuarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'6/30/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the Quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfQuarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..91' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of Quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfQuarterName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Day 91 of Q2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfQuarterName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Half name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'HalfName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Half 2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Half name with year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'HalfNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Half 2, 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Half short name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'HalfShortName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'H2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Half short name with year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'HalfShortNameWithYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'H2 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfShortNameWithYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Half Number' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'HalfNumber' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'HalfNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'First Date of the Half' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FirstDateOfHalf' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'4/1/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Last Date of the Half' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'LastDateOfHalf' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'6/30/2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the Half' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfHalf' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..184' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalf'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of Half' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfHalfName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'Day 184 of H2' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfHalfName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Year name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'YearName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Year short name' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'YearShortName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'06' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'YearShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'First Date of the Year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FirstDateOfYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/1/2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FirstDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Last Date of the Year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'LastDateOfYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'12/31/2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'LastDateOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..365' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of Year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfYearName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'December 31st, 2006' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYearName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'DayOfYearName'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'CalendarQuarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, 4' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar year' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'CalendarYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar year and month' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'CalendarYearMonth' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'2004-01' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar year and quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearQtr'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'CalendarYearQtr' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearQtr'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'2004Q1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearQtr'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearQtr'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'CalendarYearQtr'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Fiscal year. Fiscal year begins in July.' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FiscalYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'2004' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Fiscal month of year (1..12). FY starts in July' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FiscalMonthOfYear' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, ., 12' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalMonth'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Fiscal quarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'FiscalQuarter' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, 4' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'FiscalQuarter'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Date dimension contains one row for every day, beginning at 1/1/2000. There may also be rows for "hasn''t happened yet."' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Date' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate'
GO
EXEC sys.sp_addextendedproperty @name=N'View Name', @value=N'Date' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimDate'
GO
