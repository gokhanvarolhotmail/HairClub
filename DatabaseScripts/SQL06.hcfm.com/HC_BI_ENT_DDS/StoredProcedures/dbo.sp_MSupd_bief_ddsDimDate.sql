/* CreateDate: 01/08/2021 15:21:54.210 , ModifyDate: 01/08/2021 15:21:54.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_bief_ddsDimDate]
		@c1 int = NULL,
		@c2 date = NULL,
		@c3 char(12) = NULL,
		@c4 smallint = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 char(12) = NULL,
		@c10 char(7) = NULL,
		@c11 char(13) = NULL,
		@c12 char(4) = NULL,
		@c13 char(9) = NULL,
		@c14 smallint = NULL,
		@c15 datetime = NULL,
		@c16 datetime = NULL,
		@c17 smallint = NULL,
		@c18 char(10) = NULL,
		@c19 bit = NULL,
		@c20 bit = NULL,
		@c21 char(10) = NULL,
		@c22 char(15) = NULL,
		@c23 char(3) = NULL,
		@c24 char(8) = NULL,
		@c25 smallint = NULL,
		@c26 datetime = NULL,
		@c27 datetime = NULL,
		@c28 smallint = NULL,
		@c29 char(16) = NULL,
		@c30 bit = NULL,
		@c31 char(9) = NULL,
		@c32 char(15) = NULL,
		@c33 char(2) = NULL,
		@c34 char(7) = NULL,
		@c35 smallint = NULL,
		@c36 datetime = NULL,
		@c37 datetime = NULL,
		@c38 smallint = NULL,
		@c39 char(16) = NULL,
		@c40 char(9) = NULL,
		@c41 char(15) = NULL,
		@c42 char(2) = NULL,
		@c43 char(7) = NULL,
		@c44 smallint = NULL,
		@c45 int = NULL,
		@c46 datetime = NULL,
		@c47 datetime = NULL,
		@c48 smallint = NULL,
		@c49 char(16) = NULL,
		@c50 char(4) = NULL,
		@c51 char(2) = NULL,
		@c52 datetime = NULL,
		@c53 datetime = NULL,
		@c54 smallint = NULL,
		@c55 char(20) = NULL,
		@c56 smallint = NULL,
		@c57 smallint = NULL,
		@c58 char(7) = NULL,
		@c59 char(7) = NULL,
		@c60 smallint = NULL,
		@c61 smallint = NULL,
		@c62 smallint = NULL,
		@c63 smallint = NULL,
		@c64 smallint = NULL,
		@c65 int = NULL,
		@c66 int = NULL,
		@c67 int = NULL,
		@c68 int = NULL,
		@c69 int = NULL,
		@c70 char(4) = NULL,
		@c71 char(16) = NULL,
		@c72 char(6) = NULL,
		@c73 char(1) = NULL,
		@c74 char(16) = NULL,
		@c75 char(7) = NULL,
		@c76 char(34) = NULL,
		@c77 char(3) = NULL,
		@c78 char(21) = NULL,
		@c79 char(2) = NULL,
		@c80 char(8) = NULL,
		@c81 char(4) = NULL,
		@c82 char(14) = NULL,
		@c83 char(16) = NULL,
		@c84 char(22) = NULL,
		@c85 char(2) = NULL,
		@c86 char(14) = NULL,
		@c87 char(8) = NULL,
		@c88 char(20) = NULL,
		@c89 char(4) = NULL,
		@c90 char(10) = NULL,
		@c91 char(2) = NULL,
		@c92 char(16) = NULL,
		@c93 char(8) = NULL,
		@c94 char(22) = NULL,
		@c95 char(4) = NULL,
		@c96 char(10) = NULL,
		@c97 uniqueidentifier = NULL,
		@c98 int = NULL,
		@c99 int = NULL,
		@c100 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(13)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bief_dds].[DimDate] set
		[DateKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [DateKey] end,
		[FullDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [FullDate] end,
		[ISODate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ISODate] end,
		[YearNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [YearNumber] end,
		[YearQuarterNumber] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [YearQuarterNumber] end,
		[YearMonthNumber] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [YearMonthNumber] end,
		[YearQuarterMonthNumber] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [YearQuarterMonthNumber] end,
		[YearWeekNumber] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [YearWeekNumber] end,
		[DateName] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DateName] end,
		[WeekName] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [WeekName] end,
		[WeekNameWithYear] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [WeekNameWithYear] end,
		[WeekShortName] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [WeekShortName] end,
		[WeekShortNameWithYear] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [WeekShortNameWithYear] end,
		[WeekNumber] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [WeekNumber] end,
		[FirstDateOfWeek] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [FirstDateOfWeek] end,
		[LastDateOfWeek] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastDateOfWeek] end,
		[DayOfWeek] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [DayOfWeek] end,
		[DayOfWeekName] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [DayOfWeekName] end,
		[IsWeekday] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsWeekday] end,
		[IsWeekend] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsWeekend] end,
		[MonthName] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [MonthName] end,
		[MonthNameWithYear] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [MonthNameWithYear] end,
		[MonthShortName] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MonthShortName] end,
		[MonthShortNameWithYear] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [MonthShortNameWithYear] end,
		[MonthNumber] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MonthNumber] end,
		[FirstDateOfMonth] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [FirstDateOfMonth] end,
		[LastDateOfMonth] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [LastDateOfMonth] end,
		[DayOfMonth] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [DayOfMonth] end,
		[DayOfMonthName] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [DayOfMonthName] end,
		[IsLastDayOfMonth] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [IsLastDayOfMonth] end,
		[QuarterName] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [QuarterName] end,
		[QuarterNameWithYear] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [QuarterNameWithYear] end,
		[QuarterShortName] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [QuarterShortName] end,
		[QuarterShortNameWithYear] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [QuarterShortNameWithYear] end,
		[QuarterNumber] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [QuarterNumber] end,
		[FirstDateOfQuarter] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [FirstDateOfQuarter] end,
		[LastDateOfQuarter] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [LastDateOfQuarter] end,
		[DayOfQuarter] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [DayOfQuarter] end,
		[DayOfQuarterName] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [DayOfQuarterName] end,
		[HalfName] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [HalfName] end,
		[HalfNameWithYear] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [HalfNameWithYear] end,
		[HalfShortName] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [HalfShortName] end,
		[HalfShortNameWithYear] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [HalfShortNameWithYear] end,
		[HalfNumber] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [HalfNumber] end,
		[YearHalfNumber] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [YearHalfNumber] end,
		[FirstDateOfHalf] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [FirstDateOfHalf] end,
		[LastDateOfHalf] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [LastDateOfHalf] end,
		[DayOfHalf] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [DayOfHalf] end,
		[DayOfHalfName] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [DayOfHalfName] end,
		[YearName] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [YearName] end,
		[YearShortName] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [YearShortName] end,
		[FirstDateOfYear] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [FirstDateOfYear] end,
		[LastDateOfYear] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [LastDateOfYear] end,
		[DayOfYear] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [DayOfYear] end,
		[DayOfYearName] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [DayOfYearName] end,
		[CalendarQuarter] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [CalendarQuarter] end,
		[CalendarYear] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [CalendarYear] end,
		[CalendarYearMonth] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [CalendarYearMonth] end,
		[CalendarYearQtr] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [CalendarYearQtr] end,
		[FiscalYear] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [FiscalYear] end,
		[FiscalWeek] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [FiscalWeek] end,
		[FiscalPeriod] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [FiscalPeriod] end,
		[FiscalMonth] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [FiscalMonth] end,
		[FiscalQuarter] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [FiscalQuarter] end,
		[FiscalYearFiscalWeek] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [FiscalYearFiscalWeek] end,
		[FiscalYearFiscalPeriod] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [FiscalYearFiscalPeriod] end,
		[FiscalYearFiscalMonth] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [FiscalYearFiscalMonth] end,
		[FiscalYearFiscalQuarter] = case substring(@bitmap,9,1) & 8 when 8 then @c68 else [FiscalYearFiscalQuarter] end,
		[FiscalYearFiscalQuarterFiscalMonth] = case substring(@bitmap,9,1) & 16 when 16 then @c69 else [FiscalYearFiscalQuarterFiscalMonth] end,
		[FiscalYearName] = case substring(@bitmap,9,1) & 32 when 32 then @c70 else [FiscalYearName] end,
		[FiscalYearLongName] = case substring(@bitmap,9,1) & 64 when 64 then @c71 else [FiscalYearLongName] end,
		[FiscalYearShortName] = case substring(@bitmap,9,1) & 128 when 128 then @c72 else [FiscalYearShortName] end,
		[FiscalQuarterName] = case substring(@bitmap,10,1) & 1 when 1 then @c73 else [FiscalQuarterName] end,
		[FiscalQuarterLongName] = case substring(@bitmap,10,1) & 2 when 2 then @c74 else [FiscalQuarterLongName] end,
		[FiscalQuarterNameWithYear] = case substring(@bitmap,10,1) & 4 when 4 then @c75 else [FiscalQuarterNameWithYear] end,
		[FiscalQuarterLongNameWithYear] = case substring(@bitmap,10,1) & 8 when 8 then @c76 else [FiscalQuarterLongNameWithYear] end,
		[FiscalQuarterShortName] = case substring(@bitmap,10,1) & 16 when 16 then @c77 else [FiscalQuarterShortName] end,
		[FiscalQuarterShortNameWithYear] = case substring(@bitmap,10,1) & 32 when 32 then @c78 else [FiscalQuarterShortNameWithYear] end,
		[FiscalMonthName] = case substring(@bitmap,10,1) & 64 when 64 then @c79 else [FiscalMonthName] end,
		[FiscalMonthNameWithYear] = case substring(@bitmap,10,1) & 128 when 128 then @c80 else [FiscalMonthNameWithYear] end,
		[FiscalMonthShortName] = case substring(@bitmap,11,1) & 1 when 1 then @c81 else [FiscalMonthShortName] end,
		[FiscalMonthShortNameWithYear] = case substring(@bitmap,11,1) & 2 when 2 then @c82 else [FiscalMonthShortNameWithYear] end,
		[FiscalMonthCalendarShortName] = case substring(@bitmap,11,1) & 4 when 4 then @c83 else [FiscalMonthCalendarShortName] end,
		[FiscalMonthCalendarShortNameWithYear] = case substring(@bitmap,11,1) & 8 when 8 then @c84 else [FiscalMonthCalendarShortNameWithYear] end,
		[FiscalWeekName] = case substring(@bitmap,11,1) & 16 when 16 then @c85 else [FiscalWeekName] end,
		[FiscalWeekLongName] = case substring(@bitmap,11,1) & 32 when 32 then @c86 else [FiscalWeekLongName] end,
		[FiscalWeekNameWithYear] = case substring(@bitmap,11,1) & 64 when 64 then @c87 else [FiscalWeekNameWithYear] end,
		[FiscalWeekLongNameWithYear] = case substring(@bitmap,11,1) & 128 when 128 then @c88 else [FiscalWeekLongNameWithYear] end,
		[FiscalWeekShortName] = case substring(@bitmap,12,1) & 1 when 1 then @c89 else [FiscalWeekShortName] end,
		[FiscalWeekShortNameWithYear] = case substring(@bitmap,12,1) & 2 when 2 then @c90 else [FiscalWeekShortNameWithYear] end,
		[FiscalPeriodName] = case substring(@bitmap,12,1) & 4 when 4 then @c91 else [FiscalPeriodName] end,
		[FiscalPeriodLongName] = case substring(@bitmap,12,1) & 8 when 8 then @c92 else [FiscalPeriodLongName] end,
		[FiscalPeriodNameWithYear] = case substring(@bitmap,12,1) & 16 when 16 then @c93 else [FiscalPeriodNameWithYear] end,
		[FiscalPeriodLongNameWithYear] = case substring(@bitmap,12,1) & 32 when 32 then @c94 else [FiscalPeriodLongNameWithYear] end,
		[FiscalPeriodShortName] = case substring(@bitmap,12,1) & 64 when 64 then @c95 else [FiscalPeriodShortName] end,
		[FiscalPeriodShortNameWithYear] = case substring(@bitmap,12,1) & 128 when 128 then @c96 else [FiscalPeriodShortNameWithYear] end,
		[msrepl_tran_version] = case substring(@bitmap,13,1) & 1 when 1 then @c97 else [msrepl_tran_version] end,
		[CummWorkdays] = case substring(@bitmap,13,1) & 2 when 2 then @c98 else [CummWorkdays] end,
		[MonthWorkdays] = case substring(@bitmap,13,1) & 4 when 4 then @c99 else [MonthWorkdays] end,
		[MonthWorkdaysTotal] = case substring(@bitmap,13,1) & 8 when 8 then @c100 else [MonthWorkdaysTotal] end
	where [DateKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[DimDate]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bief_dds].[DimDate] set
		[FullDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [FullDate] end,
		[ISODate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ISODate] end,
		[YearNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [YearNumber] end,
		[YearQuarterNumber] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [YearQuarterNumber] end,
		[YearMonthNumber] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [YearMonthNumber] end,
		[YearQuarterMonthNumber] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [YearQuarterMonthNumber] end,
		[YearWeekNumber] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [YearWeekNumber] end,
		[DateName] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DateName] end,
		[WeekName] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [WeekName] end,
		[WeekNameWithYear] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [WeekNameWithYear] end,
		[WeekShortName] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [WeekShortName] end,
		[WeekShortNameWithYear] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [WeekShortNameWithYear] end,
		[WeekNumber] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [WeekNumber] end,
		[FirstDateOfWeek] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [FirstDateOfWeek] end,
		[LastDateOfWeek] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastDateOfWeek] end,
		[DayOfWeek] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [DayOfWeek] end,
		[DayOfWeekName] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [DayOfWeekName] end,
		[IsWeekday] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsWeekday] end,
		[IsWeekend] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsWeekend] end,
		[MonthName] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [MonthName] end,
		[MonthNameWithYear] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [MonthNameWithYear] end,
		[MonthShortName] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MonthShortName] end,
		[MonthShortNameWithYear] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [MonthShortNameWithYear] end,
		[MonthNumber] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MonthNumber] end,
		[FirstDateOfMonth] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [FirstDateOfMonth] end,
		[LastDateOfMonth] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [LastDateOfMonth] end,
		[DayOfMonth] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [DayOfMonth] end,
		[DayOfMonthName] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [DayOfMonthName] end,
		[IsLastDayOfMonth] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [IsLastDayOfMonth] end,
		[QuarterName] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [QuarterName] end,
		[QuarterNameWithYear] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [QuarterNameWithYear] end,
		[QuarterShortName] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [QuarterShortName] end,
		[QuarterShortNameWithYear] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [QuarterShortNameWithYear] end,
		[QuarterNumber] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [QuarterNumber] end,
		[FirstDateOfQuarter] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [FirstDateOfQuarter] end,
		[LastDateOfQuarter] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [LastDateOfQuarter] end,
		[DayOfQuarter] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [DayOfQuarter] end,
		[DayOfQuarterName] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [DayOfQuarterName] end,
		[HalfName] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [HalfName] end,
		[HalfNameWithYear] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [HalfNameWithYear] end,
		[HalfShortName] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [HalfShortName] end,
		[HalfShortNameWithYear] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [HalfShortNameWithYear] end,
		[HalfNumber] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [HalfNumber] end,
		[YearHalfNumber] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [YearHalfNumber] end,
		[FirstDateOfHalf] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [FirstDateOfHalf] end,
		[LastDateOfHalf] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [LastDateOfHalf] end,
		[DayOfHalf] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [DayOfHalf] end,
		[DayOfHalfName] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [DayOfHalfName] end,
		[YearName] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [YearName] end,
		[YearShortName] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [YearShortName] end,
		[FirstDateOfYear] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [FirstDateOfYear] end,
		[LastDateOfYear] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [LastDateOfYear] end,
		[DayOfYear] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [DayOfYear] end,
		[DayOfYearName] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [DayOfYearName] end,
		[CalendarQuarter] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [CalendarQuarter] end,
		[CalendarYear] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [CalendarYear] end,
		[CalendarYearMonth] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [CalendarYearMonth] end,
		[CalendarYearQtr] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [CalendarYearQtr] end,
		[FiscalYear] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [FiscalYear] end,
		[FiscalWeek] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [FiscalWeek] end,
		[FiscalPeriod] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [FiscalPeriod] end,
		[FiscalMonth] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [FiscalMonth] end,
		[FiscalQuarter] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [FiscalQuarter] end,
		[FiscalYearFiscalWeek] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [FiscalYearFiscalWeek] end,
		[FiscalYearFiscalPeriod] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [FiscalYearFiscalPeriod] end,
		[FiscalYearFiscalMonth] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [FiscalYearFiscalMonth] end,
		[FiscalYearFiscalQuarter] = case substring(@bitmap,9,1) & 8 when 8 then @c68 else [FiscalYearFiscalQuarter] end,
		[FiscalYearFiscalQuarterFiscalMonth] = case substring(@bitmap,9,1) & 16 when 16 then @c69 else [FiscalYearFiscalQuarterFiscalMonth] end,
		[FiscalYearName] = case substring(@bitmap,9,1) & 32 when 32 then @c70 else [FiscalYearName] end,
		[FiscalYearLongName] = case substring(@bitmap,9,1) & 64 when 64 then @c71 else [FiscalYearLongName] end,
		[FiscalYearShortName] = case substring(@bitmap,9,1) & 128 when 128 then @c72 else [FiscalYearShortName] end,
		[FiscalQuarterName] = case substring(@bitmap,10,1) & 1 when 1 then @c73 else [FiscalQuarterName] end,
		[FiscalQuarterLongName] = case substring(@bitmap,10,1) & 2 when 2 then @c74 else [FiscalQuarterLongName] end,
		[FiscalQuarterNameWithYear] = case substring(@bitmap,10,1) & 4 when 4 then @c75 else [FiscalQuarterNameWithYear] end,
		[FiscalQuarterLongNameWithYear] = case substring(@bitmap,10,1) & 8 when 8 then @c76 else [FiscalQuarterLongNameWithYear] end,
		[FiscalQuarterShortName] = case substring(@bitmap,10,1) & 16 when 16 then @c77 else [FiscalQuarterShortName] end,
		[FiscalQuarterShortNameWithYear] = case substring(@bitmap,10,1) & 32 when 32 then @c78 else [FiscalQuarterShortNameWithYear] end,
		[FiscalMonthName] = case substring(@bitmap,10,1) & 64 when 64 then @c79 else [FiscalMonthName] end,
		[FiscalMonthNameWithYear] = case substring(@bitmap,10,1) & 128 when 128 then @c80 else [FiscalMonthNameWithYear] end,
		[FiscalMonthShortName] = case substring(@bitmap,11,1) & 1 when 1 then @c81 else [FiscalMonthShortName] end,
		[FiscalMonthShortNameWithYear] = case substring(@bitmap,11,1) & 2 when 2 then @c82 else [FiscalMonthShortNameWithYear] end,
		[FiscalMonthCalendarShortName] = case substring(@bitmap,11,1) & 4 when 4 then @c83 else [FiscalMonthCalendarShortName] end,
		[FiscalMonthCalendarShortNameWithYear] = case substring(@bitmap,11,1) & 8 when 8 then @c84 else [FiscalMonthCalendarShortNameWithYear] end,
		[FiscalWeekName] = case substring(@bitmap,11,1) & 16 when 16 then @c85 else [FiscalWeekName] end,
		[FiscalWeekLongName] = case substring(@bitmap,11,1) & 32 when 32 then @c86 else [FiscalWeekLongName] end,
		[FiscalWeekNameWithYear] = case substring(@bitmap,11,1) & 64 when 64 then @c87 else [FiscalWeekNameWithYear] end,
		[FiscalWeekLongNameWithYear] = case substring(@bitmap,11,1) & 128 when 128 then @c88 else [FiscalWeekLongNameWithYear] end,
		[FiscalWeekShortName] = case substring(@bitmap,12,1) & 1 when 1 then @c89 else [FiscalWeekShortName] end,
		[FiscalWeekShortNameWithYear] = case substring(@bitmap,12,1) & 2 when 2 then @c90 else [FiscalWeekShortNameWithYear] end,
		[FiscalPeriodName] = case substring(@bitmap,12,1) & 4 when 4 then @c91 else [FiscalPeriodName] end,
		[FiscalPeriodLongName] = case substring(@bitmap,12,1) & 8 when 8 then @c92 else [FiscalPeriodLongName] end,
		[FiscalPeriodNameWithYear] = case substring(@bitmap,12,1) & 16 when 16 then @c93 else [FiscalPeriodNameWithYear] end,
		[FiscalPeriodLongNameWithYear] = case substring(@bitmap,12,1) & 32 when 32 then @c94 else [FiscalPeriodLongNameWithYear] end,
		[FiscalPeriodShortName] = case substring(@bitmap,12,1) & 64 when 64 then @c95 else [FiscalPeriodShortName] end,
		[FiscalPeriodShortNameWithYear] = case substring(@bitmap,12,1) & 128 when 128 then @c96 else [FiscalPeriodShortNameWithYear] end,
		[msrepl_tran_version] = case substring(@bitmap,13,1) & 1 when 1 then @c97 else [msrepl_tran_version] end,
		[CummWorkdays] = case substring(@bitmap,13,1) & 2 when 2 then @c98 else [CummWorkdays] end,
		[MonthWorkdays] = case substring(@bitmap,13,1) & 4 when 4 then @c99 else [MonthWorkdays] end,
		[MonthWorkdaysTotal] = case substring(@bitmap,13,1) & 8 when 8 then @c100 else [MonthWorkdaysTotal] end
	where [DateKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[DimDate]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
