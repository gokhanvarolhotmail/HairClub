/****** Object:  Table [ODS].[SQL06_SFDC_Task]    Script Date: 3/7/2022 8:42:24 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀匀儀䰀　㘀开匀䘀䐀䌀开吀愀猀欀崀ഀഀ
(਍ऀ嬀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[WhoId] [nvarchar](18) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䤀䐀开开挀崀 嬀渀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncContactID__c] [nchar](10) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterID__c] [nvarchar](50) NULL,਍ऀ嬀䄀挀琀椀漀渀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Result__c] [nvarchar](50) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀吀礀瀀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityDate] [datetime] NULL,਍ऀ嬀匀琀愀爀琀吀椀洀攀开开挀崀 嬀琀椀洀攀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CompletionDate__c] [datetime] NULL,਍ऀ嬀䔀渀搀吀椀洀攀开开挀崀 嬀琀椀洀攀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [nvarchar](18) NULL,਍ऀ嬀䰀攀愀搀伀渀挀䜀攀渀搀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncBirthday__c] [datetime] NULL,਍ऀ嬀伀挀挀甀瀀愀琀椀漀渀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncEthnicity__c] [nvarchar](100) NULL,਍ऀ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NorwoodScale__c] [nvarchar](100) NULL,਍ऀ嬀䰀甀搀眀椀最匀挀愀氀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncAge__c] [int] NULL,਍ऀ嬀倀攀爀昀漀爀洀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　㈀⤀ 一唀䰀䰀Ⰰഀഀ
	[PriceQuoted__c] [decimal](18, 2) NULL,਍ऀ嬀匀漀氀甀琀椀漀渀伀昀昀攀爀攀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NoSaleReason__c] [nvarchar](200) NULL,਍ऀ嬀䐀䤀匀䌀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[SaleTypeCode__c] [nvarchar](50) NULL,਍ऀ嬀匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceCode__c] [nvarchar](50) NULL,਍ऀ嬀倀爀漀洀漀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[TimeZone__c] [nvarchar](50) NULL,਍ऀ嬀伀渀挀䌀爀攀愀琀攀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[ReportCreateDate__c] [datetime] NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](18) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](18) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀刀攀挀攀椀瘀攀䈀爀漀挀栀甀爀攀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ReferralCode__c] [nvarchar](50) NULL,਍ऀ嬀䄀挀挀漀洀洀漀搀愀琀椀漀渀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[externalID] [varchar](50) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀䔀猀琀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[IsNew] [bit] NULL,਍ऀ嬀䤀猀伀氀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ContactKey] [int] NULL,਍ऀ嬀䌀漀渀琀愀挀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OpportunityAmmount] [numeric](38, 18) NULL,਍ऀ嬀伀瀀瀀漀琀甀渀椀琀礀䄀洀洀漀甀渀琀崀 嬀渀甀洀攀爀椀挀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
