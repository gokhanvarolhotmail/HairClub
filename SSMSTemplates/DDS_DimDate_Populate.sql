CREATE FUNCTION [bief_dds].[DDS_DimDate_FiscalPeriod]( @fiscal_week AS INT )
RETURNS INT
AS
    BEGIN
        DECLARE @fiscal_period INT ;

        -- Determine fiscal period based on 454 454 454 454 pattern.
        IF @fiscal_week >= 1 AND @fiscal_week <= 4
            SET @fiscal_period = 1 ;

        IF @fiscal_week >= 5 AND @fiscal_week <= 9
            SET @fiscal_period = 2 ;

        IF @fiscal_week >= 10 AND @fiscal_week <= 13
            SET @fiscal_period = 3 ;

        IF @fiscal_week >= 14 AND @fiscal_week <= 17
            SET @fiscal_period = 4 ;

        IF @fiscal_week >= 18 AND @fiscal_week <= 22
            SET @fiscal_period = 5 ;

        IF @fiscal_week >= 23 AND @fiscal_week <= 26
            SET @fiscal_period = 6 ;

        IF @fiscal_week >= 27 AND @fiscal_week <= 30
            SET @fiscal_period = 7 ;

        IF @fiscal_week >= 31 AND @fiscal_week <= 35
            SET @fiscal_period = 8 ;

        IF @fiscal_week >= 36 AND @fiscal_week <= 39
            SET @fiscal_period = 9 ;

        IF @fiscal_week >= 40 AND @fiscal_week <= 43
            SET @fiscal_period = 10 ;

        IF @fiscal_week >= 44 AND @fiscal_week <= 47
            SET @fiscal_period = 11 ;

        IF @fiscal_week >= 48 AND @fiscal_week <= 52
            SET @fiscal_period = 12 ;

        RETURN @fiscal_period ;
    END ;
GO
CREATE FUNCTION [bief_dds].[DDS_DimDate_FiscalMonth]( @date AS DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE
            @fiscal_month INT
          , @year         INT
          , @month        INT ;

        SET @month = DATEPART(m, @date) ;
        SET @year = DATEPART(yyyy, @date) ;

        -- Fiscal year starts on July 1.
        -- This will be different for each starting month
        -- if Jan 1 is start then between 1 and 1   +0 and -0   
        -- if Feb 1 is start then between 1 and 1   +11 and -1   
        -- if Mar 1 is start then between 1 and 2   +10 and -2   
        -- if Apr 1 is start then between 1 and 3   +9 and -3   
        -- if May 1 is start then between 1 and 4   +8 and -4    
        -- if Jun 1 is start then between 1 and 5   +7 and -5    
        -- if Jul 1 is start then between 1 and 6   +6 and -6    
        -- if Aug 1 is start then between 1 and 7   +5 and -7    
        -- if Sep 1 is start then between 1 and 8   +4 and -8
        -- if Oct 1 is start then between 1 and 9   +3 and -9
        -- if Nov 1 is start then between 1 and 10  +2 and -10
        -- if Dec 1 is start then between 1 and 11  +1 and -11

        --if @month between 1 and 6 set @fiscal_month = @month + 6
        --else set @fiscal_month = @month - 6
        SET @fiscal_month = @month ;

        RETURN @fiscal_month ;
    END ;
GO
CREATE FUNCTION [bief_dds].[DDS_DimDate_FiscalWeek]( @date AS DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE
            @year              INT
          , @cyear             CHAR(4)
          , @fiscal_start_date DATETIME
          , @fiscal_week       INT ;

        SET @year = DATEPART(yyyy, @date) ;
        SET @cyear = CONVERT(VARCHAR, @year) ;

        -- Fiscal year starts on July 1.
        --if @date >= convert(datetime, convert(varchar,@year)+'-07-01') -- after 7/1
        --  set @fiscal_start_date = convert(datetime, @cyear+'-07-01')
        --else -- before 7/1
        --  set @fiscal_start_date = convert(datetime, convert(varchar,@year-1)+'-07-01')
        SET @fiscal_start_date = CONVERT(DATETIME, @cyear + '-01-01') ;
        SET @fiscal_week = CEILING(( DATEDIFF(d, @fiscal_start_date, @date) + 1 ) / 7.0) ;

        IF @fiscal_week = 53
            SET @fiscal_week = 52 ; -- for 8/31, last day in fiscal year

        RETURN @fiscal_week ;
    END ;
GO
CREATE FUNCTION [bief_dds].[DDS_DimDate_FiscalYear]( @date AS DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE
            @fiscal_year INT
          , @year        INT
          , @month       INT ;

        SET @month = DATEPART(m, @date) ;
        SET @year = DATEPART(yyyy, @date) ;

        -- Fiscal year starts on July 1.
        -- This will be different for each starting month
        -- if Apr 1 is start then between 1 and 3
        -- if Sep 1 is start then between 1 and 8
        -- if Nov 1 is start then between 1 and 10

        --if @month between 1 and 6 set @fiscal_year = @year
        --else set @fiscal_year = @year+1
        SET @fiscal_year = @year ;

        RETURN @fiscal_year ;
    END ;
GO

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
  , CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED( [DateKey] ASC )
) ON [PRIMARY] ;
GO

/****** Object:  Index [IDX_DimDate_FullDate]    Script Date: 2/1/2022 7:22:08 PM ******/
CREATE NONCLUSTERED INDEX [IDX_DimDate_FullDate] ON [bief_dds].[DimDate]( [FullDate] ASC ) ;
GO

ALTER TABLE [bief_dds].[DimDate] ADD CONSTRAINT [MSrepl_tran_version_default_52AC4DAF_092F_44D0_9E39_3F4E8AB9BC32_2105058535] DEFAULT( NEWID())FOR [msrepl_tran_version] ;
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
