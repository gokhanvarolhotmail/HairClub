/****** Object:  Table [dbo].[FactOpportunity]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀崀ഀഀ
(਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[FactDate] [datetime] NULL,਍ऀ嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountKey] [int] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[OpportunityName] [nvarchar](2048) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusKey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignKey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䌀愀洀瀀愀椀最渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[CloseDate] [datetime] NULL,਍ऀ嬀䌀氀漀猀攀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [datetime] NULL,਍ऀ嬀䌀爀攀愀琀攀搀唀猀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](2048) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[UpdateUserKey] [int] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[LossReasonKey] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䰀漀猀猀刀攀愀猀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䤀猀䌀氀漀猀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsWon] [bit] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[OpportunitySourceCode] [nvarchar](2048) NULL,਍ऀ嬀䈀攀䈀愀挀欀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[OpportunityCenterType] [varchar](1024) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsOld] [int] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
