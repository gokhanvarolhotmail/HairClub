/****** Object:  Table [dbo].[FactCallDetail]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䌀愀氀氀䐀攀琀愀椀氀崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FactTimeKey] [int] NULL,਍ऀ嬀䘀愀挀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[CallId] [varbinary](max) NULL,਍ऀ嬀䌀愀氀氀䴀攀搀椀愀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MediaKey] [int] NULL,਍ऀ嬀䌀愀氀氀倀欀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CallDate] [datetime] NULL,਍ऀ嬀䌀愀氀氀䤀瘀爀吀椀洀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CallQueueTime] [int] NULL,਍ऀ嬀䌀愀氀氀倀攀渀搀椀渀最吀椀洀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CallTalkTime] [int] NULL,਍ऀ嬀䌀愀氀氀䠀漀氀搀吀椀洀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CallHeld] [int] NULL,਍ऀ嬀䌀愀氀氀䴀愀砀䠀漀氀搀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CallAcwTime] [int] NULL,਍ऀ嬀䌀愀氀氀䐀甀爀愀琀椀漀渀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ServiceName] [varchar](400) NULL,਍ऀ嬀匀攀爀瘀椀挀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ScenarioName] [varchar](200) NULL,਍ऀ嬀匀挀攀渀愀爀椀漀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskId] [varchar](200) NULL,਍ऀ嬀䤀渀挀漀洀洀椀渀最匀漀甀爀挀攀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceKey] [int] NULL,਍ऀ嬀䌀愀氀氀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CallTypeKey] [int] NULL,਍ऀ嬀䄀最攀渀琀䐀椀猀瀀漀猀椀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AgentDispositionKey] [int] NULL,਍ऀ嬀䄀最攀渀琀䰀漀最椀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AgentKey] [int] NULL,਍ऀ嬀䤀猀嘀椀愀戀氀攀䌀愀氀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsProductiveCall] [int] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䠀䔀䄀倀ഀഀ
)਍䜀伀ഀഀ
