/****** Object:  Table [dbo].[DimDate]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䐀愀琀攀崀ഀഀ
(਍ऀ嬀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FullDate] [date] NULL,਍ऀ嬀䤀匀伀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[YearNumber] [int] NULL,਍ऀ嬀夀攀愀爀儀甀愀爀琀攀爀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[YearMonthNumber] [int] NULL,਍ऀ嬀夀攀愀爀儀甀愀爀琀攀爀䴀漀渀琀栀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[YearWeekNumber] [int] NULL,਍ऀ嬀䐀愀琀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WeekName] [varchar](8000) NULL,਍ऀ嬀圀攀攀欀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WeekShortName] [varchar](8000) NULL,਍ऀ嬀圀攀攀欀匀栀漀爀琀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WeekNumber] [int] NULL,਍ऀ嬀䘀椀爀猀琀䐀愀琀攀伀昀圀攀攀欀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[LastDateOfWeek] [date] NULL,਍ऀ嬀䐀愀礀伀昀圀攀攀欀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DayOfWeekName] [varchar](8000) NULL,਍ऀ嬀䤀猀圀攀攀欀搀愀礀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsWeekend] [bit] NULL,਍ऀ嬀䴀漀渀琀栀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MonthNameWithYear] [varchar](8000) NULL,਍ऀ嬀䴀漀渀琀栀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MonthShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀䴀漀渀琀栀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FirstDateOfMonth] [date] NULL,਍ऀ嬀䰀愀猀琀䐀愀琀攀伀昀䴀漀渀琀栀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[DayOfMonth] [int] NULL,਍ऀ嬀䐀愀礀伀昀䴀漀渀琀栀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsLastDayOfMonth] [bit] NULL,਍ऀ嬀儀甀愀爀琀攀爀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[QuarterNameWithYear] [varchar](8000) NULL,਍ऀ嬀儀甀愀爀琀攀爀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[QuarterShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀儀甀愀爀琀攀爀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FirstDateOfQuarter] [date] NULL,਍ऀ嬀䰀愀猀琀䐀愀琀攀伀昀儀甀愀爀琀攀爀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[DayOfQuarter] [int] NULL,਍ऀ嬀䐀愀礀伀昀儀甀愀爀琀攀爀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[HalfName] [varchar](8000) NULL,਍ऀ嬀䠀愀氀昀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[HalfShortName] [varchar](8000) NULL,਍ऀ嬀䠀愀氀昀匀栀漀爀琀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[HalfNumber] [int] NULL,਍ऀ嬀夀攀愀爀䠀愀氀昀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FirstDateOfHalf] [date] NULL,਍ऀ嬀䰀愀猀琀䐀愀琀攀伀昀䠀愀氀昀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[DayOfHalf] [int] NULL,਍ऀ嬀䐀愀礀伀昀䠀愀氀昀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[YearName] [varchar](8000) NULL,਍ऀ嬀夀攀愀爀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FirstDateOfYear] [date] NULL,਍ऀ嬀䰀愀猀琀䐀愀琀攀伀昀夀攀愀爀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[DayOfYear] [int] NULL,਍ऀ嬀䐀愀礀伀昀夀攀愀爀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CalendarQuarter] [int] NULL,਍ऀ嬀䌀愀氀攀渀搀愀爀夀攀愀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CalendarYearMonth] [varchar](8000) NULL,਍ऀ嬀䌀愀氀攀渀搀愀爀夀攀愀爀儀琀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalYear] [int] NULL,਍ऀ嬀䘀椀猀挀愀氀圀攀攀欀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FiscalPeriod] [int] NULL,਍ऀ嬀䘀椀猀挀愀氀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FiscalQuarter] [int] NULL,਍ऀ嬀䘀椀猀挀愀氀夀攀愀爀䘀椀猀挀愀氀圀攀攀欀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FiscalYearFiscalPeriod] [int] NULL,਍ऀ嬀䘀椀猀挀愀氀夀攀愀爀䘀椀猀挀愀氀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FiscalYearFiscalQuarter] [int] NULL,਍ऀ嬀䘀椀猀挀愀氀夀攀愀爀䘀椀猀挀愀氀儀甀愀爀琀攀爀䘀椀猀挀愀氀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FiscalYearName] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀夀攀愀爀䰀漀渀最一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalYearShortName] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀儀甀愀爀琀攀爀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalQuarterLongName] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀儀甀愀爀琀攀爀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalQuarterLongNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀儀甀愀爀琀攀爀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalQuarterShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀䴀漀渀琀栀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalMonthNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀䴀漀渀琀栀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalMonthShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀䴀漀渀琀栀䌀愀氀攀渀搀愀爀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalMonthCalendarShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀圀攀攀欀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalWeekLongName] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀圀攀攀欀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalWeekLongNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀圀攀攀欀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalWeekShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀倀攀爀椀漀搀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalPeriodLongName] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀倀攀爀椀漀搀一愀洀攀圀椀琀栀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalPeriodLongNameWithYear] [varchar](8000) NULL,਍ऀ嬀䘀椀猀挀愀氀倀攀爀椀漀搀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FiscalPeriodShortNameWithYear] [varchar](8000) NULL,਍ऀ嬀䌀甀洀洀圀漀爀欀搀愀礀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MonthWorkdays] [int] NULL,਍ऀ嬀䴀漀渀琀栀圀漀爀欀搀愀礀猀吀漀琀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsHoliday] [bit] NULL,਍ऀ嬀䴀漀渀琀栀伀昀儀甀愀爀琀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[BroadcastYearBroadcastQuarter] [int] NULL,਍ऀ嬀䈀爀漀愀搀挀愀猀琀夀攀愀爀䈀爀漀愀搀挀愀猀琀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[BroadcastYearBroadcastWeek] [int] NULL,਍ऀ嬀䈀爀漀愀搀挀愀猀琀夀攀愀爀儀琀爀䴀漀渀琀栀圀攀攀欀䐀愀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[BroadcastYearQtrMonth] [int] NULL,਍ऀ嬀䈀爀漀愀搀挀愀猀琀夀攀愀爀匀栀漀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[BroadcastYearLongName] [varchar](8000) NULL,਍ऀ嬀䈀爀漀愀搀挀愀猀琀夀攀愀爀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[BroadcastQuarterName] [varchar](8000) NULL,਍ऀ嬀䈀爀漀愀搀挀愀猀琀圀攀攀欀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[BroadcastDayName] [varchar](8000) NULL,਍ऀ嬀洀猀爀攀瀀氀开琀爀愀渀开瘀攀爀猀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DWH_LoadDate] [datetime2](7) NULL,਍ऀ嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](8000) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
