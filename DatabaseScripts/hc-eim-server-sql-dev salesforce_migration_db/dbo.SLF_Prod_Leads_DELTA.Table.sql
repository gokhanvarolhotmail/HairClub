/****** Object:  Table [dbo].[SLF_Prod_Leads_DELTA]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀开䐀䔀䰀吀䄀崀⠀ഀഀ
	[Id] [nvarchar](max) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[MasterRecordId] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[FirstName] [nvarchar](max) NULL,਍ऀ嬀匀愀氀甀琀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[MiddleName] [nvarchar](max) NULL,਍ऀ嬀匀甀昀昀椀砀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Name] [nvarchar](max) NULL,਍ऀ嬀吀椀琀氀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Company] [nvarchar](max) NULL,਍ऀ嬀匀琀爀攀攀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[City] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PostalCode] [nvarchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StateCode] [nvarchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Latitude] [decimal](38, 18) NULL,਍ऀ嬀䰀漀渀最椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[GeocodeAccuracy] [nvarchar](max) NULL,਍ऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[MobilePhone] [nvarchar](max) NULL,਍ऀ嬀䘀愀砀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Email] [nvarchar](max) NULL,਍ऀ嬀圀攀戀猀椀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PhotoUrl] [nvarchar](max) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadSource] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Industry] [nvarchar](max) NULL,਍ऀ嬀刀愀琀椀渀最崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](max) NULL,਍ऀ嬀䄀渀渀甀愀氀刀攀瘀攀渀甀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[NumberOfEmployees] [int] NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HasOptedOutOfEmail] [bit] NULL,਍ऀ嬀䤀猀䌀漀渀瘀攀爀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ConvertedDate] [datetime2](7) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ConvertedContactId] [nvarchar](max) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsUnreadByOwner] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](max) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastActivityDate] [datetime2](7) NULL,਍ऀ嬀䐀漀一漀琀䌀愀氀氀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[HasOptedOutOfFax] [bit] NULL,਍ऀ嬀䰀愀猀琀嘀椀攀眀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastReferencedDate] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀吀爀愀渀猀昀攀爀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Jigsaw] [nvarchar](max) NULL,਍ऀ嬀䨀椀最猀愀眀䌀漀渀琀愀挀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[EmailBouncedReason] [nvarchar](max) NULL,਍ऀ嬀䔀洀愀椀氀䈀漀甀渀挀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IndividualId] [nvarchar](max) NULL,਍ऀ嬀䜀攀渀搀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Language__c] [nvarchar](max) NULL,਍ऀ嬀䌀攀渀琀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalCampaign__c] [nvarchar](max) NULL,਍ऀ嬀倀爀漀洀漀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotEmail__c] [bit] NULL,਍ऀ嬀䐀漀一漀琀䴀愀椀氀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DoNotText__c] [bit] NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀匀瀀漀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossExperience__c] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀䘀愀洀椀氀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossProductUsed__c] [nvarchar](max) NULL,਍ऀ嬀䐀漀一漀琀䌀漀渀琀愀挀琀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[OpenTasks__c] [decimal](38, 18) NULL,਍ऀ嬀伀渀䌀匀攀猀猀椀漀渀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[OnCAffiliateID__c] [nvarchar](max) NULL,਍ऀ嬀䄀最攀刀愀渀最攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Age__c] [decimal](38, 18) NULL,਍ऀ嬀䈀椀爀琀栀搀愀礀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[DateofLastAppoint__c] [datetime2](7) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactStatus__c] [nvarchar](max) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀伀琀栀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ZipCode__c] [nvarchar](max) NULL,਍ऀ嬀倀栀漀渀攀䄀戀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Accommodation__c] [nvarchar](max) NULL,਍ऀ嬀倀爀漀洀漀开䌀漀搀攀开䰀攀最愀挀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Source_Code_Legacy__c] [nvarchar](max) NULL,਍ऀ嬀吀漀琀愀氀一甀洀戀攀爀漀昀䄀瀀瀀漀椀渀琀洀攀渀琀猀开开挀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentCampaign__c] [nvarchar](max) NULL,਍ऀ嬀刀攀挀攀渀琀倀爀漀洀漀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[DeviceType__c] [nvarchar](max) NULL,਍ऀ嬀䤀倀䄀搀搀爀攀猀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HTTPReferrer__c] [nvarchar](max) NULL,਍ऀ嬀伀渀䌀琀䰀愀猀琀䴀漀搀椀昀礀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[OnCtCreatedDate__c] [datetime2](7) NULL,਍ऀ嬀䐀甀瀀氀椀挀愀琀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[OnCtCreatedByUser__c] [nvarchar](max) NULL,਍ऀ嬀吀椀洀攀娀漀渀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ClientID__c] [nvarchar](max) NULL,਍ऀ嬀䐀䤀匀䌀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Ethnicity__c] [nvarchar](max) NULL,਍ऀ嬀䰀甀搀眀椀最匀挀愀氀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[MaritalStatus__c] [nvarchar](max) NULL,਍ऀ嬀一漀爀眀漀漀搀匀挀愀氀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Occupation__c] [nvarchar](max) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SolutionOffered__c] [nvarchar](max) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[OncOriginalCampaign__c] [nvarchar](max) NULL,਍ऀ嬀伀渀挀䰀愀猀琀唀瀀搀愀琀攀搀唀猀攀爀䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterID__c] [nvarchar](max) NULL,਍ऀ嬀匀椀攀戀攀氀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastProcessedDate__c] [datetime2](7) NULL,਍ऀ嬀吀漀䈀攀倀爀漀挀攀猀猀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[LastModifiedBy__c] [nvarchar](max) NULL,਍ऀ嬀䘀甀氀氀一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentCampaignID__c] [nvarchar](max) NULL,਍ऀ嬀匀䌀一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Notes__c] [nvarchar](max) NULL,਍ऀ嬀伀渀挀䈀愀琀挀栀倀爀漀挀攀猀猀攀搀䐀愀琀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[OncMinsSinceModified__c] [decimal](38, 18) NULL,਍ऀ嬀倀䌀一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[NoShows__c] [decimal](38, 18) NULL,਍ऀ嬀匀栀漀眀一漀匀愀氀攀开开挀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ShowSales__c] [decimal](38, 18) NULL,਍ऀ嬀匀䌀䴀愀琀挀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate__c] [datetime2](7) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䴀愀琀挀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[et4ae5__HasOptedOutOfMobile__c] [bit] NULL,਍ऀ嬀攀琀㐀愀攀㔀开开䴀漀戀椀氀攀开䌀漀甀渀琀爀礀开䌀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CaseSafeID__c] [nvarchar](max) NULL,਍ऀ嬀刀攀猀挀栀攀搀甀氀攀猀开开挀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ReportCreateDate__c] [datetime2](7) NULL,਍ऀ嬀伀瀀攀渀䄀瀀瀀漀椀渀琀䌀漀甀渀琀开开挀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[GCLID__c] [nvarchar](max) NULL,਍ऀ嬀䤀渀椀琀椀愀氀开吀愀猀欀开䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[State_Text__c] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀甀猀䴀愀琀挀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceTest__c] [nvarchar](max) NULL,਍ऀ嬀唀渀戀漀甀渀挀攀倀愀最攀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Source__c] [nvarchar](max) NULL,਍ऀ嬀匀甀戀洀椀琀琀攀爀䤀倀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[UnbounceSubmissionTime__c] [nvarchar](max) NULL,਍ऀ嬀唀渀戀漀甀渀挀攀倀愀最攀嘀愀爀椀愀渀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[UnbounceSubmissionDate__c] [datetime2](7) NULL,਍ऀ嬀氀攀愀搀挀愀瀀开开䘀愀挀攀戀漀漀欀开䰀攀愀搀开䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossOrVolume__c] [nvarchar](max) NULL,਍ऀ嬀䰀攀愀搀䌀爀攀愀琀椀漀渀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Consultation_Form__c] [nvarchar](max) NULL,਍ऀ嬀䄀挀琀椀瘀攀开唀猀攀爀开伀眀渀攀爀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[PostalCodeClean__c] [nvarchar](max) NULL,਍ऀ嬀䈀漀猀氀攀礀匀䘀䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CancelAppointCount__c] [decimal](38, 18) NULL,਍ऀ嬀䌀漀洀瀀氀攀琀椀漀渀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Current_Task_ActivityDate__c] [datetime2](7) NULL,਍ऀ嬀䌀甀爀爀攀渀琀开吀愀猀欀开䄀挀琀椀瘀椀琀礀吀礀瀀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Current_Task_StartTime__c] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀开䄀挀琀椀瘀椀琀礀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Last_Task_ActivityDate__c] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀开吀愀猀欀开刀攀猀甀氀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentSourceCode__c] [nvarchar](max) NULL,਍ऀ嬀䌀漀渀猀甀氀琀愀琀椀漀渀䘀漀爀洀唀刀䰀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ReferralCode__c] [nvarchar](max) NULL,਍ऀ嬀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀攀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[PreferredAppointmentTime__c] [nvarchar](max) NULL,਍ऀ嬀䠀愀爀搀䌀漀瀀礀倀爀攀昀攀爀爀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[SFMCExempt__c] [bit] NULL,਍ऀ嬀䰀攀愀搀开䄀挀琀椀瘀椀琀礀开匀琀愀琀甀猀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Service_Territory__c] [nvarchar](max) NULL,਍ऀ嬀䄀氀氀漀眀开嘀椀爀琀甀愀氀开䌀攀渀琀攀爀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[HWFormID__c] [nvarchar](max) NULL,਍ऀ嬀吀攀砀琀开刀攀洀椀渀攀爀开伀瀀琀开䤀渀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[DB_Created_Date_without_Time__c] [datetime2](7) NULL,਍ऀ嬀䐀䈀开䰀攀愀搀开䄀最攀开开挀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[lead_age__c] [decimal](38, 18) NULL,਍ऀ嬀一漀爀洀愀氀椀稀攀搀开瀀栀漀渀攀开渀甀洀戀攀爀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[MobilePhone_Number_Normalized__c] [nvarchar](80) NULL,਍ऀ嬀䐀一䌀开嘀愀氀椀搀愀琀椀漀渀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadMigration] [bit] NULL,਍ऀ嬀䤀猀䐀甀瀀氀椀挀愀琀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsValidLead] [bit] NULL,਍ऀ嬀䤀猀䰀攀愀搀匀栀漀眀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ShowDate] [datetime] NULL,਍ऀ嬀䤀猀䐀甀瀀氀椀挀愀琀攀倀䄀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[TaskStatus] [nvarchar](50) NULL,਍ऀ嬀吀愀猀欀刀攀猀甀氀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskAction] [nvarchar](100) NULL,਍ऀ嬀匀栀漀眀伀眀渀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
