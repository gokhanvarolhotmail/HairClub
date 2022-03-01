/****** Object:  Table [dbo].[FactCampaignHistory]    Script Date: 3/1/2022 8:53:35 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䌀愀洀瀀愀椀最渀䠀椀猀琀漀爀礀崀ഀഀ
(਍ऀ嬀䌀愀洀瀀愀椀最渀䠀椀猀琀漀爀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[FactDateKey] [int] NULL,਍ऀ嬀䘀愀挀琀吀椀洀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FactDate] [datetime] NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CampaignId] [nvarchar](50) NULL,਍ऀ嬀䰀攀愀搀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadId] [nvarchar](50) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountId] [nvarchar](50) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusKey] [int] NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䠀椀猀琀漀爀礀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䠀愀猀刀攀猀瀀漀渀搀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [datetime] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [datetime] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactName] [nvarchar](1024) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䄀搀搀爀攀猀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactCity] [nvarchar](1024) NULL,਍ऀ嬀䌀漀渀琀愀挀琀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactPostalCode] [nvarchar](1024) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[GeographyKey] [int] NULL,਍ऀ嬀匀漀甀爀挀攀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadSource] [nvarchar](1024) NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
