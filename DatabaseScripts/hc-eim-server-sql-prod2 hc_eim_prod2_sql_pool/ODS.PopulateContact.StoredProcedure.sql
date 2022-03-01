/****** Object:  StoredProcedure [ODS].[PopulateContact]    Script Date: 3/1/2022 8:53:37 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀倀漀瀀甀氀愀琀攀䌀漀渀琀愀挀琀崀 䄀匀ഀ
BEGIN਍ഀ
    truncate table Reports.Contact਍    ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ䌀刀䔀䄀吀䔀 吀䔀䴀 吀䄀䈀䰀䔀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
਍ഀ
	CREATE TABLE #ContactTask਍ऀ⠀ഀ
		[Company] [nvarchar](18) NULL,਍ऀऀ嬀䰀攀愀搀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀ
		[GCLID] [nvarchar](100) NULL,਍ऀऀ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀ
		[Start_Date] [datetime] NULL,਍ऀऀ嬀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀ
		[Time] [time](7) NULL,਍ऀऀ嬀䐀愀礀倀愀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　⤀ 一唀䰀䰀Ⰰഀ
		[Hour] [varchar](10) NULL,਍ऀऀ嬀䴀椀渀甀琀攀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[Seconds] [smallint] NULL,਍ऀऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[FirstName] [nvarchar](100) NULL,਍ऀऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[MobilePhone] [nvarchar](100) NULL,਍ऀऀ嬀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀ
		[Sourcecode] [nvarchar](500) NULL,਍ऀऀ嬀䐀椀愀氀攀搀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀 ⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[PhoneNumberAreaCode] [nvarchar](10) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignChannel] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignName] [nvarchar](80) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignCompany] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignBudgetName] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignPromotionCode] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignStartDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀ
		[CampaignStatus] [nvarchar](50) NULL,਍ऀऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[TotalTime] [bigint] NULL,਍ऀऀ嬀䤀嘀刀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀ
		[TalkTime] [bigint] NULL,਍ऀऀ嬀刀愀眀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[AbandonedContact] [int] NULL,਍ऀऀ嬀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[QualifiedContact] [int] NULL,਍ऀऀ嬀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[Pkid] [varchar](1024) NULL,਍ऀऀ嬀吀愀猀欀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[TollFreeName] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[original_destination_phone] [varchar](1024) NULL,਍ऀऀ嬀挀甀猀琀漀洀㈀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[OriginalCampaign__c][varchar](1024) NULL਍ഀ
	)਍ഀ
	CREATE TABLE #ContactBP਍ऀ⠀ഀ
		[Company] [nvarchar](18) NULL,਍ऀऀ嬀䰀攀愀搀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀ
		[GCLID] [nvarchar](100) NULL,਍ऀऀ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀ
		[Start_Date] [datetime] NULL,਍ऀऀ嬀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀ
		[Time] [time](7) NULL,਍ऀऀ嬀䐀愀礀倀愀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　⤀ 一唀䰀䰀Ⰰഀ
		[Hour] [varchar](10) NULL,਍ऀऀ嬀䴀椀渀甀琀攀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[Seconds] [smallint] NULL,਍ऀऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[FirstName] [nvarchar](100) NULL,਍ऀऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[MobilePhone] [nvarchar](100) NULL,਍ऀऀ嬀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀ
		[Sourcecode] [nvarchar](500) NULL,਍ऀऀ嬀䐀椀愀氀攀搀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀 ⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[PhoneNumberAreaCode] [nvarchar](10) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignChannel] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignName] [nvarchar](80) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignCompany] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignBudgetName] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignPromotionCode] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignStartDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀ
		[CampaignStatus] [nvarchar](50) NULL,਍ऀऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[TotalTime] [bigint] NULL,਍ऀऀ嬀䤀嘀刀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀ
		[TalkTime] [bigint] NULL,਍ऀऀ嬀刀愀眀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[AbandonedContact] [int] NULL,਍ऀऀ嬀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[QualifiedContact] [int] NULL,਍ऀऀ嬀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[Pkid] [varchar](1024) NULL,਍ऀऀ嬀吀愀猀欀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[TollFreeName] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[original_destination_phone] [varchar](1024) NULL,਍ऀऀ嬀挀甀猀琀漀洀㈀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[OriginalCampaign__c][varchar](1024) NULL਍ऀ⤀ഀ
਍ऀ䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀吀愀戀氀攀ഀ
	(਍ऀऀ嬀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀ
		[LeadID] [nvarchar](18) NULL,਍ऀऀ嬀䜀䌀䰀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[HashedEmail] [varchar](4000) NULL,਍ऀऀ嬀匀琀愀爀琀开䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀ
		[Date] [date] NULL,਍ऀऀ嬀吀椀洀攀崀 嬀琀椀洀攀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀ
		[DayPart] [nvarchar](20) NULL,਍ऀऀ嬀䠀漀甀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀ
		[Minute] [smallint] NULL,਍ऀऀ嬀匀攀挀漀渀搀猀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[LastName] [nvarchar](100) NULL,਍ऀऀ嬀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[Phone] [nvarchar](100) NULL,਍ऀऀ嬀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[Email] [nvarchar](200) NULL,਍ऀऀ嬀匀漀甀爀挀攀挀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀ
		[DialedNumber] [nvarchar] (100) NULL,਍ऀऀ嬀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignAgency] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignMedium] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignFormat] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignLocation] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignLanguage] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignLandingPageURL] [nvarchar](1250) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀ
		[CampaignEndDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[PostalCode] [nvarchar](50) NULL,਍ऀऀ嬀吀漀琀愀氀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀ
		[IVRTime] [bigint] NULL,਍ऀऀ嬀吀愀氀欀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀ
		[RawContact] [int] NULL,਍ऀऀ嬀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[Contact] [int] NULL,਍ऀऀ嬀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀ
		[NonQualifiedContact] [int] NULL,਍ऀऀ嬀倀欀椀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[TaskId] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[TollFreeMobileName] [varchar](1024) NULL,਍ऀऀ嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[custom2] [varchar](1024) NULL,਍ऀऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀ഀ
	)਍ഀ
	create TABLE #temporalSource਍ऀ⠀ഀ
		id varchar(250) NULL,਍ऀऀ渀愀洀攀猀 瘀愀爀挀栀愀爀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀ
		value varchar(250) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignChannel] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignName] [nvarchar](80) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignCompany] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignBudgetName] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignPromotionCode] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀ
		[CampaignEndDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀ഀ
਍ऀ⤀ഀ
਍ऀ挀爀攀愀琀攀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀漀爀愀氀倀栀漀渀攀ഀ
	(਍ऀऀ椀搀 瘀愀爀挀栀愀爀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀ
		names varchar(250) NULL,਍ऀऀ瘀愀氀甀攀 瘀愀爀挀栀愀爀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[TollFreeName] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀ
		[CampaignAgency] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignMedium] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignFormat] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignLocation] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignLanguage] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀ
		[CampaignStartDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀ
		[CampaignStatus] [nvarchar](50) NULL਍ഀ
	)਍ഀ
਍    挀爀攀愀琀攀 琀愀戀氀攀 ⌀琀愀猀欀ഀ
    (਍        䤀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
        CreatedDate datetime,਍        䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
        Result varchar(50),਍        䤀猀䈀攀䈀愀挀欀 戀椀琀Ⰰഀ
        IsOld bit,਍        䤀猀伀瀀瀀漀爀琀甀渀椀琀礀䌀氀漀猀攀搀 戀椀琀Ⰰഀ
        SourceCode varchar(50),਍        䌀攀渀琀攀爀一甀洀戀攀爀 椀渀琀Ⰰഀ
        ActivityDate datetime,਍        眀栀漀椀搀 一嘀䄀刀䌀䠀䄀刀⠀㔀　⤀Ⰰഀ
        Accomodation varchar(50),਍        䌀爀攀愀琀攀搀䐀愀琀攀䔀猀琀 搀愀琀攀琀椀洀攀ഀ
    )਍ഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ䤀一匀䔀刀吀 䤀一吀伀 吀䄀䈀䰀䔀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
਍ഀ
	INSERT INTO #ContactTask਍ऀ匀䔀䰀䔀䌀吀   ⴀⴀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 琀⸀圀栀漀䤀搀 伀刀䐀䔀刀 䈀夀 琀⸀䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ 琀⸀匀琀愀爀琀吀椀洀攀开开挀 䄀匀䌀⤀ 䄀匀 ✀刀漀眀䤀䐀✀Ⰰഀ
		   CASE WHEN(ct.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'਍ऀऀऀऀ䔀䰀匀䔀 ✀䠀愀椀爀挀氀甀戀✀ഀ
				END AS Company,਍ऀऀ   氀⸀䰀攀愀搀䤀搀 䄀匀 䰀攀愀搀䤀䐀Ⰰഀ
		   l.GCLID AS GCLID,਍ऀऀ   䰀伀圀䔀刀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀⠀㄀㈀㠀⤀Ⰰ栀愀猀栀戀礀琀攀猀⠀✀匀䠀䄀㈀开㈀㔀㘀✀Ⰰ 伀䐀匀⸀嘀愀氀椀搀䴀愀椀氀⠀氀⸀䰀攀愀搀䔀洀愀椀氀⤀ ⤀Ⰰ㈀⤀⤀ 䄀匀 ✀䠀愀猀栀攀搀䔀洀愀椀氀✀Ⰰഀ
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time)਍ऀऀऀऀ䔀䰀匀䔀 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ഀ
				END as 'Start_Date',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 䤀匀 一伀吀 一唀䰀䰀⤀ 吀䠀䔀一 挀愀猀琀⠀搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀ 愀猀 搀愀琀攀⤀ഀ
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,t.AppointmentDate)    AT TIME ZONE 'Eastern Standard Time'),t.AppointmentDate) as date)਍ऀऀऀऀ䔀一䐀 愀猀 䐀愀琀攀Ⰰഀ
		   CASE WHEN (cast(bpcd.start_time as time) is null) THEN cast(t.AppointmentDate as time)਍ऀऀऀऀ䔀䰀匀䔀 挀愀猀琀⠀搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀ 愀猀 琀椀洀攀⤀ഀ
				END as time,਍ऀऀ   搀琀搀⸀䐀愀礀倀愀爀琀 䄀匀 ✀䐀愀礀倀愀爀琀✀Ⰰഀ
		   dtd.[Hour] AS 'Hour',਍ऀऀ   搀琀搀⸀嬀洀椀渀甀琀攀崀 䄀匀 ✀䴀椀渀甀琀攀✀Ⰰഀ
		   dtd.[Second] AS 'Seconds',਍ऀऀ   吀刀䤀䴀⠀氀⸀䰀攀愀搀䰀愀猀琀渀愀洀攀⤀Ⰰഀ
		   TRIM(l.LeadFirstName),਍ऀऀ   刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀嬀䰀攀愀搀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 愀猀 ✀倀栀漀渀攀✀Ⰰഀ
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[LeadMobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone',਍ऀऀ   吀刀䤀䴀⠀氀⸀䰀攀愀搀䔀洀愀椀氀⤀Ⰰഀ
		   CASE WHEN (bpcd.custom2 IS NULL) THEN l.LeadSource਍ऀऀऀऀ䔀䰀匀䔀 戀瀀挀搀⸀挀甀猀琀漀洀㈀ഀ
				END AS 'Sourcecode',਍ऀऀ   一唀䰀䰀 䄀匀 嬀䐀椀愀氀攀搀一甀洀戀攀爀崀Ⰰഀ
		   left(l.LeadPhone,3) AS 'PhoneNumberAreaCode',਍ऀऀ   挀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀✀Ⰰഀ
		   c.CampaignChannel  AS 'CampaignChannel',਍ऀऀ   挀⸀䌀愀洀瀀愀椀最渀䴀攀搀椀愀 䄀匀 ✀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀✀Ⰰഀ
		   c.[CampaignName] AS 'CampaignName',਍ऀऀ   挀⸀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀 䄀匀 ✀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀✀Ⰰഀ
		   c.[CampaignLocation] AS 'CampaignLocation',਍ऀऀ   渀甀氀氀 䄀匀 ✀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀✀Ⰰഀ
		   CASE WHEN (c.[CampaignLocation] LIKE '%BARTH%' OR c.[CampaignLocation] LIKE '%LOCAL US%') THEN 'Barth'਍ऀऀऀऀ圀䠀䔀一 ⠀挀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─䌀䄀一䄀䐀䄀─✀ 伀刀 挀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─一䄀吀䤀伀一䄀䰀 䌀䄀─✀ 伀刀 挀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─䰀伀䌀䄀䰀 䌀䄀─✀⤀ 吀䠀䔀一 ✀䌀愀渀愀搀愀✀ഀ
				WHEN (c.[CampaignLocation] LIKE '%USA%' OR c.[CampaignLocation] LIKE '%NATIONAL US%') THEN 'United States'਍ऀऀऀऀ圀䠀䔀一 ⠀挀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─䔀䌀伀䴀䴀䔀刀䌀䔀─✀⤀ 吀䠀䔀一 ✀䔀挀漀洀洀攀爀挀攀✀ഀ
				WHEN (c.[CampaignLocation] LIKE '%HANS%') THEN 'Hans'਍ऀऀऀऀ圀䠀䔀一 ⠀挀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─倀唀䔀刀吀伀 刀䤀䌀伀─✀⤀ 吀䠀䔀一 ✀倀甀攀爀琀漀 刀椀挀漀✀ഀ
				ELSE਍ऀऀऀऀ✀唀渀欀渀漀眀渀✀ 䔀一䐀 䄀匀 ✀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀✀Ⰰഀ
		   c.[CampaignLanguage] AS 'CampaignLanguage',਍ऀऀ   渀甀氀氀 䄀匀 ✀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀✀Ⰰഀ
		   null AS 'CampaignLandingPageURL',਍ऀऀ   挀⸀匀吀䄀刀吀䐀䄀吀䔀 䄀匀 ✀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀✀Ⰰഀ
		   c.ENDDATE AS 'CampaignEndDate',਍ऀऀ   挀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀✀Ⰰഀ
		   l.[LeadPostalCode] AS 'PostalCode',਍ऀऀ   戀瀀挀搀⸀嬀搀甀爀愀琀椀漀渀崀  䄀匀 ✀吀漀琀愀氀吀椀洀攀✀Ⰰഀ
		   bpcd.[ivr_time] AS 'IVRTime',਍ऀऀ   戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 䄀匀 ✀吀愀氀欀吀椀洀攀✀Ⰰഀ
		   1 AS 'RawContact',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 伀刀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀✀Ⰰഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] > 0 ) THEN 1 ELSE 0 END AS 'Contact',਍ऀऀ   䌀䄀匀䔀ऀ圀䠀䔀一 ⠀⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 一伀吀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 䄀一䐀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 渀漀琀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 䄀一䐀 戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 㸀㴀 㘀　 ⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀✀Ⰰഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] < 60 ) THEN 1 ELSE 0 END AS 'NonQualifiedContact',਍ऀऀ   戀瀀挀搀⸀瀀欀椀搀 愀猀 ✀倀欀椀搀✀Ⰰഀ
		   t.AppointmentId as 'TaskId',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 爀椀最栀琀⠀氀⸀䰀攀愀搀匀漀甀爀挀攀Ⰰ㈀⤀ 㴀 ✀䐀倀✀ 吀䠀䔀一 挀⸀嬀吀漀氀氀䘀爀攀攀一愀洀攀崀ഀ
				WHEN right(l.LeadSource,2) NOT LIKE 'MP' THEN c.[TollFreeName]਍ऀऀऀऀ䔀䰀匀䔀 一唀䰀䰀 䔀一䐀 䄀匀 ✀吀漀氀氀䘀爀攀攀一愀洀攀✀Ⰰഀ
		   CASE WHEN right(l.LeadSource,2) = 'MP' THEN c.[TollFreeMobileName]਍ऀऀऀऀ圀䠀䔀一 爀椀最栀琀⠀氀⸀䰀攀愀搀匀漀甀爀挀攀Ⰰ㈀⤀ 一伀吀 䰀䤀䬀䔀 ✀䐀倀✀ 吀䠀䔀一 挀⸀嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀ഀ
				ELSE NULL END AS 'TollFreeMobileName',਍ऀऀ   戀瀀挀搀⸀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀Ⰰഀ
		   bpcd.custom2,਍ऀऀ   氀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀崀ഀ
	--INTO #Activities਍ऀ䘀刀伀䴀 搀戀漀⸀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀 琀ഀ
		LEFT OUTER JOIN dbo.VWLead l਍ऀऀऀ伀一 氀⸀氀攀愀搀䤀搀 㴀 琀⸀䰀攀愀搀䤀搀ഀ
		LEFT OUTER JOIN dbo.DimCampaign c਍ऀऀऀ伀一 挀⸀䌀愀洀瀀愀椀最渀䤀搀 㴀 氀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀ
		LEFT OUTER JOIN [ODS].[BP_CallDetail] bpcd਍ऀऀऀ伀一 吀刀䤀䴀⠀戀瀀挀搀⸀挀甀猀琀漀洀㌀⤀ 㴀 吀刀䤀䴀⠀琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀⤀ഀ
 		LEFT OUTER JOIN [dbo].[DimTimeOfDay] dtd਍ ऀऀऀ伀一 搀琀搀⸀嬀吀椀洀攀㈀㐀崀 㴀 挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀Ⰰ䤀匀一唀䰀䰀⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀Ⰰ琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀Ⰰ㠀⤀ഀ
 		LEFT OUTER JOIN [ODS].[CNCT_Center] cn਍ ऀऀऀ伀一 氀⸀䌀攀渀琀攀爀一甀洀戀攀爀 㴀 挀渀⸀䌀攀渀琀攀爀一甀洀戀攀爀 愀渀搀 挀渀⸀䤀猀䄀挀琀椀瘀攀䘀氀愀最 㴀 ✀㄀✀ഀ
 		LEFT OUTER JOIN [ODS].[CNCT_CenterType] ct਍ ऀऀऀ伀一 挀渀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀ഀ
਍ഀ
਍ഀ
		 -- AND t.whoId in (Select * from #NewLeads)਍ഀ
਍ഀ
਍ऀ䤀一匀䔀刀吀 䤀一吀伀  ⌀䌀漀渀琀愀挀琀䈀倀ഀ
	SELECT   --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一⠀一唀䰀䰀 㴀 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀⤀ 吀䠀䔀一 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀ഀ
				ELSE 'Hairclub'਍ऀऀऀऀ䔀一䐀 䄀匀 ✀䌀漀洀瀀愀渀礀✀Ⰰഀ
		   l.LeadId AS 'LeadID',਍ऀऀ   氀⸀䜀䌀䰀䤀䐀 䄀匀 ✀䜀䌀䰀䤀䐀✀Ⰰഀ
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', ODS.ValidMail(l.LeadEmail) ),2)) AS 'HashedEmail',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 䤀匀 一伀吀 一唀䰀䰀⤀ 吀䠀䔀一 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀ഀ
				END as 'Start_Date',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 䤀匀 一伀吀 一唀䰀䰀⤀ 吀䠀䔀一 挀愀猀琀⠀搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀⤀ 愀猀 搀愀琀攀⤀ഀ
				END as Date,਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀挀愀猀琀⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 愀猀 琀椀洀攀⤀ 椀猀 渀甀氀氀⤀ 吀䠀䔀一 渀甀氀氀ഀ
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as time)਍ऀऀऀऀ䔀一䐀 愀猀 琀椀洀攀Ⰰഀ
		   dtd.DayPart AS 'DayPart',਍ऀऀ   搀琀搀⸀嬀䠀漀甀爀崀 䄀匀 ✀䠀漀甀爀✀Ⰰഀ
		   dtd.[minute] AS 'Minute',਍ऀऀ   搀琀搀⸀嬀匀攀挀漀渀搀崀 䄀匀 ✀匀攀挀漀渀搀猀✀Ⰰഀ
		   TRIM(l.LeadLastname),਍ऀऀ   吀刀䤀䴀⠀氀⸀䰀攀愀搀䘀椀爀猀琀一愀洀攀⤀Ⰰഀ
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[LeadPhone],'(',''),')',''),' ',''),'-','') as 'Phone',਍ऀऀ   刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀嬀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䄀匀 ✀䴀漀戀椀氀攀倀栀漀渀攀✀Ⰰഀ
		   TRIM(l.LeadEmail),਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀挀甀猀琀漀洀㈀ 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 一唀䰀䰀ഀ
				ELSE bpcd.custom2਍ऀऀऀऀ䔀一䐀 䄀匀 ✀匀漀甀爀挀攀挀漀搀攀✀Ⰰഀ
		   CASE WHEN bpcd.caller_phone_type = 'External' THEN RIGHT(bpcd.initial_original_destination_phone,10)਍ऀऀ   䔀䰀匀䔀 ✀唀渀欀渀漀眀渀✀ഀ
		   END AS [DialedNumber],਍ऀऀ   氀攀昀琀⠀氀⸀䰀攀愀搀倀栀漀渀攀Ⰰ㌀⤀ 䄀匀 ✀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀✀Ⰰഀ
		   NULL AS 'CampaignAgency',਍ऀऀ   一唀䰀䰀  䄀匀 ✀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀✀Ⰰഀ
		   NULL AS 'CampaignMedium',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀一愀洀攀✀Ⰰഀ
		   NULL AS 'CampaignFormat',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀✀Ⰰഀ
		   NULL AS 'CampaignCompany',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀一唀䰀䰀 䰀䤀䬀䔀 ✀─䈀䄀刀吀䠀─✀ 伀刀 一唀䰀䰀 䰀䤀䬀䔀 ✀─䰀伀䌀䄀䰀 唀匀─✀⤀ 吀䠀䔀一 ✀䈀愀爀琀栀✀ഀ
				WHEN (NULL LIKE '%CANADA%' OR NULL LIKE '%NATIONAL CA%' OR NULL LIKE '%LOCAL CA%') THEN 'Canada'਍ऀऀऀऀ圀䠀䔀一 ⠀一唀䰀䰀 䰀䤀䬀䔀 ✀─唀匀䄀─✀ 伀刀 一唀䰀䰀 䰀䤀䬀䔀 ✀─一䄀吀䤀伀一䄀䰀 唀匀─✀⤀ 吀䠀䔀一 ✀唀渀椀琀攀搀 匀琀愀琀攀猀✀ഀ
				WHEN (NULL LIKE '%ECOMMERCE%') THEN 'Ecommerce'਍ऀऀऀऀ圀䠀䔀一 ⠀一唀䰀䰀 䰀䤀䬀䔀 ✀─䠀䄀一匀─✀⤀ 吀䠀䔀一 ✀䠀愀渀猀✀ഀ
				WHEN (NULL LIKE '%PUERTO RICO%') THEN 'Puerto Rico'਍ऀऀऀऀ䔀䰀匀䔀ഀ
				'Unknown' END AS 'CampaignBudgetName',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀✀Ⰰഀ
		   NULL AS 'CampaignPromotionCode',਍ऀऀ   渀甀氀氀 䄀匀 ✀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀✀Ⰰഀ
		   NULL AS 'CampaignStartDate',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀✀Ⰰഀ
		   NULL AS 'CampaignStatus',਍ऀऀ   一唀䰀䰀 䄀匀 ✀倀漀猀琀愀氀䌀漀搀攀✀Ⰰഀ
		   bpcd.[duration]  AS 'TotalTime',਍ऀऀ   戀瀀挀搀⸀嬀椀瘀爀开琀椀洀攀崀 䄀匀 ✀䤀嘀刀吀椀洀攀✀Ⰰഀ
		   bpcd.[talk_time] AS 'TalkTime',਍ऀऀ   ㄀ 䄀匀 ✀刀愀眀䌀漀渀琀愀挀琀✀Ⰰഀ
		   CASE WHEN (bpcd.[disposition] like 'Abandon%' OR bpcd.[disposition] like 'System_dis%') THEN 1 ELSE 0 END AS 'AbandonedContact',਍ऀऀ   䌀䄀匀䔀ऀ圀䠀䔀一 ⠀⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 一伀吀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 䄀一䐀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 渀漀琀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 䄀一䐀 戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 㸀 　 ⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀䌀漀渀琀愀挀琀✀Ⰰഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] >= 60 ) THEN 1 ELSE 0 END AS 'QualifiedContact',਍ऀऀ   䌀䄀匀䔀ऀ圀䠀䔀一 ⠀⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 一伀吀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 䄀一䐀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 渀漀琀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 䄀一䐀 戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 㰀 㘀　 ⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀✀Ⰰഀ
		   bpcd.pkid as 'Pkid',਍ऀऀ   一唀䰀䰀 愀猀 ✀吀愀猀欀䤀搀✀Ⰰഀ
		   NULL as 'TollFreeName',਍ऀऀ   一唀䰀䰀 愀猀 ✀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀✀Ⰰഀ
		   bpcd.original_destination_phone,਍ऀऀ   戀瀀挀搀⸀挀甀猀琀漀洀㈀Ⰰഀ
		   l.OriginalCampaignId਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䈀倀开䌀愀氀氀䐀攀琀愀椀氀崀 戀瀀挀搀ഀ
		LEFT OUTER JOIN dbo.VWLead l਍ऀऀऀ伀一 氀⸀䰀攀愀搀䤀搀 㴀 吀刀䤀䴀⠀戀瀀挀搀⸀䌀甀猀琀漀洀㄀⤀ഀ
		LEFT OUTER JOIN [dbo].[DimTimeOfDay] dtd਍ऀऀऀ伀一 搀琀搀⸀嬀吀椀洀攀㈀㐀崀 㴀 挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀Ⰰ戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀Ⰰ㠀⤀ഀ
	WHERE ((bpcd.caller_phone_type = 'External'਍ऀऀऀ䄀一䐀 戀瀀挀搀⸀挀愀氀氀攀攀开瀀栀漀渀攀开琀礀瀀攀 㴀 ✀䤀渀琀攀爀渀愀氀✀ഀ
			AND ISNULL(bpcd.service_name, '') NOT LIKE '%sms%')਍ऀऀऀ伀刀 ⠀⠀戀瀀挀搀⸀挀愀氀氀攀爀开瀀栀漀渀攀开琀礀瀀攀 㴀 ✀䔀砀琀攀爀渀愀氀✀ 伀刀 戀瀀挀搀⸀挀愀氀氀攀爀开瀀栀漀渀攀开琀礀瀀攀 䤀匀 一唀䰀䰀⤀ഀ
                               AND (bpcd.callee_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)਍                               䄀一䐀 䤀匀一唀䰀䰀⠀戀瀀挀搀⸀猀攀爀瘀椀挀攀开渀愀洀攀Ⰰ ✀✀⤀ 䰀䤀䬀䔀 ✀─椀渀戀漀甀渀搀─✀⤀⤀ 䄀一䐀 戀瀀挀搀⸀挀甀猀琀漀洀㄀ 渀漀琀 椀渀 ⠀猀攀氀攀挀琀 氀攀愀搀椀搀 昀爀漀洀 ⌀䌀漀渀琀愀挀琀吀愀猀欀⤀ 愀渀搀 戀瀀挀搀⸀挀甀猀琀漀洀㄀ 椀猀 渀漀琀 渀甀氀氀㬀ഀ
			--AND bpcd.custom1 in (Select * from #NewLeads);਍ഀ
਍ഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ唀一䤀伀一 伀䘀 吀䠀䔀 吀䄀䈀䰀䔀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
਍ऀ䤀渀猀攀爀琀 椀渀琀漀ഀ
	#ContactTable਍ऀ匀攀氀攀挀琀 ⨀ഀ
	FROM #ContactTask਍ऀ甀渀椀漀渀 愀氀氀ഀ
	Select *਍ऀ䘀爀漀洀 ⌀䌀漀渀琀愀挀琀䈀倀ഀ
਍ഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ唀倀䐀䄀吀䔀 吀䄀䈀䰀䔀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
਍ഀ
UPDATE #ContactTable਍匀䔀吀ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀吀礀瀀攀崀Ⰰഀ
		[CampaignChannel] = t2.CampaignChannel,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 㴀 琀㈀⸀䌀愀洀瀀愀椀最渀䴀攀搀椀愀Ⰰഀ
		[CampaignName] = t2.[CampaignName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 琀㈀⸀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀Ⰰഀ
		[CampaignCompany] = null,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀Ⰰഀ
		--[CampaignBudgetName] = t2.[CampaignBudgetName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀Ⰰഀ
		[CampaignPromotionCode] = t2.[CampaignPromoDescription],਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 㴀 琀㈀⸀匀吀䄀刀吀䐀䄀吀䔀Ⰰഀ
		[CampaignEndDate] = t2.ENDDATE,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀ
  FROM dbo.DimCampaign t2਍  圀栀攀爀攀 ⠀⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀 㴀 琀㈀⸀䌀愀洀瀀愀椀最渀䤀搀⤀ 䄀一䐀ഀ
   (#ContactTable.[CampaignAgency] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀ
		#ContactTable.[CampaignMedium] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀ
		#ContactTable.[CampaignFormat] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀ
		#ContactTable.[CampaignLocation] IS NULL AND਍ऀऀⴀⴀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀ
		#ContactTable.[CampaignLanguage] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀ
		#ContactTable.[CampaignStartDate] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀ
		#ContactTable.[CampaignStatus] IS NULL)਍ഀ
---------------------------------------------------------INSERT INTO CONTACTS----------------------------------------------਍ഀ
	INSERT INTO [Reports].[Contact] ([Company]਍      Ⰰ嬀䰀攀愀搀䤀䐀崀ഀ
      ,[GCLID]਍      Ⰰ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀ഀ
      ,[Start_Date]਍      Ⰰ嬀䐀愀琀攀崀ഀ
      ,[Time]਍      Ⰰ嬀䐀愀礀倀愀爀琀崀ഀ
      ,[Hour]਍      Ⰰ嬀䴀椀渀甀琀攀崀ഀ
      ,[Seconds]਍      Ⰰ嬀䰀愀猀琀一愀洀攀崀ഀ
      ,[FirstName]਍      Ⰰ嬀倀栀漀渀攀崀ഀ
      ,[MobilePhone]਍      Ⰰ嬀䔀洀愀椀氀崀ഀ
      ,[Sourcecode]਍ऀ  Ⰰ嬀䐀椀愀氀攀搀一甀洀戀攀爀崀ഀ
      ,[PhoneNumberAreaCode]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀ഀ
      ,[CampaignChannel]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀ഀ
      ,[CampaignName]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀ
      ,[CampaignCompany]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀ഀ
      ,[CampaignBudgetName]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀ഀ
      ,[CampaignPromotionCode]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀崀ഀ
      ,[CampaignStartDate]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀ
      ,[CampaignStatus]਍      Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀ഀ
      ,[TotalTime]਍      Ⰰ嬀䤀嘀刀吀椀洀攀崀ഀ
      ,[TalkTime]਍      Ⰰ嬀刀愀眀䌀漀渀琀愀挀琀崀ഀ
      ,[AbandonedContact]਍      Ⰰ嬀䌀漀渀琀愀挀琀崀ഀ
      ,[QualifiedContact]਍      Ⰰ嬀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀ഀ
	  ,[Pkid]਍ऀ  Ⰰ嬀吀愀猀欀䤀搀崀ഀ
	  ,[TollFreeName]਍ऀ  Ⰰ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀⤀ഀ
਍ऀ  匀䔀䰀䔀䌀吀ഀ
	   [Company]਍      Ⰰ嬀䰀攀愀搀䤀䐀崀ഀ
      ,[GCLID]਍      Ⰰ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀ഀ
      ,[Start_Date]਍      Ⰰ嬀䐀愀琀攀崀ഀ
      ,[Time]਍      Ⰰ嬀䐀愀礀倀愀爀琀崀ഀ
      ,[Hour]਍      Ⰰ嬀䴀椀渀甀琀攀崀ഀ
      ,[Seconds]਍      Ⰰ嬀䰀愀猀琀一愀洀攀崀ഀ
      ,[FirstName]਍      Ⰰ嬀倀栀漀渀攀崀ഀ
      ,[MobilePhone]਍      Ⰰ嬀䔀洀愀椀氀崀ഀ
      ,[Sourcecode]਍ऀ  Ⰰ嬀䐀椀愀氀攀搀一甀洀戀攀爀崀ഀ
      ,[PhoneNumberAreaCode]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀ഀ
      ,[CampaignChannel]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀ഀ
      ,[CampaignName]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀ
      ,[CampaignCompany]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀ഀ
      ,[CampaignBudgetName]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀ഀ
      ,[CampaignPromotionCode]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀崀ഀ
      ,[CampaignStartDate]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀ
      ,[CampaignStatus]਍      Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀ഀ
      ,[TotalTime]਍      Ⰰ嬀䤀嘀刀吀椀洀攀崀ഀ
      ,[TalkTime]਍      Ⰰ嬀刀愀眀䌀漀渀琀愀挀琀崀ഀ
      ,[AbandonedContact]਍      Ⰰ嬀䌀漀渀琀愀挀琀崀ഀ
      ,[QualifiedContact]਍      Ⰰ嬀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀ഀ
	  ,[Pkid]਍ऀ  Ⰰ嬀吀愀猀欀䤀搀崀ഀ
	  ,[TollFreeName]਍ऀ  Ⰰ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀ഀ
	  FROM #ContactTable਍ഀ
	DROP TABLE #ContactTask਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀䈀倀ഀ
	DROP TABLE #ContactTable਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀漀爀愀氀匀漀甀爀挀攀ഀ
	DROP TABLE #temporalPhone਍    搀爀漀瀀 琀愀戀氀攀 ⌀琀愀猀欀ഀ
਍䔀一䐀ഀഀ
GO਍
