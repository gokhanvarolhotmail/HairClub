/****** Object:  Table [ODS].[SFDC_PromoCode]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开倀爀漀洀漀䌀漀搀攀崀ഀഀ
(਍ऀ嬀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [varchar](8000) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Name] [varchar](8000) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [datetime2](7) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SystemModstamp] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastViewedDate] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀刀攀昀攀爀攀渀挀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[PromoCodeDisplay__c] [varchar](8000) NULL,਍ऀ嬀䐀椀猀挀漀甀渀琀吀礀瀀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StartDate__c] [datetime2](7) NULL,਍ऀ嬀䔀渀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Active__c] [bit] NULL,਍ऀ嬀一䌀䌀䄀瘀愀椀氀愀戀氀攀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[PromoCodeSort__c] [numeric](38, 18) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = HASH ( [Id] ),਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
