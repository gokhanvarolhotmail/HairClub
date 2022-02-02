CREATE TABLE [bief_dds].[DimDate]
(
    [DateKey]                              [INT]              NOT NULL
  , [FullDate]                             [DATE]             NULL
  , [ISODate]                              [CHAR](12)         NULL
  , [YearNumber]                           [SMALLINT]         NULL
  , [YearQuarterNumber]                    [INT]              NULL
  , [YearMonthNumber]                      [INT]              NULL
  , [YearQuarterMonthNumber]               [INT]              NULL
  , [YearWeekNumber]                       [INT]              NULL
  , [DateName]                             [CHAR](12)         NULL
  , [WeekName]                             [CHAR](7)          NULL
  , [WeekNameWithYear]                     [CHAR](13)         NULL
  , [WeekShortName]                        [CHAR](4)          NULL
  , [WeekShortNameWithYear]                [CHAR](9)          NULL
  , [WeekNumber]                           [SMALLINT]         NULL
  , [FirstDateOfWeek]                      [DATETIME]         NULL
  , [LastDateOfWeek]                       [DATETIME]         NULL
  , [DayOfWeek]                            [SMALLINT]         NULL
  , [DayOfWeekName]                        [CHAR](10)         NULL
  , [IsWeekday]                            [BIT]              NULL
  , [IsWeekend]                            [BIT]              NULL
  , [MonthName]                            [CHAR](10)         NULL
  , [MonthNameWithYear]                    [CHAR](15)         NULL
  , [MonthShortName]                       [CHAR](3)          NULL
  , [MonthShortNameWithYear]               [CHAR](8)          NULL
  , [MonthNumber]                          [SMALLINT]         NULL
  , [FirstDateOfMonth]                     [DATETIME]         NULL
  , [LastDateOfMonth]                      [DATETIME]         NULL
  , [DayOfMonth]                           [SMALLINT]         NULL
  , [DayOfMonthName]                       [CHAR](16)         NULL
  , [IsLastDayOfMonth]                     [BIT]              NULL
  , [QuarterName]                          [CHAR](9)          NULL
  , [QuarterNameWithYear]                  [CHAR](15)         NULL
  , [QuarterShortName]                     [CHAR](2)          NULL
  , [QuarterShortNameWithYear]             [CHAR](7)          NULL
  , [QuarterNumber]                        [SMALLINT]         NULL
  , [FirstDateOfQuarter]                   [DATETIME]         NULL
  , [LastDateOfQuarter]                    [DATETIME]         NULL
  , [DayOfQuarter]                         [SMALLINT]         NULL
  , [DayOfQuarterName]                     [CHAR](16)         NULL
  , [HalfName]                             [CHAR](9)          NULL
  , [HalfNameWithYear]                     [CHAR](15)         NULL
  , [HalfShortName]                        [CHAR](2)          NULL
  , [HalfShortNameWithYear]                [CHAR](7)          NULL
  , [HalfNumber]                           [SMALLINT]         NULL
  , [YearHalfNumber]                       [INT]              NULL
  , [FirstDateOfHalf]                      [DATETIME]         NULL
  , [LastDateOfHalf]                       [DATETIME]         NULL
  , [DayOfHalf]                            [SMALLINT]         NULL
  , [DayOfHalfName]                        [CHAR](16)         NULL
  , [YearName]                             [CHAR](4)          NULL
  , [YearShortName]                        [CHAR](2)          NULL
  , [FirstDateOfYear]                      [DATETIME]         NULL
  , [LastDateOfYear]                       [DATETIME]         NULL
  , [DayOfYear]                            [SMALLINT]         NULL
  , [DayOfYearName]                        [CHAR](20)         NULL
  , [CalendarQuarter]                      [SMALLINT]         NULL
  , [CalendarYear]                         [SMALLINT]         NULL
  , [CalendarYearMonth]                    [CHAR](7)          NULL
  , [CalendarYearQtr]                      [CHAR](7)          NULL
  , [FiscalYear]                           [SMALLINT]         NULL
  , [FiscalWeek]                           [SMALLINT]         NULL
  , [FiscalPeriod]                         [SMALLINT]         NULL
  , [FiscalMonth]                          [SMALLINT]         NULL
  , [FiscalQuarter]                        [SMALLINT]         NULL
  , [FiscalYearFiscalWeek]                 [INT]              NULL
  , [FiscalYearFiscalPeriod]               [INT]              NULL
  , [FiscalYearFiscalMonth]                [INT]              NULL
  , [FiscalYearFiscalQuarter]              [INT]              NULL
  , [FiscalYearFiscalQuarterFiscalMonth]   [INT]              NULL
  , [FiscalYearName]                       [CHAR](4)          NULL
  , [FiscalYearLongName]                   [CHAR](16)         NULL
  , [FiscalYearShortName]                  [CHAR](6)          NULL
  , [FiscalQuarterName]                    [CHAR](1)          NULL
  , [FiscalQuarterLongName]                [CHAR](16)         NULL
  , [FiscalQuarterNameWithYear]            [CHAR](7)          NULL
  , [FiscalQuarterLongNameWithYear]        [CHAR](34)         NULL
  , [FiscalQuarterShortName]               [CHAR](3)          NULL
  , [FiscalQuarterShortNameWithYear]       [CHAR](21)         NULL
  , [FiscalMonthName]                      [CHAR](2)          NULL
  , [FiscalMonthNameWithYear]              [CHAR](8)          NULL
  , [FiscalMonthShortName]                 [CHAR](4)          NULL
  , [FiscalMonthShortNameWithYear]         [CHAR](14)         NULL
  , [FiscalMonthCalendarShortName]         [CHAR](16)         NULL
  , [FiscalMonthCalendarShortNameWithYear] [CHAR](22)         NULL
  , [FiscalWeekName]                       [CHAR](2)          NULL
  , [FiscalWeekLongName]                   [CHAR](14)         NULL
  , [FiscalWeekNameWithYear]               [CHAR](8)          NULL
  , [FiscalWeekLongNameWithYear]           [CHAR](20)         NULL
  , [FiscalWeekShortName]                  [CHAR](4)          NULL
  , [FiscalWeekShortNameWithYear]          [CHAR](10)         NULL
  , [FiscalPeriodName]                     [CHAR](2)          NULL
  , [FiscalPeriodLongName]                 [CHAR](16)         NULL
  , [FiscalPeriodNameWithYear]             [CHAR](8)          NULL
  , [FiscalPeriodLongNameWithYear]         [CHAR](22)         NULL
  , [FiscalPeriodShortName]                [CHAR](4)          NULL
  , [FiscalPeriodShortNameWithYear]        [CHAR](10)         NULL
  , [msrepl_tran_version]                  [UNIQUEIDENTIFIER] NOT NULL
  , [CummWorkdays]                         [INT]              NULL
  , [MonthWorkdays]                        [INT]              NULL
  , [MonthWorkdaysTotal]                   [INT]              NULL
  , CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED( [DateKey] ASC )WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON )ON [PRIMARY]
)ON [PRIMARY] ;
GO

