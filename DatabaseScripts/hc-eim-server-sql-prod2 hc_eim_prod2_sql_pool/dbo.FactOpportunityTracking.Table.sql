/****** Object:  Table [dbo].[FactOpportunityTracking]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀吀爀愀挀欀椀渀最崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[FactDatekey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountKey] [int] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OpportunityName] [varchar](100) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusKey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignKey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䌀愀洀瀀愀椀最渀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CloseDate] [datetime] NULL,਍ऀ嬀䌀氀漀猀攀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [datetime] NULL,਍ऀ嬀䌀爀攀愀琀攀搀唀猀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [varchar](50) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[UpdateUserKey] [int] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LossReasonKey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䰀漀猀猀刀攀愀猀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䤀猀䌀氀漀猀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsWon] [bit] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OpportunitySourceCode] [varchar](50) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀匀漀氀甀琀椀漀渀伀昀昀攀爀攀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ExternalTaskId] [varchar](200) NULL,਍ऀ嬀䈀攀䈀愀挀欀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [int] NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsOld] [int] NULL,਍ऀ嬀䄀洀洀漀甀渀琀崀 嬀渀甀洀攀爀椀挀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 䠀䄀匀䠀 ⠀ 嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 ⤀Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
