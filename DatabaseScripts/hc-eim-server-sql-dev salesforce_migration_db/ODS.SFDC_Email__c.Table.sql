/****** Object:  Table [ODS].[SFDC_Email__c]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䔀洀愀椀氀开开挀崀ഀഀ
(਍ऀ嬀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [varchar](8000) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Name] [varchar](8000) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedDate] [datetime2](7) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SystemModstamp] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀嘀椀攀眀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastReferencedDate] [datetime2](7) NULL,਍ऀ嬀倀爀椀洀愀爀礀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotEmail__c] [bit] NULL,਍ऀ嬀匀琀愀琀甀猀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Lead__c] [varchar](8000) NULL,਍ऀ嬀伀渀挀䌀漀渀琀愀挀琀䔀洀愀椀氀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Customer__c] [varchar](8000) NULL,਍ऀ嬀伀渀挀䌀爀攀愀琀攀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[OncUpdatedDate__c] [datetime2](7) NULL,਍ऀ嬀伀渀挀䌀爀攀愀琀攀搀䈀礀唀猀攀爀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OncLastUpdatedUserCode__c] [varchar](8000) NULL,਍ऀ嬀伀渀挀䌀漀渀琀愀挀琀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ToBeProcessed__c] [bit] NULL,਍ऀ嬀䰀愀猀琀倀爀漀挀攀猀猀攀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Converted__c] [varchar](8000) NULL,਍ऀ嬀匀䘀䐀䌀伀爀椀最椀渀愀氀䰀愀猀琀䴀漀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[SFDCOriginalLastModifiedDate__c] [datetime2](7) NULL,਍ऀ嬀匀䘀䐀䌀伀爀椀最椀渀愀氀䰀攀愀搀䤀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Account__c] [varchar](8000) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
