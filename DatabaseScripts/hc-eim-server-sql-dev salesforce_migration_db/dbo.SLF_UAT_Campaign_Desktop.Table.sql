/****** Object:  Table [dbo].[SLF_UAT_Campaign_Desktop]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开唀䄀吀开䌀愀洀瀀愀椀最渀开䐀攀猀欀琀漀瀀崀⠀ഀഀ
	[Id] [varchar](1) NOT NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ActualCost] [decimal](18, 0) NULL,਍ऀ嬀䈀甀搀最攀琀攀搀䌀漀猀琀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[Channel__c] [nvarchar](765) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfContacts] [int] NULL,਍ऀ嬀一甀洀戀攀爀伀昀䌀漀渀瘀攀爀琀攀搀䰀攀愀搀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](765) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Description] [nvarchar](max) NULL,਍ऀ嬀䐀椀愀氀攀爀䴀椀猀挀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀㤀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[EndDate] [nvarchar](4000) NULL,਍ऀ嬀䔀砀瀀攀挀琀攀搀刀攀猀瀀漀渀猀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀　Ⰰ ㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[ExpectedRevenue] [decimal](18, 0) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀开䤀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Language__c] [nvarchar](765) NULL,਍ऀ嬀一甀洀戀攀爀伀昀䰀攀愀搀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Name] [nvarchar](243) NOT NULL,਍ऀ嬀一甀洀戀攀爀匀攀渀琀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfOpportunities] [int] NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ParentId] [nvarchar](18) NULL,਍ऀ嬀倀爀漀洀漀开䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecordTypeId] [nvarchar](18) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䴀攀洀戀攀爀刀攀挀漀爀搀吀礀瀀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfResponses] [int] NULL,਍ऀ嬀匀琀愀爀琀䐀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Status] [nvarchar](765) NULL,਍ऀ嬀吀漀氀氀䘀爀攀攀一甀洀戀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Type] [nvarchar](765) NULL,਍ऀ嬀䄀洀漀甀渀琀䄀氀氀伀瀀瀀漀爀琀甀渀椀琀椀攀猀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[AmountWonOpportunities] [decimal](18, 0) NULL,਍ऀ嬀一甀洀戀攀爀伀昀圀漀渀伀瀀瀀漀爀琀甀渀椀琀椀攀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Format__c] [nvarchar](765) NULL,਍ऀ嬀䰀漀挀愀琀椀漀渀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Media__c] [nvarchar](765) NULL,਍ऀ嬀䄀甀搀椀攀渀挀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceCode_L__c] [nvarchar](152) NULL,਍ऀ嬀䴀圀䌀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[MPNCode__c] [varchar](1) NOT NULL,਍ऀ嬀䴀圀䘀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DPNCode__c] [varchar](1) NOT NULL,਍ऀ嬀䐀圀䘀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DWCCode__c] [varchar](1) NOT NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