/****** Object:  Index [IDX_DimDate_FullDate]    Script Date: 2/1/2022 7:22:08 PM ******/
CREATE NONCLUSTERED INDEX [IDX_DimDate_FullDate]
ON [bief_dds].[DimDate]( [FullDate] ASC )
WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON )
ON [PRIMARY] ;
GO

ALTER TABLE [bief_dds].[DimDate] ADD CONSTRAINT [MSrepl_tran_version_default_52AC4DAF_092F_44D0_9E39_3F4E8AB9BC32_2105058535] DEFAULT( NEWID())FOR [msrepl_tran_version] ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Comments'
  , @value = N'In the form: yyyymmdd'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateKey' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Surrogate primary key'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateKey' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DateKey'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateKey' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'20041123'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateKey' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateKey' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Full date as a SQL date (time=00:00:00)'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FullDate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FullDate'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FullDate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/23/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FullDate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FullDate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'String expression of the full date in ISO format'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'ISODate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'ISODate'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'ISODate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'20041123'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'ISODate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'ISODate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'ISODate' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Year Number'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'YearNumber'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'2006,2007,.2100'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'String expression of the full date in users'' favored format'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DateName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/23/2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DateName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Week Name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'WeekName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Week 3'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Week Name With Year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'WeekNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Week 3, 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Week Short Name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'WeekShortName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'WK03'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Week Short Name With Year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'WeekShortNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'WK03 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Week Number'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'WeekNumber'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1..52 or 53'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'WeekNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'First Date of the Week'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FirstDateOfWeek'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/23/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Last Date of the Week'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'LastDateOfWeek'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/23/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Number of the day of week; Sunday = 1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfWeek'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1..7'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeek' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Day name of week'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfWeekName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Sunday'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfWeekName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Is today a weekday'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekday' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'IsWeekday'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekday' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1 or 0'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekday' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekday' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekday' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Is today a weekend'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekend' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'IsWeekend'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekend' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1 or 0'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekend' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekend' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsWeekend' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Month name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'MonthName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'November'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Month name with year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'MonthNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'November, 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Month short name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'MonthShortName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Nov'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Month short name with year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'MonthShortNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/1/2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Month Number'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'MonthNumber'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1, 2, ., 12'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'MonthNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'First Date of the Month'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FirstDateOfWeek'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/23/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Last Date of the Month'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FirstDateOfMonth'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'11/23/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Number of the day in the month'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfMonth'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1..31'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Day name of month'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfMonthName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'November 1st'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfMonthName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Is this the last day of the calendar month?'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsLastDayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'IsLastDayOfMonth'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsLastDayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1 or 0'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsLastDayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsLastDayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'IsLastDayOfMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Quarter name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'QuarterName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Quarter 2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Quarter name with year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'QuarterNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Quarter 2, 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Quarter short name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'QuarterShortName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Q2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Quarter short name with year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'QuarterShortNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Q2 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Quarter Number'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'QuarterNumber'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1, 2, 3, 4'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'QuarterNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'First Date of the Quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FirstDateOfQuarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'4/1/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Last Date of the Quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'LastDateOfQuarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'6/30/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Number of the day in the Quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfQuarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1..91'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Day name of Quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfQuarterName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Day 91 of Q2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfQuarterName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Half name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'HalfName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Half 2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Half name with year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'HalfNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Half 2, 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Half short name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'HalfShortName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'H2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Half short name with year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'HalfShortNameWithYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'H2 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfShortNameWithYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Half Number'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'HalfNumber'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1, 2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'HalfNumber' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'First Date of the Half'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FirstDateOfHalf'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'4/1/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Last Date of the Half'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'LastDateOfHalf'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'6/30/2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Number of the day in the Half'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfHalf'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1..184'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalf' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Day name of Half'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfHalfName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'Day 184 of H2'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfHalfName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Year name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'YearName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Year short name'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'YearShortName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'06'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'YearShortName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'First Date of the Year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FirstDateOfYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1/1/2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FirstDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Last Date of the Year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'LastDateOfYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'12/31/2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'LastDateOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Number of the day in the year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1..365'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Day name of Year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'DayOfYearName'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'December 31st, 2006'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'DayOfYearName' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Calendar quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'CalendarQuarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1, 2, 3, 4'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Calendar year'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'CalendarYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Calendar year and month'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'CalendarYearMonth'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'2004-01'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Calendar year and quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearQtr' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'CalendarYearQtr'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearQtr' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'2004Q1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearQtr' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearQtr' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'CalendarYearQtr' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Fiscal year. Fiscal year begins in July.'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FiscalYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'2004'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalYear' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Fiscal month of year (1..12). FY starts in July'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FiscalMonthOfYear'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1, 2, ., 12'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalMonth' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Fiscal quarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Display Name'
  , @value = N'FiscalQuarter'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Example Values'
  , @value = N'1, 2, 3, 4'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'SCD  Type'
  , @value = N'1'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Source System'
  , @value = N'Derived'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate'
  , @level2type = N'COLUMN'
  , @level2name = N'FiscalQuarter' ;
