/****** Object:  Table [dbo].[FactInteraction]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䤀渀琀攀爀愀挀琀椀漀渀崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[TaskId] [nvarchar](max) NULL,਍ऀ嬀吀愀猀欀匀甀戀樀攀挀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskStatusKey] [int] NULL,਍ऀ嬀吀愀猀欀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskPriority] [nvarchar](max) NULL,਍ऀ嬀䤀猀䠀椀最栀倀爀椀漀爀椀琀礀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Description] [nvarchar](max) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䌀漀猀琀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ ㌀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerId] [nvarchar](max) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskTypeKey] [int] NULL,਍ऀ嬀吀愀猀欀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignKey] [int] NULL,਍ऀ嬀吀愀猀欀䌀愀洀瀀愀椀最渀䬀攀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ResultKey] [int] NULL,਍ऀ嬀吀愀猀欀刀攀猀甀氀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[FunnelStepKey] [int] NULL,਍ऀ嬀䄀挀琀椀漀渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TaskAction] [nvarchar](max) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀吀礀瀀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ActivityType] [nvarchar](max) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ActivityDate] [date] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [date] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[CallBackDate] [date] NULL,਍ऀ嬀䐀攀瘀椀挀攀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivitySource] [nvarchar](max) NULL,਍ऀ嬀唀渀椀焀甀攀吀愀猀欀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PromotionCode] [nvarchar](max) NULL,਍ऀ嬀倀爀漀洀漀琀椀漀渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LoadDate] [datetime2](7) NULL,਍ऀ嬀䌀爀攀愀琀攀唀猀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[UpdateUser] [varchar](100) NULL,਍ऀ嬀䄀挀挀漀洀洀漀搀愀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	HEAP਍⤀ഀഀ
GO਍
