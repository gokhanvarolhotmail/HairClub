/****** Object:  Table [dbo].[DimCampaign]    Script Date: 3/1/2022 8:53:34 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䌀愀洀瀀愀椀最渀崀ഀഀ
(਍ऀ嬀䌀愀洀瀀愀椀最渀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CampaignId] [varchar](50) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignDescription] [varchar](2000) NULL,਍ऀ嬀䄀最攀渀挀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AgencyName] [varchar](200) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusKey] [int] NULL,਍ऀ嬀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[EndDate] [datetime2](7) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyKey] [int] NULL,਍ऀ嬀倀爀漀洀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PromotioKey] [int] NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ChannelKey] [int] NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignLanguage] [varchar](200) NULL,਍ऀ嬀䰀愀渀最甀愀最攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CampaignMedia] [varchar](200) NULL,਍ऀ嬀䴀攀搀椀愀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CampaignSource] [varchar](200) NULL,਍ऀ嬀匀漀甀爀挀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Campaigngender] [varchar](200) NULL,਍ऀ嬀䜀攀渀搀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CampaignType] [varchar](200) NULL,਍ऀ嬀䈀甀搀最攀琀攀搀䌀漀猀琀崀 嬀渀甀洀攀爀椀挀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActualCost] [numeric](38, 18) NULL,਍ऀ嬀䐀一䤀匀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Referrer] [varchar](200) NULL,਍ऀ嬀刀攀昀攀爀爀愀氀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LoadDate] [datetime] NULL,਍ऀ嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[IsActive] [bit] NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignFormat] [varchar](50) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䐀攀瘀椀挀攀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignDNIS] [varchar](50) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀吀愀挀琀椀挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignPromoDescription] [varchar](8000) NULL,਍ऀ嬀匀漀甀爀挀攀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TollFreeName] [varchar](200) NULL,਍ऀ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TollFreeNumber] [varchar](200) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = REPLICATE,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䤀一䐀䔀堀ഀഀ
	(਍ऀऀ嬀䌀愀洀瀀愀椀最渀䤀搀崀 䄀匀䌀ഀഀ
	)਍⤀ഀഀ
GO਍