GO

EXEC [sys].[sp_addextendedproperty]
    @name = N'Description'
  , @value = N'Date dimension contains one row for every day, beginning at 1/1/2000. There may also be rows for "hasn''t happened yet."'
  , @level0type = N'SCHEMA'
  , @level0name = N'bief_dds'
  , @level1type = N'TABLE'
  , @level1name = N'DimDate' ;
GO

EXEC [sys].[sp_addextendedproperty] @name = N'Display Name', @value = N'Date', @level0type = N'SCHEMA', @level0name = N'bief_dds', @level1type = N'TABLE', @level1name = N'DimDate' ;
GO

EXEC [sys].[sp_addextendedproperty] @name = N'Table Type', @value = N'Dimension', @level0type = N'SCHEMA', @level0name = N'bief_dds', @level1type = N'TABLE', @level1name = N'DimDate' ;
GO

EXEC [sys].[sp_addextendedproperty] @name = N'View Name', @value = N'Date', @level0type = N'SCHEMA', @level0name = N'bief_dds', @level1type = N'TABLE', @level1name = N'DimDate' ;
GO

CREATE PROCEDURE [bief_dds].[DDS_DimDate_Populate]
    @StartDate DATETIME = '07/01/2008'
  , @EndDate   DATETIME = '07/01/2009'
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

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON ;

SET XACT_ABORT ON ;

BEGIN TRANSACTION ;

--DELETE [bief_dds].[DimDate]

