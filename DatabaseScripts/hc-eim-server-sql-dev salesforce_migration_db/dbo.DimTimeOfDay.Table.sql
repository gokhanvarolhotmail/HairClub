/****** Object:  Table [dbo].[DimTimeOfDay]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀吀椀洀攀伀昀䐀愀礀崀ഀഀ
(਍ऀ嬀吀椀洀攀伀昀䐀愀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Time] [varchar](12) NULL,਍ऀ嬀吀椀洀攀㈀㐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Hour] [smallint] NULL,਍ऀ嬀䠀漀甀爀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Minute] [smallint] NULL,਍ऀ嬀䴀椀渀甀琀攀䬀攀礀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MinuteName] [varchar](20) NULL,਍ऀ嬀匀攀挀漀渀搀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Hour24] [smallint] NULL,਍ऀ嬀䄀䴀崀 嬀挀栀愀爀崀⠀㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[Time24HM] [varchar](20) NULL,਍ऀ嬀䠀漀甀爀䌀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MinuteC] [smallint] NULL,਍ऀ嬀㌀　䴀椀渀甀琀攀䤀渀琀攀爀瘀愀氀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DayPart] [varchar](20) NULL,਍ऀ嬀吀椀洀攀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LoadDate] [datetime] NULL,਍ऀ嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [varchar](50) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀吀椀洀攀伀昀䐀愀礀䬀攀礀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
