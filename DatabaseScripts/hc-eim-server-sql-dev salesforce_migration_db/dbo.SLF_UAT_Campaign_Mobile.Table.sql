/****** Object:  Table [dbo].[SLF_UAT_Campaign_Mobile]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开唀䄀吀开䌀愀洀瀀愀椀最渀开䴀漀戀椀氀攀崀⠀ഀഀ
	[Id] [varchar](1) NOT NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ActualCost] [decimal](18, 0) NULL,਍ऀ嬀䈀甀搀最攀琀攀搀䌀漀猀琀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[Channel__c] [nvarchar](765) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfContacts] [int] NULL,਍ऀ嬀一甀洀戀攀爀伀昀䌀漀渀瘀攀爀琀攀搀䰀攀愀搀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](765) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Description] [nvarchar](max) NULL,਍ऀ嬀䐀椀愀氀攀爀䴀椀猀挀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀㤀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[EndDate] [nvarchar](4000) NULL,਍ऀ嬀䔀砀瀀攀挀琀攀搀刀攀猀瀀漀渀猀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀　Ⰰ ㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[ExpectedRevenue] [decimal](18, 0) NULL,਍ऀ嬀䰀愀渀最甀愀最攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfLeads] [int] NULL,਍ऀ嬀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀㌀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[NumberSent] [decimal](18, 0) NULL,਍ऀ嬀一甀洀戀攀爀伀昀伀瀀瀀漀爀琀甀渀椀琀椀攀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [nvarchar](18) NULL,਍ऀ嬀倀愀爀攀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Promo_Code__c] [nvarchar](18) NULL,਍ऀ嬀刀攀挀漀爀搀吀礀瀀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignMemberRecordTypeId] [nvarchar](18) NULL,਍ऀ嬀一甀洀戀攀爀伀昀刀攀猀瀀漀渀猀攀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[StartDate] [nvarchar](4000) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[TollFreeNumber__c] [nvarchar](18) NULL,਍ऀ嬀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[AmountAllOpportunities] [decimal](18, 0) NULL,਍ऀ嬀䄀洀漀甀渀琀圀漀渀伀瀀瀀漀爀琀甀渀椀琀椀攀猀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfWonOpportunities] [int] NULL,਍ऀ嬀䘀漀爀洀愀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Location__c] [nvarchar](765) NULL,਍ऀ嬀䴀攀搀椀愀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Audience__c] [nvarchar](765) NULL,਍ऀ嬀匀漀甀爀挀攀䌀漀搀攀开䰀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㔀㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[MWCCode__c] [varchar](1) NOT NULL,਍ऀ嬀䴀倀一䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[MWFCode__c] [varchar](1) NOT NULL,਍ऀ嬀䐀倀一䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DWFCode__c] [varchar](1) NOT NULL,਍ऀ嬀䐀圀䌀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