--INSERT INTO [bief_dds].[DimDate] (DateKey, FullDate, DateName, ISODate, WeekName, WeekNameWithYear, WeekShortName, WeekShortNameWithYear, WeekNumber, FirstDateOfWeek, LastDateOfWeek, DayOfWeek, DayOfWeekName, IsWeekday, IsWeekend, MonthName, MonthNameWithYear, MonthShortName, MonthShortNameWithYear, MonthNumber, FirstDateOfMonth, LastDateOfMonth, DayOfMonth, DayOfMonthName, IsLastDayOfMonth, QuarterName, QuarterNameWithYear, QuarterShortName, QuarterShortNameWithYear, QuarterNumber, FirstDateOfQuarter, LastDateOfQuarter, DayOfQuarter, DayOfQuarterName, HalfName, HalfNameWithYear, HalfShortName, HalfShortNameWithYear, HalfNumber, FirstDateOfHalf, LastDateOfHalf, DayOfHalf, DayOfHalfName, YearName, YearShortName, YearNumber, FirstDateOfYear, LastDateOfYear, DayOfYear, DayOfYearName, CalendarQuarter, CalendarYear, CalendarYearMonth, CalendarYearQtr, FiscalMonth, FiscalQuarter, FiscalYear)
--VALUES (-1, '1/1/1753', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 0, 0, 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 0, 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 'Unknown', 'Unknown', 'NA', 'Unknown', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', 'NA', 'NA', -1, '1/1/1753', '1/1/1753', -1, 'Unknown', -1, -1, 'Unknown', 'Unknown', -1, -1, -1)
DECLARE
    @DateKey                              INT
  , @FullDate                             DATETIME
  , @DateName                             CHAR(12)
  , @ISODate                              CHAR(8)
  , @WeekName                             VARCHAR(7)
  , @WeekNameWithYear                     VARCHAR(13)
  , @WeekShortName                        CHAR(4)
  , @WeekShortNameWithYear                CHAR(9)
  , @WeekNumber                           TINYINT
  , @FirstDateOfWeek                      AS DATETIME
  , @LastDateOfWeek                       AS DATETIME
  , @DayOfWeek                            TINYINT
  , @DayOfWeekName                        VARCHAR(9)
  , @IsWeekday                            BIT
  , @IsWeekend                            BIT
  , @YearNumberWeekNumber                 INT
  , @YearNumberMonthNumber                INT
  , @YearNumberQuarterNumber              INT
  , @YearQuarterMonthNumber               INT
  , @YearNumberHalfNumber                 INT
  , @MonthName                            VARCHAR(9)
  , @MonthNameWithYear                    VARCHAR(15)
  , @MonthShortName                       VARCHAR(3)
  , @MonthShortNameWithYear               CHAR(8)
  , @MonthNumber                          TINYINT
  , @FirstDateOfMonth                     AS DATETIME
  , @LastDateOfMonth                      AS DATETIME
  , @DayOfMonth                           TINYINT
  , @DayOfMonthName                       VARCHAR(16)
  , @IsLastDayOfMonth                     BIT
  , @QuarterName                          CHAR(9)
  , @QuarterNameWithYear                  CHAR(15)
  , @QuarterShortName                     CHAR(2)
  , @QuarterShortNameWithYear             CHAR(7)
  , @QuarterNumber                        TINYINT
  , @FirstDateOfQuarter                   AS DATETIME
  , @LastDateOfQuarter                    AS DATETIME
  , @DayOfQuarter                         TINYINT
  , @DayOfQuarterName                     VARCHAR(20)
  , @HalfName                             CHAR(6)
  , @HalfNameWithYear                     CHAR(12)
  , @HalfShortName                        CHAR(2)
  , @HalfShortNameWithYear                CHAR(7)
  , @HalfNumber                           TINYINT
  , @FirstDateOfHalf                      AS DATETIME
  , @LastDateOfHalf                       AS DATETIME
  , @DayOfHalf                            TINYINT
  , @DayOfHalfName                        VARCHAR(20)
  , @YearName                             CHAR(4)
  , @YearShortName                        CHAR(2)
  , @YearNumber                           SMALLINT
  , @FirstDateOfYear                      AS DATETIME
  , @LastDateOfYear                       AS DATETIME
  , @DayOfYear                            SMALLINT
  , @DayOfYearName                        VARCHAR(20)
  , @CalendarQuarter                      TINYINT
  , @CalendarYear                         SMALLINT
  , @CalendarYearMonth                    CHAR(7)
  , @CalendarYearQtr                      CHAR(7)
  , @FiscalYear                           SMALLINT
  , @FiscalWeek                           SMALLINT
  , @FiscalMonth                          SMALLINT
  , @FiscalPeriod                         SMALLINT
  , @FiscalQuarter                        SMALLINT
  , @FYFiscalWeek                         INT
  , @FYFiscalMonth                        INT
  , @FYFiscaPeriod                        INT
  , @FYFiscalQuarter                      INT
  , @FYFQFiscalMonth                      INT
  , @FiscalYearName                       VARCHAR(4)
  , @FiscalYearLongName                   VARCHAR(16)
  , @FiscalYearShortName                  VARCHAR(6)
  , @FiscalQuarterName                    VARCHAR(1)
  , @FiscalQuarterLongName                VARCHAR(16)
  , @FiscalQuarterNameWithYear            VARCHAR(7)
  , @FiscalQuarterLongNameWithYear        VARCHAR(34)
  , @FiscalQuarterShortName               VARCHAR(3)
  , @FiscalQuarterShortNameWithYear       VARCHAR(21)
  , @FiscalMonthName                      VARCHAR(2)
  , @FiscalMonthNameWithYear              VARCHAR(8)
  , @FiscalMonthShortName                 VARCHAR(4)
  , @FiscalMonthShortNameWithYear         VARCHAR(14)
  , @FiscalMonthCalendarShortName         VARCHAR(16)
  , @FiscalMonthCalendarShortNameWithYear VARCHAR(22)
  , @FiscalYearWeekName                   VARCHAR(8)
  , @FiscalYearMonthName                  VARCHAR(9)
  , @FiscalYearQuarterName                VARCHAR(8)
  , @FiscalWeekName                       VARCHAR(2)
  , @FiscalWeekLongName                   VARCHAR(14)
  , @FiscalWeekNameWithYear               VARCHAR(8)
  , @FiscalWeekLongNameWithYear           VARCHAR(20)
  , @FiscalWeekShortName                  VARCHAR(4)
  , @FiscalWeekShortNameWithYear          VARCHAR(10)
  , @FiscalPeriodName                     VARCHAR(2)
  , @FiscalPeriodLongName                 VARCHAR(16)
  , @FiscalPeriodNameWithYear             VARCHAR(8)
  , @FiscalPeriodLongNameWithYear         VARCHAR(22)
  , @FiscalPeriodShortName                VARCHAR(4)
  , @FiscalPeriodShortNameWithYear        VARCHAR(10) ;

SET @FullDate = @StartDate ;

WHILE DATEDIFF(DAY, @FullDate, @EndDate) >= 0
    BEGIN
        --  This will give sequential number 1,2,3
        --SET @DateKey = DateDiff(day,@StartDate,@EndDate) - DateDiff(day,@FullDate,@EndDate) + 1
        -- This will give sequential number in format yyyymmdd 
        SET @DateKey = CAST(CONVERT(CHAR(8), @FullDate, 112) AS INT) ;
        SET @ISODate = CONVERT(CHAR(8), @FullDate, 112) ;
        SET @DateName = CONVERT(CHAR(12), @FullDate, 107) ;
        SET @YearNumber = DATEPART(yy, @FullDate) ;
        SET @YearName = RIGHT('0000' + CAST(@YearNumber AS VARCHAR(4)), 4) ;
        SET @YearShortName = RIGHT('0000' + CAST(@YearNumber AS VARCHAR(4)), 2) ;
        SET @FirstDateOfYear = CAST(@YearName + '-01-01' AS DATETIME) ;
        SET @LastDateOfYear = CAST(@YearName + '-12-31' AS DATETIME) ;
        SET @DayOfYear = DATEPART(dy, @FullDate) ;
        SET @QuarterNumber = DATEPART(q, @FullDate) ;
        SET @QuarterName = 'Quarter ' + CAST(@QuarterNumber AS CHAR(1)) ;
        SET @QuarterNameWithYear = @QuarterName + ', ' + @YearName ;
        SET @QuarterShortName = 'Q' + CAST(@QuarterNumber AS CHAR(1)) ;
        SET @QuarterShortNameWithYear = @QuarterShortName + ' ' + @YearName ;
        SET @FirstDateOfQuarter = CASE @QuarterNumber WHEN 1 THEN CAST(@YearName + '-01-01' AS DATETIME)WHEN 2 THEN CAST(@YearName + '-04-01' AS DATETIME)WHEN 3 THEN CAST(@YearName + '-07-01' AS DATETIME)WHEN 4 THEN CAST(@YearName + '-10-01' AS DATETIME)END ;
        SET @LastDateOfQuarter = DATEADD(DAY, -1, DATEADD(q, 1, @FirstDateOfQuarter)) ;
        SET @DayOfQuarter = DATEDIFF(DAY, @FirstDateOfQuarter, @FullDate) + 1 ;
        SET @DayOfQuarterName = 'Day ' + CAST(DATEDIFF(DAY, @FirstDateOfQuarter, @FullDate) + 1 AS VARCHAR(2)) + ' of Q' + CAST(@QuarterNumber AS CHAR(1)) ;
        SET @HalfNumber = CASE WHEN DATEPART(q, @FullDate) <= 2 THEN 1 ELSE 2 END ;
        SET @HalfName = 'Half ' + CAST(@HalfNumber AS CHAR(1)) ;
        SET @HalfNameWithYear = @HalfName + ', ' + @YearName ;
        SET @HalfShortName = 'H' + CAST(@HalfNumber AS CHAR(1)) ;
        SET @HalfShortNameWithYear = @HalfShortName + ' ' + @YearName ;
        SET @FirstDateOfHalf = CASE @HalfNumber WHEN 1 THEN CAST(@YearName + '-01-01' AS DATETIME)WHEN 2 THEN CAST(@YearName + '-07-01' AS DATETIME)END ;
        SET @LastDateOfHalf = CASE @HalfNumber WHEN 1 THEN CAST(@YearName + '-06-30' AS DATETIME)WHEN 2 THEN CAST(@YearName + '-12-31' AS DATETIME)END ;
        SET @DayOfHalf = DATEDIFF(DAY, @FirstDateOfHalf, @FullDate) + 1 ;
        SET @DayOfHalfName = 'Day ' + CAST(DATEDIFF(DAY, @FirstDateOfHalf, @FullDate) + 1 AS VARCHAR(3)) + ' of H' + CAST(@HalfNumber AS CHAR(1)) ;
        SET @MonthName = DATENAME(mm, @FullDate) ;
        SET @MonthNameWithYear = @MonthName + ', ' + @YearName ;
        SET @MonthShortName = DATENAME(m, @FullDate) ;
        SET @MonthShortNameWithYear = @MonthShortName + ' ' + @YearName ;
        SET @MonthNumber = DATEPART(m, @FullDate) ;
        SET @FirstDateOfMonth = CAST(@YearName + '-' + @MonthShortName + '-01' AS DATETIME) ;
        SET @LastDateOfMonth = DATEADD(DAY, -1, DATEADD(m, 1, @FirstDateOfMonth)) ;
        SET @DayOfMonth = DATEPART(d, @FullDate) ;
        SET @DayOfMonthName =
            DATENAME(m, @FullDate) + ' ' + CAST(DATEPART(d, @FullDate) AS VARCHAR(2))
            + CASE LEFT(RIGHT('00' + CAST(DATEPART(d, @FullDate) AS VARCHAR(2)), 2), 1)WHEN '1' THEN 'th' ELSE CASE RIGHT(RIGHT('00' + CAST(DATEPART(d, @FullDate) AS VARCHAR(2)), 2), 1)WHEN '1' THEN 'st' WHEN '2' THEN 'nd' WHEN '3' THEN 'rd' ELSE 'th' END END ;
        SET @DayOfYearName = @DayOfMonthName + ', ' + @YearName ;
        SET @WeekName = 'Week ' + DATENAME(wk, @FullDate) ;
        SET @WeekNameWithYear = @WeekName + ', ' + @YearName ;
        SET @WeekShortName = 'WK' + RIGHT('00' + DATENAME(wk, @FullDate), 2) ;
        SET @WeekShortNameWithYear = @WeekShortName + ' ' + @YearName ;
        SET @WeekNumber = DATEPART(wk, @FullDate) ;
        SET @FirstDateOfWeek = DATEADD(DAY, ( DATEPART(dw, @FullDate) - 1 ) * -1, @FullDate) ;
        SET @LastDateOfWeek = DATEADD(DAY, -1, DATEADD(wk, 1, @FirstDateOfWeek)) ;
        SET @DayOfWeek = DATEPART(dw, @FullDate) ;
        SET @DayOfWeekName = DATENAME(dw, @FullDate) ;
        SET @IsWeekday = CASE @DayOfWeek WHEN 1 THEN 0 WHEN 7 THEN 0 ELSE 1 END ;
        SET @IsWeekend = CASE @DayOfWeek WHEN 1 THEN 1 WHEN 7 THEN 1 ELSE 0 END ;
        SET @IsLastDayOfMonth = CASE DATEDIFF(DAY, @FullDate, @LastDateOfMonth)WHEN 0 THEN 1 ELSE 0 END ;
        SET @CalendarQuarter = DATEPART(q, @FullDate) ;
        SET @CalendarYear = DATEPART(yy, @FullDate) ;
        SET @CalendarYearMonth = @YearName + '-' + RIGHT('00' + CAST(DATEPART(m, @FullDate) AS VARCHAR(2)), 2) ;
        SET @CalendarYearQtr = @YearName + @QuarterShortName ;
        SET @YearNumberWeekNumber = CAST(CAST(@YearNumber AS VARCHAR(4)) + RIGHT('00' + CAST(@WeekNumber AS VARCHAR(2)), 2) AS INT) ;
        SET @YearNumberMonthNumber = CAST(CAST(@YearNumber AS VARCHAR(4)) + RIGHT('00' + CAST(@MonthNumber AS VARCHAR(2)), 2) AS INT) ;
        SET @YearNumberQuarterNumber = CAST(CAST(@YearNumber AS VARCHAR(4)) + RIGHT('00' + CAST(@QuarterNumber AS VARCHAR(2)), 2) AS INT) ;
        SET @YearNumberHalfNumber = CAST(CAST(@YearNumber AS VARCHAR(4)) + RIGHT('00' + CAST(@HalfNumber AS VARCHAR(2)), 2) AS INT) ;
        SET @YearQuarterMonthNumber = CAST(CAST(@YearNumber AS VARCHAR(4)) + RIGHT('00' + CAST(@QuarterNumber AS VARCHAR(2)), 2) + RIGHT('00' + CAST(@MonthNumber AS VARCHAR(2)), 2) AS INT) ;

        -- Fiscal Year begins July 1
        SET @FiscalYear = [bief_dds].[DDS_DimDate_FiscalYear](@FullDate) ;
        SET @FiscalWeek = [bief_dds].[DDS_DimDate_FiscalWeek](@FullDate) ;
        SET @FiscalMonth = [bief_dds].[DDS_DimDate_FiscalMonth](@FullDate) ;
        SET @FiscalPeriod = [bief_dds].[DDS_DimDate_FiscalPeriod](@FiscalWeek) ;
        -------SET @FiscalQuarter = FLOOR(@FiscalPeriod / 3.0 + 0.9)
        SET @FiscalQuarter = FLOOR(@FiscalMonth / 3.0 + 0.9) ;
        SET @FYFiscalWeek = CAST(CAST(@FiscalYear AS VARCHAR(4)) + RIGHT('00' + CAST(@FiscalWeek AS VARCHAR(2)), 2) AS INT) ;
        SET @FYFiscalMonth = CAST(CAST(@FiscalYear AS VARCHAR(4)) + RIGHT('00' + CAST(@FiscalMonth AS VARCHAR(2)), 2) AS INT) ;
        SET @FYFiscaPeriod = CAST(CAST(@FiscalYear AS VARCHAR(4)) + RIGHT('00' + CAST(@FiscalPeriod AS VARCHAR(2)), 2) AS INT) ;
        SET @FYFiscalQuarter = CAST(CAST(@FiscalYear AS VARCHAR(4)) + RIGHT('00' + CAST(@FiscalQuarter AS VARCHAR(2)), 2) AS INT) ;
        SET @FYFQFiscalMonth = CAST(CAST(@FiscalYear AS VARCHAR(4)) + RIGHT('00' + CAST(@FiscalQuarter AS VARCHAR(2)), 2) + RIGHT('00' + CAST(@FiscalMonth AS VARCHAR(2)), 2) AS INT) ;
        SET @FiscalYearName = RIGHT('0000' + CAST(@FiscalYear AS VARCHAR(4)), 4) ;
        SET @FiscalYearLongName = 'Fiscal Year ' + RIGHT('0000' + CAST(@FiscalYear AS VARCHAR(4)), 4) ;
        SET @FiscalYearShortName = 'FY' + RIGHT('0000' + CAST(@FiscalYear AS VARCHAR(4)), 4) ;
        SET @FiscalQuarterName = CAST(@FiscalQuarter AS CHAR(1)) ;
        SET @FiscalQuarterLongName = 'Fiscal Quarter ' + CAST(@FiscalQuarter AS CHAR(1)) ;
        SET @FiscalQuarterNameWithYear = @FiscalQuarterName + ', ' + @FiscalYearName ;
        SET @FiscalQuarterLongNameWithYear = @FiscalQuarterLongName + ', ' + @FiscalYearName ;
        SET @FiscalQuarterShortName = 'FQ' + CAST(@FiscalQuarter AS CHAR(1)) ;
        SET @FiscalQuarterShortNameWithYear = @FiscalQuarterShortName + ', ' + @FiscalYearName ;
        SET @FiscalMonthName = RIGHT('00' + CAST(@FiscalMonth AS VARCHAR(2)), 2) ;
        SET @FiscalMonthNameWithYear = @FiscalMonthName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalMonthShortName = 'FM' + RIGHT('00' + CAST(@FiscalMonth AS VARCHAR(2)), 2) ;
        SET @FiscalMonthShortNameWithYear = @FiscalMonthShortName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalMonthCalendarShortName = 'Fiscal ' + DATENAME(mm, @FullDate) ;
        SET @FiscalMonthCalendarShortNameWithYear = @FiscalMonthCalendarShortName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalWeekName = RIGHT('00' + CAST(@FiscalWeek AS VARCHAR(2)), 2) ;
        SET @FiscalWeekLongName = 'Fiscal Week ' + RIGHT('00' + CAST(@FiscalWeek AS VARCHAR(2)), 2) ;
        SET @FiscalWeekNameWithYear = @FiscalWeekName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalWeekLongNameWithYear = @FiscalWeekLongName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalWeekShortName = 'FW' + RIGHT('00' + CAST(@FiscalWeek AS VARCHAR(2)), 2) ;
        SET @FiscalWeekShortNameWithYear = 'FW' + RIGHT('00' + CAST(@FiscalWeek AS VARCHAR(2)), 2) + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalPeriodName = RIGHT('00' + CAST(@FiscalPeriod AS VARCHAR(2)), 2) ;
        SET @FiscalPeriodLongName = 'Fiscal Period ' + RIGHT('00' + CAST(@FiscalPeriod AS VARCHAR(2)), 2) ;
        SET @FiscalPeriodNameWithYear = @FiscalPeriodName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalPeriodLongNameWithYear = @FiscalPeriodLongName + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;
        SET @FiscalPeriodShortName = 'FP' + RIGHT('00' + CAST(@FiscalPeriod AS VARCHAR(2)), 2) ;
        SET @FiscalPeriodShortNameWithYear = 'FP' + RIGHT('00' + CAST(@FiscalPeriod AS VARCHAR(2)), 2) + ', ' + CAST(@FiscalYear AS VARCHAR(4)) ;

        INSERT INTO [bief_dds].[DimDate]( [DateKey]
                                        , [FullDate]
                                        , [DateName]
                                        , [ISODate]
                                        , [WeekName]
                                        , [WeekNameWithYear]
                                        , [WeekShortName]
                                        , [WeekShortNameWithYear]
                                        , [WeekNumber]
                                        , [YearWeekNumber]
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
                                        , [YearMonthNumber]
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
                                        , [YearQuarterNumber]
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
                                        , [YearNumber]
                                        , [FirstDateOfYear]
                                        , [LastDateOfYear]
                                        , [DayOfYear]
                                        , [DayOfYearName]
                                        , [CalendarQuarter]
                                        , [CalendarYear]
                                        , [CalendarYearMonth]
                                        , [CalendarYearQtr]
                                        , [YearQuarterMonthNumber]
                                        , [FiscalYear]
                                        , [FiscalWeek]
                                        , [FiscalPeriod]
                                        , [FiscalMonth]
                                        , [FiscalQuarter]
                                        , [FiscalYearFiscalWeek]
                                        , [FiscalYearFiscalMonth]
                                        , [FiscalYearFiscalPeriod]
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
                                        , [FiscalPeriodShortNameWithYear] )
        VALUES(
                  @DateKey
                , @FullDate
                , @DateName
                , @ISODate
                , @WeekName
                , @WeekNameWithYear
                , @WeekShortName
                , @WeekShortNameWithYear
                , @WeekNumber
                , @YearNumberWeekNumber
                , @FirstDateOfWeek
                , @LastDateOfWeek
                , @DayOfWeek
                , @DayOfWeekName
                , @IsWeekday
                , @IsWeekend
                , @MonthName
                , @MonthNameWithYear
                , @MonthShortName
                , @MonthShortNameWithYear
                , @MonthNumber
                , @YearNumberMonthNumber
                , @FirstDateOfMonth
                , @LastDateOfMonth
                , @DayOfMonth
                , @DayOfMonthName
                , @IsLastDayOfMonth
                , @QuarterName
                , @QuarterNameWithYear
                , @QuarterShortName
                , @QuarterShortNameWithYear
                , @QuarterNumber
                , @YearNumberQuarterNumber
                , @FirstDateOfQuarter
                , @LastDateOfQuarter
                , @DayOfQuarter
                , @DayOfQuarterName
                , @HalfName
                , @HalfNameWithYear
                , @HalfShortName
                , @HalfShortNameWithYear
                , @HalfNumber
                , @YearNumberHalfNumber
                , @FirstDateOfHalf
                , @LastDateOfHalf
                , @DayOfHalf
                , @DayOfHalfName
                , @YearName
                , @YearShortName
                , @YearNumber
                , @FirstDateOfYear
                , @LastDateOfYear
                , @DayOfYear
                , @DayOfYearName
                , @CalendarQuarter
                , @CalendarYear
                , @CalendarYearMonth
                , @CalendarYearQtr
                , @YearQuarterMonthNumber
                , @FiscalYear
                , @FiscalWeek
                , @FiscalPeriod
                , @FiscalMonth
                , @FiscalQuarter
                , @FYFiscalWeek
                , @FYFiscalMonth
                , @FYFiscaPeriod
                , @FYFiscalQuarter
                , @FYFQFiscalMonth
                , @FiscalYearName
                , @FiscalYearLongName
                , @FiscalYearShortName
                , @FiscalQuarterName
                , @FiscalQuarterLongName
                , @FiscalQuarterNameWithYear
                , @FiscalQuarterLongNameWithYear
                , @FiscalQuarterShortName
                , @FiscalQuarterShortNameWithYear
                , @FiscalMonthName
                , @FiscalMonthNameWithYear
                , @FiscalMonthShortName
                , @FiscalMonthShortNameWithYear
                , @FiscalMonthCalendarShortName
                , @FiscalMonthCalendarShortNameWithYear
                , @FiscalWeekName
                , @FiscalWeekLongName
                , @FiscalWeekNameWithYear
                , @FiscalWeekLongNameWithYear
                , @FiscalWeekShortName
                , @FiscalWeekShortNameWithYear
                , @FiscalPeriodName
                , @FiscalPeriodLongName
                , @FiscalPeriodNameWithYear
                , @FiscalPeriodLongNameWithYear
                , @FiscalPeriodShortName
                , @FiscalPeriodShortNameWithYear
              ) ;

        SET @FullDate = DATEADD(DAY, 1, @FullDate) ;
    END ;

COMMIT ;

RETURN 0 ;
GO
