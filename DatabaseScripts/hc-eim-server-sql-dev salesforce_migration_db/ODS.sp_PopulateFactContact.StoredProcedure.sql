/****** Object:  StoredProcedure [ODS].[sp_PopulateFactContact]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀猀瀀开倀漀瀀甀氀愀琀攀䘀愀挀琀䌀漀渀琀愀挀琀崀 䄀匀ഀഀ
BEGIN਍    吀刀唀一䌀䄀吀䔀 吀䄀䈀䰀䔀 嬀刀攀瀀漀爀琀猀崀⸀嬀䘀愀挀琀䌀漀渀琀愀挀琀崀ഀഀ
਍ഀഀ
-----------------------------------------------------CREATE TEM TABLES--------------------------------------------------਍ऀ䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀吀愀猀欀ഀഀ
	(਍ऀऀ嬀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
		[LeadID] [nvarchar](18) NULL,਍ऀऀ嬀䜀䌀䰀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[HashedEmail] [varchar](4000) NULL,਍ऀऀ嬀匀琀愀爀琀开䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
		[Date] [date] NULL,਍ऀऀ嬀吀椀洀攀崀 嬀琀椀洀攀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
		[DayPart] [nvarchar](20) NULL,਍ऀऀ嬀䠀漀甀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
		[Minute] [smallint] NULL,਍ऀऀ嬀匀攀挀漀渀搀猀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[LastName] [nvarchar](100) NULL,਍ऀऀ嬀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[Phone] [nvarchar](100) NULL,਍ऀऀ嬀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[Email] [nvarchar](200) NULL,਍ऀऀ嬀匀漀甀爀挀攀挀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[PhoneNumberAreaCode] [nvarchar](10) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignChannel] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignName] [nvarchar](80) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignCompany] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignBudgetName] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignPromotionCode] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignStartDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
		[CampaignStatus] [nvarchar](50) NULL,਍ऀऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[TotalTime] [bigint] NULL,਍ऀऀ嬀䤀嘀刀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[TalkTime] [bigint] NULL,਍ऀऀ嬀刀愀眀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[AbandonedContact] [int] NULL,਍ऀऀ嬀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[QualifiedContact] [int] NULL,਍ऀऀ嬀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[Pkid] [varchar](1024) NULL,਍ऀऀ嬀吀愀猀欀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[TollFreeName] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[original_destination_phone] [varchar](1024) NULL,਍ऀऀ嬀挀甀猀琀漀洀㈀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[OriginalCampaign__c][varchar](1024) NULL਍ഀഀ
	)਍ഀഀ
	CREATE TABLE #ContactBP਍ऀ⠀ഀഀ
		[Company] [nvarchar](18) NULL,਍ऀऀ嬀䰀攀愀搀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
		[GCLID] [nvarchar](100) NULL,਍ऀऀ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
		[Start_Date] [datetime] NULL,਍ऀऀ嬀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
		[Time] [time](7) NULL,਍ऀऀ嬀䐀愀礀倀愀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
		[Hour] [varchar](10) NULL,਍ऀऀ嬀䴀椀渀甀琀攀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[Seconds] [smallint] NULL,਍ऀऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[FirstName] [nvarchar](100) NULL,਍ऀऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[MobilePhone] [nvarchar](100) NULL,਍ऀऀ嬀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[Sourcecode] [nvarchar](500) NULL,਍ऀऀ嬀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignAgency] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignMedium] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignFormat] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLocation] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLanguage] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLandingPageURL] [nvarchar](1250) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
		[CampaignEndDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[PostalCode] [nvarchar](50) NULL,਍ऀऀ嬀吀漀琀愀氀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[IVRTime] [bigint] NULL,਍ऀऀ嬀吀愀氀欀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[RawContact] [int] NULL,਍ऀऀ嬀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[Contact] [int] NULL,਍ऀऀ嬀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[NonQualifiedContact] [int] NULL,਍ऀऀ嬀倀欀椀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[TaskId] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[TollFreeMobileName] [varchar](1024) NULL,਍ऀऀ嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[custom2] [varchar](1024) NULL,਍ऀऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀ഀഀ
	)਍ഀഀ
	CREATE TABLE #ContactTable਍ऀ⠀ഀഀ
		[Company] [nvarchar](18) NULL,਍ऀऀ嬀䰀攀愀搀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
		[GCLID] [nvarchar](100) NULL,਍ऀऀ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
		[Start_Date] [datetime] NULL,਍ऀऀ嬀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
		[Time] [time](7) NULL,਍ऀऀ嬀䐀愀礀倀愀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
		[Hour] [varchar](10) NULL,਍ऀऀ嬀䴀椀渀甀琀攀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[Seconds] [smallint] NULL,਍ऀऀ嬀䰀愀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[FirstName] [nvarchar](100) NULL,਍ऀऀ嬀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[MobilePhone] [nvarchar](100) NULL,਍ऀऀ嬀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[Sourcecode] [nvarchar](500) NULL,਍ऀऀ嬀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignAgency] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignMedium] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignFormat] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLocation] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLanguage] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLandingPageURL] [nvarchar](1250) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
		[CampaignEndDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[PostalCode] [nvarchar](50) NULL,਍ऀऀ嬀吀漀琀愀氀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[IVRTime] [bigint] NULL,਍ऀऀ嬀吀愀氀欀吀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[RawContact] [int] NULL,਍ऀऀ嬀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[Contact] [int] NULL,਍ऀऀ嬀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
		[NonQualifiedContact] [int] NULL,਍ऀऀ嬀倀欀椀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[TaskId] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[TollFreeMobileName] [varchar](1024) NULL,਍ऀऀ嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[custom2] [varchar](1024) NULL,਍ऀऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀ഀഀ
	)਍ഀഀ
	create TABLE #temporalSource਍ऀ⠀ഀഀ
		id varchar(250) NULL,਍ऀऀ渀愀洀攀猀 瘀愀爀挀栀愀爀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		value varchar(250) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignChannel] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignName] [nvarchar](80) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignCompany] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignBudgetName] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignPromotionCode] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
		[CampaignEndDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀ഀഀ
਍ऀ⤀ഀഀ
਍ऀ挀爀攀愀琀攀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀漀爀愀氀倀栀漀渀攀ഀഀ
	(਍ऀऀ椀搀 瘀愀爀挀栀愀爀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		names varchar(250) NULL,਍ऀऀ瘀愀氀甀攀 瘀愀爀挀栀愀爀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[TollFreeName] [varchar](1024) NULL,਍ऀऀ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignAgency] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignMedium] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignFormat] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLocation] [nvarchar](50) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignLanguage] [nvarchar](100) NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
		[CampaignStartDate] [datetime] NULL,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
		[CampaignStatus] [nvarchar](50) NULL਍ഀഀ
	)਍ऀഀഀ
----------------------------------------------INSERT INTO TABLES----------------------------------------------------਍ऀ䤀一匀䔀刀吀 䤀一吀伀 ⌀䌀漀渀琀愀挀琀吀愀猀欀ഀഀ
	SELECT --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一⠀挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 㴀 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀⤀ 吀䠀䔀一 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀ഀഀ
				ELSE 'Hairclub'਍ऀऀऀऀ䔀一䐀 䄀匀 ✀䌀漀洀瀀愀渀礀✀Ⰰഀഀ
		   l.id AS 'LeadID',਍ऀऀ   氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 ✀䜀䌀䰀䤀䐀✀Ⰰഀഀ
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', [ODS].[ValidMail](l.Email) ),2)) AS 'HashedEmail',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 䤀匀 一伀吀 一唀䰀䰀⤀ 吀䠀䔀一 戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀ഀഀ
				ELSE t.ActivityDate਍ऀऀऀऀ䔀一䐀 愀猀 ✀匀琀愀爀琀开䐀愀琀攀✀Ⰰഀഀ
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN cast(bpcd.start_time as date)਍ऀऀऀऀ䔀䰀匀䔀 挀愀猀琀⠀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 愀猀 搀愀琀攀⤀ഀഀ
				END as Date,਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀挀愀猀琀⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 愀猀 琀椀洀攀⤀ 椀猀 渀甀氀氀⤀ 吀䠀䔀一 挀愀猀琀⠀琀⸀䌀爀攀愀琀攀搀吀椀洀攀开开挀 愀猀 琀椀洀攀⤀ഀഀ
				ELSE cast(bpcd.start_time as time)਍ऀऀऀऀ䔀一䐀 愀猀 琀椀洀攀Ⰰഀഀ
		   dtd.DayPart AS 'DayPart',਍ऀऀ   搀琀搀⸀嬀䠀漀甀爀崀 䄀匀 ✀䠀漀甀爀✀Ⰰഀഀ
		   dtd.[minute] AS 'Minute',਍ऀऀ   搀琀搀⸀嬀匀攀挀漀渀搀崀 䄀匀 ✀匀攀挀漀渀搀猀✀Ⰰഀഀ
		   TRIM(l.LastName),਍ऀऀ   吀刀䤀䴀⠀氀⸀䘀椀爀猀琀一愀洀攀⤀Ⰰഀഀ
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[Phone],'(',''),')',''),' ',''),'-','') as 'Phone',਍ऀऀ   刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀嬀䴀漀戀椀氀攀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䄀匀 ✀䴀漀戀椀氀攀倀栀漀渀攀✀Ⰰഀഀ
		   TRIM(l.Email),਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀挀甀猀琀漀洀㈀ 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 琀⸀匀漀甀爀挀攀䌀漀搀攀开开挀 ഀഀ
				ELSE bpcd.custom2਍ऀऀऀऀ䔀一䐀 䄀匀 ✀匀漀甀爀挀攀挀漀搀攀✀Ⰰഀഀ
		   left(l.PhoneAbr__c,3) AS 'PhoneNumberAreaCode',਍ऀऀ   挀⸀嬀吀礀瀀攀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀✀Ⰰഀഀ
		   c.CHANNEL__C  AS 'CampaignChannel',਍ऀऀ   挀⸀䴀䔀䐀䤀䄀开开䌀 䄀匀 ✀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀✀Ⰰഀഀ
		   c.[NAME] AS 'CampaignName',਍ऀऀ   挀⸀䘀伀刀䴀䄀吀开开䌀 䄀匀 ✀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀✀Ⰰഀഀ
		   c.[Location__c] AS 'CampaignLocation',਍ऀऀ   挀⸀嬀䌀漀洀瀀愀渀礀开开挀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀✀Ⰰഀഀ
		   CASE WHEN (c.[Location__c] LIKE '%BARTH%' OR c.[Location__c] LIKE '%LOCAL US%') THEN 'Barth'਍ऀऀऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䌀䄀一䄀䐀䄀─✀ 伀刀 挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─一䄀吀䤀伀一䄀䰀 䌀䄀─✀ 伀刀 挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䰀伀䌀䄀䰀 䌀䄀─✀⤀ 吀䠀䔀一 ✀䌀愀渀愀搀愀✀ഀ
				WHEN (c.[Location__c] LIKE '%USA%' OR c.[Location__c] LIKE '%NATIONAL US%') THEN 'United States'਍ऀऀऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䔀䌀伀䴀䴀䔀刀䌀䔀─✀⤀ 吀䠀䔀一 ✀䔀挀漀洀洀攀爀挀攀✀ഀ
				WHEN (c.[Location__c] LIKE '%HANS%') THEN 'Hans'਍ऀऀऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─倀唀䔀刀吀伀 刀䤀䌀伀─✀⤀ 吀䠀䔀一 ✀倀甀攀爀琀漀 刀椀挀漀✀ഀ
				ELSE਍ऀऀऀऀ✀唀渀欀渀漀眀渀✀ 䔀一䐀 䄀匀 ✀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀✀Ⰰഀഀ
		   c.[Language__c] AS 'CampaignLanguage',਍ऀऀ   挀⸀嬀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀✀Ⰰഀഀ
		   cast(l.[HTTPReferrer__c] as nvarchar(1000)) AS 'CampaignLandingPageURL',਍ऀऀ   挀⸀匀吀䄀刀吀䐀䄀吀䔀 䄀匀 ✀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀✀Ⰰഀഀ
		   c.ENDDATE AS 'CampaignEndDate',਍ऀऀ   挀⸀嬀匀吀䄀吀唀匀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀✀Ⰰഀഀ
		   l.[PostalCode] AS 'PostalCode',਍ऀऀ   戀瀀挀搀⸀嬀搀甀爀愀琀椀漀渀崀  䄀匀 ✀吀漀琀愀氀吀椀洀攀✀Ⰰഀഀ
		   bpcd.[ivr_time] AS 'IVRTime',਍ऀऀ   戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 䄀匀 ✀吀愀氀欀吀椀洀攀✀Ⰰഀഀ
		   1 AS 'RawContact',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 伀刀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀✀Ⰰഀഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] > 0 ) THEN 1 ELSE 0 END AS 'Contact',਍ऀऀ   䌀䄀匀䔀ऀ圀䠀䔀一 ⠀⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 一伀吀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 䄀一䐀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 渀漀琀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 䄀一䐀 戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 㸀㴀 㘀　 ⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀✀Ⰰഀഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] < 60 ) THEN 1 ELSE 0 END AS 'NonQualifiedContact',਍ऀऀ   戀瀀挀搀⸀瀀欀椀搀 愀猀 ✀倀欀椀搀✀Ⰰഀഀ
		   t.id as 'TaskId',਍ऀऀ   挀⸀嬀吀漀氀氀䘀爀攀攀一愀洀攀开开挀崀 愀猀 ✀吀漀氀氀䘀爀攀攀一愀洀攀✀Ⰰഀഀ
		   c.[TollFreeMobileName__c] as 'TollFreeMobileName',਍ऀऀ   戀瀀挀搀⸀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀Ⰰഀഀ
		   bpcd.custom2,਍ऀऀ   氀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀ഀഀ
	--INTO #Activities਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 琀ഀഀ
		LEFT OUTER JOIN [ODS].[SFDC_Lead] l਍ऀऀऀ伀一 氀⸀䤀搀 㴀 琀⸀圀栀漀䤀搀ഀഀ
		LEFT OUTER JOIN [ODS].[SFDC_Campaign] c਍ऀऀऀ伀一 挀⸀椀搀 㴀 琀⸀嬀䌀愀洀瀀愀椀最渀䤀䐀开开挀崀ഀഀ
		LEFT OUTER JOIN [ODS].[BP_CallDetail] bpcd਍ऀऀऀ伀一 吀刀䤀䴀⠀戀瀀挀搀⸀挀甀猀琀漀洀㌀⤀ 㴀 吀刀䤀䴀⠀琀⸀椀搀⤀ഀഀ
		LEFT OUTER JOIN [ODS].[DimTimeOfDay] dtd਍ऀऀऀ伀一 搀琀搀⸀嬀吀椀洀攀㈀㐀崀 㴀 挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀Ⰰ䤀匀一唀䰀䰀⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀Ⰰ琀⸀䌀爀攀愀琀攀搀吀椀洀攀开开挀⤀Ⰰ㠀⤀ഀഀ
		LEFT OUTER JOIN [ODS].[CNCT_Center] cn਍ऀऀऀ伀一 琀⸀䌀攀渀琀攀爀一甀洀戀攀爀开开挀 㴀 挀渀⸀䌀攀渀琀攀爀一甀洀戀攀爀ഀഀ
		LEFT OUTER JOIN [ODS].[CNCT_CenterType] ct਍ऀऀऀ伀一 挀渀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀ഀഀ
	WHERE (t.Action__c IN ('Web Form','Web Chat','Inbound Call') ਍ऀऀऀ伀刀 ⠀琀⸀䄀挀琀椀漀渀开开挀 㴀 ✀䌀漀渀昀椀爀洀愀琀椀漀渀 䌀愀氀氀✀ 愀渀搀 琀⸀刀攀猀甀氀琀开开挀 䤀一 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䌀愀氀氀 䈀愀挀欀✀Ⰰ✀䌀愀渀挀攀氀✀Ⰰ✀䐀椀爀攀挀琀 䌀漀渀昀椀爀洀愀琀椀漀渀✀Ⰰ✀刀攀猀挀栀攀搀甀氀攀✀⤀⤀ഀഀ
			OR (t.Action__c IN ('Show no buy call','No Show Call','Brochure Call','Cancel Call') AND t.Result__c = 'Appointment'))਍ऀऀ  䄀一䐀 琀⸀刀攀猀甀氀琀开开挀 䤀匀 一伀吀 渀甀氀氀ഀഀ
਍ऀ䤀一匀䔀刀吀 䤀一吀伀 ⌀䌀漀渀琀愀挀琀䈀倀ഀഀ
	SELECT --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一⠀一唀䰀䰀 㴀 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀⤀ 吀䠀䔀一 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀ഀഀ
				ELSE 'Hairclub'਍ऀऀऀऀ䔀一䐀 䄀匀 ✀䌀漀洀瀀愀渀礀✀Ⰰഀഀ
		   l.id AS 'LeadID',਍ऀऀ   氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 ✀䜀䌀䰀䤀䐀✀Ⰰഀഀ
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', [ODS].[ValidMail](l.Email) ),2)) AS 'HashedEmail',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 䤀匀 一伀吀 一唀䰀䰀⤀ 吀䠀䔀一 戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀ഀഀ
				END as 'Start_Date',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 䤀匀 一伀吀 一唀䰀䰀⤀ 吀䠀䔀一 挀愀猀琀⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 愀猀 搀愀琀攀⤀ഀഀ
				END as Date,਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀挀愀猀琀⠀戀瀀挀搀⸀猀琀愀爀琀开琀椀洀攀 愀猀 琀椀洀攀⤀ 椀猀 渀甀氀氀⤀ 吀䠀䔀一 一唀䰀䰀ഀഀ
				ELSE cast(bpcd.start_time as time)਍ऀऀऀऀ䔀一䐀 愀猀 琀椀洀攀Ⰰഀഀ
		   dtd.DayPart AS 'DayPart',਍ऀऀ   搀琀搀⸀嬀䠀漀甀爀崀 䄀匀 ✀䠀漀甀爀✀Ⰰഀഀ
		   dtd.[minute] AS 'Minute',਍ऀऀ   搀琀搀⸀嬀匀攀挀漀渀搀崀 䄀匀 ✀匀攀挀漀渀搀猀✀Ⰰഀഀ
		   TRIM(l.LastName),਍ऀऀ   吀刀䤀䴀⠀氀⸀䘀椀爀猀琀一愀洀攀⤀Ⰰഀഀ
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[Phone],'(',''),')',''),' ',''),'-','') as 'Phone',਍ऀऀ   刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀嬀䴀漀戀椀氀攀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䄀匀 ✀䴀漀戀椀氀攀倀栀漀渀攀✀Ⰰഀഀ
		   TRIM(l.Email),਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀挀甀猀琀漀洀㈀ 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 一唀䰀䰀 ഀഀ
				ELSE bpcd.custom2਍ऀऀऀऀ䔀一䐀 䄀匀 ✀匀漀甀爀挀攀挀漀搀攀✀Ⰰഀഀ
		   left(l.PhoneAbr__c,3) AS 'PhoneNumberAreaCode',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀✀Ⰰഀഀ
		   NULL  AS 'CampaignChannel',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀✀Ⰰഀഀ
		   NULL AS 'CampaignName',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀✀Ⰰഀഀ
		   NULL AS 'CampaignLocation',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀✀Ⰰഀഀ
		   CASE WHEN (NULL LIKE '%BARTH%' OR NULL LIKE '%LOCAL US%') THEN 'Barth'਍ऀऀऀऀ圀䠀䔀一 ⠀一唀䰀䰀 䰀䤀䬀䔀 ✀─䌀䄀一䄀䐀䄀─✀ 伀刀 一唀䰀䰀 䰀䤀䬀䔀 ✀─一䄀吀䤀伀一䄀䰀 䌀䄀─✀ 伀刀 一唀䰀䰀 䰀䤀䬀䔀 ✀─䰀伀䌀䄀䰀 䌀䄀─✀⤀ 吀䠀䔀一 ✀䌀愀渀愀搀愀✀ഀ
				WHEN (NULL LIKE '%USA%' OR NULL LIKE '%NATIONAL US%') THEN 'United States'਍ऀऀऀऀ圀䠀䔀一 ⠀一唀䰀䰀 䰀䤀䬀䔀 ✀─䔀䌀伀䴀䴀䔀刀䌀䔀─✀⤀ 吀䠀䔀一 ✀䔀挀漀洀洀攀爀挀攀✀ഀ
				WHEN (NULL LIKE '%HANS%') THEN 'Hans'਍ऀऀऀऀ圀䠀䔀一 ⠀一唀䰀䰀 䰀䤀䬀䔀 ✀─倀唀䔀刀吀伀 刀䤀䌀伀─✀⤀ 吀䠀䔀一 ✀倀甀攀爀琀漀 刀椀挀漀✀ഀ
				ELSE਍ऀऀऀऀ✀唀渀欀渀漀眀渀✀ 䔀一䐀 䄀匀 ✀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀✀Ⰰഀഀ
		   NULL AS 'CampaignLanguage',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀✀Ⰰഀഀ
		   cast(l.[HTTPReferrer__c] as nvarchar(1000)) AS 'CampaignLandingPageURL',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀✀Ⰰഀഀ
		   NULL AS 'CampaignEndDate',਍ऀऀ   一唀䰀䰀 䄀匀 ✀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀✀Ⰰഀഀ
		   NULL AS 'PostalCode',਍ऀऀ   戀瀀挀搀⸀嬀搀甀爀愀琀椀漀渀崀  䄀匀 ✀吀漀琀愀氀吀椀洀攀✀Ⰰഀഀ
		   bpcd.[ivr_time] AS 'IVRTime',਍ऀऀ   戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 䄀匀 ✀吀愀氀欀吀椀洀攀✀Ⰰഀഀ
		   1 AS 'RawContact',਍ऀऀ   䌀䄀匀䔀 圀䠀䔀一 ⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 伀刀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀✀Ⰰഀഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] > 0 ) THEN 1 ELSE 0 END AS 'Contact',਍ऀऀ   䌀䄀匀䔀ऀ圀䠀䔀一 ⠀⠀戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 一伀吀 氀椀欀攀 ✀䄀戀愀渀搀漀渀─✀ 䄀一䐀 戀瀀挀搀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀 渀漀琀 氀椀欀攀 ✀匀礀猀琀攀洀开搀椀猀─✀⤀ 䄀一䐀 戀瀀挀搀⸀嬀琀愀氀欀开琀椀洀攀崀 㸀㴀 㘀　 ⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 ✀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀✀Ⰰഀഀ
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] < 60 ) THEN 1 ELSE 0 END AS 'NonQualifiedContact',਍ऀऀ   戀瀀挀搀⸀瀀欀椀搀 愀猀 ✀倀欀椀搀✀Ⰰഀഀ
		   NULL as 'TaskId',਍ऀऀ   一唀䰀䰀 愀猀 ✀吀漀氀氀䘀爀攀攀一愀洀攀✀Ⰰഀഀ
		   NULL as 'TollFreeMobileName',਍ऀऀ   戀瀀挀搀⸀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀Ⰰഀഀ
		   bpcd.custom2,਍ऀऀ   氀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀ഀഀ
	FROM [ODS].[BP_CallDetail] bpcd਍ऀऀⴀⴀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 琀ഀഀ
		--	ON TRIM(bpcd.custom3) = TRIM(t.id)਍ऀऀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䰀攀愀搀崀 氀ഀഀ
			ON l.Id = TRIM(bpcd.Custom1)਍ऀऀⴀⴀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀崀 挀ഀഀ
		--	ON c.id = t.[CampaignID__c]਍ऀऀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䐀椀洀吀椀洀攀伀昀䐀愀礀崀 搀琀搀ഀഀ
			ON dtd.[Time24] = convert(varchar,bpcd.start_time,8)਍ऀऀⴀⴀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀崀 挀渀ഀഀ
		--	ON t.CenterNumber__c = cn.CenterNumber਍ऀऀⴀⴀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀吀礀瀀攀崀 挀琀ഀഀ
		--	ON cn.CenterTypeID = ct.CenterTypeID਍ऀ圀䠀䔀刀䔀 ⠀⠀戀瀀挀搀⸀挀愀氀氀攀爀开瀀栀漀渀攀开琀礀瀀攀 㴀 ✀䔀砀琀攀爀渀愀氀✀ഀഀ
			AND bpcd.callee_phone_type = 'Internal'਍ऀऀऀ䄀一䐀 䤀匀一唀䰀䰀⠀戀瀀挀搀⸀猀攀爀瘀椀挀攀开渀愀洀攀Ⰰ ✀✀⤀ 一伀吀 䰀䤀䬀䔀 ✀─猀洀猀─✀⤀ ഀഀ
			OR ((bpcd.caller_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)਍                               䄀一䐀 ⠀戀瀀挀搀⸀挀愀氀氀攀攀开瀀栀漀渀攀开琀礀瀀攀 㴀 ✀䔀砀琀攀爀渀愀氀✀ 伀刀 戀瀀挀搀⸀挀愀氀氀攀爀开瀀栀漀渀攀开琀礀瀀攀 䤀匀 一唀䰀䰀⤀ഀഀ
                               AND ISNULL(bpcd.service_name, '') LIKE '%inbound%'));਍ഀഀ
--------CTE----------------------਍ऀ眀椀琀栀 挀琀攀 愀猀ഀ
(਍匀攀氀攀挀琀 椀搀Ⰰ 嬀渀愀洀攀猀崀Ⰰ 嬀瘀愀氀甀攀崀ഀ
from [ODS].[SFDC_Campaign]਍唀渀瀀椀瘀漀琀 ⠀ഀ
[Value] for [Names] in ([MPNCode__c] ,[MWCCode__c] ,[MWFCode__c], DPNCode__c,DWCCode__c, DWFCode__c)਍⤀ 愀猀 瀀瘀⤀ഀ
਍椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀漀爀愀氀匀漀甀爀挀攀ഀ
	(਍ऀऀ椀搀Ⰰഀ
		names,਍ऀऀ瘀愀氀甀攀Ⰰഀ
		[CampaignAgency],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀Ⰰഀഀ
		[CampaignMedium],਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀Ⰰഀഀ
		[CampaignFormat],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀Ⰰഀഀ
		[CampaignLocation],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀Ⰰഀഀ
		[CampaignLanguage],਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀Ⰰഀഀ
		[CampaignStartDate],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀Ⰰഀഀ
		[CampaignStatus]਍ऀ⤀ഀ
਍猀攀氀攀挀琀 ഀ
	cte.id,਍ऀ挀琀攀⸀渀愀洀攀猀Ⰰഀ
	cte.value,਍ऀ挀⸀嬀吀礀瀀攀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀✀Ⰰഀഀ
	c.CHANNEL__C  AS 'CampaignChannel',਍ऀ挀⸀䴀䔀䐀䤀䄀开开䌀 䄀匀 ✀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀✀Ⰰഀഀ
	c.[NAME] AS 'CampaignName',਍ऀ挀⸀䘀伀刀䴀䄀吀开开䌀 䄀匀 ✀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀✀Ⰰഀഀ
	c.[Company__c] AS 'CampaignCompany',਍ऀ挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀✀Ⰰഀഀ
	CASE WHEN (c.[Location__c] LIKE '%BARTH%' OR c.[Location__c] LIKE '%LOCAL US%') THEN 'Barth'਍ऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䌀䄀一䄀䐀䄀─✀ 伀刀 挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─一䄀吀䤀伀一䄀䰀 䌀䄀─✀ 伀刀 挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䰀伀䌀䄀䰀 䌀䄀─✀⤀ 吀䠀䔀一 ✀䌀愀渀愀搀愀✀ഀ
		WHEN (c.[Location__c] LIKE '%USA%' OR c.[Location__c] LIKE '%NATIONAL US%') THEN 'United States'਍ऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䔀䌀伀䴀䴀䔀刀䌀䔀─✀⤀ 吀䠀䔀一 ✀䔀挀漀洀洀攀爀挀攀✀ഀ
		WHEN (c.[Location__c] LIKE '%HANS%') THEN 'Hans'਍ऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─倀唀䔀刀吀伀 刀䤀䌀伀─✀⤀ 吀䠀䔀一 ✀倀甀攀爀琀漀 刀椀挀漀✀ഀ
		ELSE਍ऀऀ✀唀渀欀渀漀眀渀✀ 䔀一䐀 䄀匀 ✀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀✀Ⰰഀഀ
	c.[Language__c] AS 'CampaignLanguage',਍ऀ挀⸀嬀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀✀Ⰰഀഀ
	c.STARTDATE AS 'CampaignStartDate',਍ऀ挀⸀䔀一䐀䐀䄀吀䔀 䄀匀 ✀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀✀Ⰰഀഀ
	c.[STATUS] AS 'CampaignStatus'਍昀爀漀洀 挀琀攀ഀ
inner join [ODS].[SFDC_Campaign] c on cte.id=c.id;਍ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ䌀吀䄀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
਍眀椀琀栀 挀琀愀 愀猀ഀ
(਍匀攀氀攀挀琀 椀搀Ⰰ嬀吀漀氀氀䘀爀攀攀一愀洀攀开开挀崀Ⰰ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀崀Ⰰ 嬀渀愀洀攀猀崀Ⰰ 嬀瘀愀氀甀攀崀ഀ
from [ODS].[SFDC_Campaign]਍唀渀瀀椀瘀漀琀 ⠀ഀ
[Value] for [Names] in ([MPNCode__c] ,[MWCCode__c] ,[MWFCode__c], DPNCode__c,DWCCode__c, DWFCode__c)਍⤀ 愀猀 瀀瘀⤀ഀ
਍椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀漀爀愀氀倀栀漀渀攀ഀ
	(਍ऀऀ椀搀Ⰰഀ
		names,਍ऀऀ瘀愀氀甀攀Ⰰഀ
		[TollFreeName],਍        嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀Ⰰഀ
		[CampaignAgency],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀Ⰰഀഀ
		[CampaignMedium],਍ऀऀ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀Ⰰഀഀ
		[CampaignFormat],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀Ⰰഀഀ
		[CampaignLocation],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀Ⰰഀഀ
		[CampaignLanguage],਍ऀऀ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀Ⰰഀഀ
		[CampaignStartDate],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀Ⰰഀഀ
		[CampaignStatus]਍ऀ⤀ഀ
਍猀攀氀攀挀琀ഀ
	cta.id,਍ऀ挀琀愀⸀渀愀洀攀猀Ⰰഀ
	cta.value,਍ऀ挀琀愀⸀嬀吀漀氀氀䘀爀攀攀一愀洀攀开开挀崀 愀猀 ✀吀漀氀氀䘀爀攀攀一愀洀攀✀Ⰰഀ
	cta.[TollFreeMobileName__c] as 'TollFreeMobileName',਍ऀ挀⸀嬀吀礀瀀攀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀✀Ⰰഀഀ
	c.CHANNEL__C  AS 'CampaignChannel',਍ऀ挀⸀䴀䔀䐀䤀䄀开开䌀 䄀匀 ✀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀✀Ⰰഀഀ
	c.[NAME] AS 'CampaignName',਍ऀ挀⸀䘀伀刀䴀䄀吀开开䌀 䄀匀 ✀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀✀Ⰰഀഀ
	c.[Company__c] AS 'CampaignCompany',਍ऀ挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀✀Ⰰഀഀ
	CASE WHEN (c.[Location__c] LIKE '%BARTH%' OR c.[Location__c] LIKE '%LOCAL US%') THEN 'Barth'਍ऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䌀䄀一䄀䐀䄀─✀ 伀刀 挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─一䄀吀䤀伀一䄀䰀 䌀䄀─✀ 伀刀 挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䰀伀䌀䄀䰀 䌀䄀─✀⤀ 吀䠀䔀一 ✀䌀愀渀愀搀愀✀ഀ
		WHEN (c.[Location__c] LIKE '%USA%' OR c.[Location__c] LIKE '%NATIONAL US%') THEN 'United States'਍ऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─䔀䌀伀䴀䴀䔀刀䌀䔀─✀⤀ 吀䠀䔀一 ✀䔀挀漀洀洀攀爀挀攀✀ഀ
		WHEN (c.[Location__c] LIKE '%HANS%') THEN 'Hans'਍ऀऀ圀䠀䔀一 ⠀挀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀 䰀䤀䬀䔀 ✀─倀唀䔀刀吀伀 刀䤀䌀伀─✀⤀ 吀䠀䔀一 ✀倀甀攀爀琀漀 刀椀挀漀✀ഀ
		ELSE਍ऀऀ✀唀渀欀渀漀眀渀✀ 䔀一䐀 䄀匀 ✀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀✀Ⰰഀഀ
	c.[Language__c] AS 'CampaignLanguage',਍ऀ挀⸀嬀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀崀 䄀匀 ✀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀✀Ⰰഀഀ
	c.STARTDATE AS 'CampaignStartDate',਍ऀ挀⸀䔀一䐀䐀䄀吀䔀 䄀匀 ✀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀✀Ⰰഀഀ
	c.[STATUS] AS 'CampaignStatus'਍昀爀漀洀 挀琀愀ഀ
inner join [ODS].[SFDC_Campaign] c on cta.id=c.id਍ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ唀一䤀伀一 伀䘀 吀䠀䔀 吀䄀䈀䰀䔀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
਍ऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	#ContactTable਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	FROM #ContactTask਍ऀ甀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ䘀爀漀洀 ⌀䌀漀渀琀愀挀琀䈀倀ഀഀ
਍ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ唀倀䐀䄀吀䔀 吀䄀䈀䰀䔀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
਍ഀഀ
UPDATE #ContactTable਍匀䔀吀ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀Ⰰഀഀ
		[CampaignChannel] = t2.[CampaignChannel],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀Ⰰഀഀ
		[CampaignName] = t2.[CampaignName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀Ⰰഀഀ
		[CampaignCompany] = t2.[CampaignCompany],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀Ⰰഀഀ
		--[CampaignBudgetName] = t2.[CampaignBudgetName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀Ⰰഀഀ
		[CampaignPromotionCode] = t2.[CampaignPromotionCode],਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀Ⰰഀഀ
		[CampaignEndDate] = t2.[CampaignEndDate],਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀഀ
  FROM #temporalSource t2਍  圀栀攀爀攀 ⠀⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀挀甀猀琀漀洀㈀ 㴀 琀㈀⸀瘀愀氀甀攀⤀ 䄀一䐀ഀഀ
   (#ContactTable.[CampaignAgency] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignMedium] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignFormat] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignLocation] IS NULL AND਍ऀऀⴀⴀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignLanguage] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignStartDate] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignStatus] IS NULL)-- AND (t1.SourceCode = t2.value)਍ഀഀ
UPDATE #ContactTable਍匀䔀吀ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀Ⰰഀഀ
		[CampaignChannel] = t2.[CampaignChannel],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀Ⰰഀഀ
		[CampaignName] = t2.[CampaignName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀Ⰰഀഀ
		[CampaignCompany] = t2.[CampaignCompany],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀Ⰰഀഀ
		[CampaignBudgetName] = t2.[CampaignBudgetName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀Ⰰഀഀ
		[CampaignPromotionCode] = t2.[CampaignPromotionCode],਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀Ⰰഀഀ
		[CampaignEndDate] = t2.[CampaignEndDate],਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 㴀 琀㈀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀഀ
  FROM #temporalPhone t2਍  圀栀攀爀攀 ⠀爀椀最栀琀⠀⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀Ⰰ㄀　⤀㴀䤀匀一唀䰀䰀⠀琀㈀⸀嬀吀漀氀氀䘀爀攀攀一愀洀攀崀Ⰰ琀㈀⸀嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀⤀⤀ഀഀ
  and (#ContactTable.[CampaignAgency] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignMedium] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignFormat] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignLocation] IS NULL AND਍ऀऀⴀⴀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignLanguage] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignStartDate] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignStatus] IS NULL)਍ഀഀ
਍ഀഀ
UPDATE #ContactTable਍匀䔀吀ऀऀ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 㴀 琀㈀⸀嬀吀礀瀀攀崀Ⰰഀഀ
		[CampaignChannel] = t2.CHANNEL__C,਍ऀऀ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 㴀 琀㈀⸀䴀䔀䐀䤀䄀开开䌀Ⰰഀഀ
		[CampaignName] = t2.[NAME],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 琀㈀⸀䘀伀刀䴀䄀吀开开䌀Ⰰഀഀ
		[CampaignCompany] = t2.[Company__c],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 㴀 琀㈀⸀嬀䰀漀挀愀琀椀漀渀开开挀崀Ⰰഀഀ
		--[CampaignBudgetName] = t2.[CampaignBudgetName],਍ऀऀ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 㴀 琀㈀⸀嬀䰀愀渀最甀愀最攀开开挀崀Ⰰഀഀ
		[CampaignPromotionCode] = t2.[PromoCodeName__c],਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 㴀 琀㈀⸀匀吀䄀刀吀䐀䄀吀䔀Ⰰഀഀ
		[CampaignEndDate] = t2.ENDDATE,਍ऀऀ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 㴀 琀㈀⸀嬀匀吀䄀吀唀匀崀ഀഀ
  FROM [ODS].[SFDC_Campaign] t2਍  圀栀攀爀攀 ⠀⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀开开挀崀 㴀 琀㈀⸀椀搀⤀ 䄀一䐀ഀഀ
   (#ContactTable.[CampaignAgency] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignMedium] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignFormat] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignLocation] IS NULL AND਍ऀऀⴀⴀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignLanguage] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignStartDate] IS NULL AND਍ऀऀ⌀䌀漀渀琀愀挀琀吀愀戀氀攀⸀嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 䤀匀 一唀䰀䰀 䄀一䐀ഀഀ
		#ContactTable.[CampaignStatus] IS NULL)਍ഀഀ
਍ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ䤀一匀䔀刀吀 䤀一吀伀 䌀伀一吀䄀䌀吀匀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
਍ऀ䤀一匀䔀刀吀 䤀一吀伀 嬀刀攀瀀漀爀琀猀崀⸀嬀䘀愀挀琀䌀漀渀琀愀挀琀崀 ⠀嬀䌀漀洀瀀愀渀礀崀ഀഀ
      ,[LeadID]਍      Ⰰ嬀䜀䌀䰀䤀䐀崀ഀഀ
      ,[HashedEmail]਍      Ⰰ嬀匀琀愀爀琀开䐀愀琀攀崀ഀഀ
      ,[Date]਍      Ⰰ嬀吀椀洀攀崀ഀഀ
      ,[DayPart]਍      Ⰰ嬀䠀漀甀爀崀ഀഀ
      ,[Minute]਍      Ⰰ嬀匀攀挀漀渀搀猀崀ഀഀ
      ,[LastName]਍      Ⰰ嬀䘀椀爀猀琀一愀洀攀崀ഀഀ
      ,[Phone]਍      Ⰰ嬀䴀漀戀椀氀攀倀栀漀渀攀崀ഀഀ
      ,[Email]਍      Ⰰ嬀匀漀甀爀挀攀挀漀搀攀崀ഀഀ
      ,[PhoneNumberAreaCode]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀ഀഀ
      ,[CampaignChannel]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀ഀഀ
      ,[CampaignName]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀഀ
      ,[CampaignCompany]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀ഀഀ
      ,[CampaignBudgetName]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀ഀഀ
      ,[CampaignPromotionCode]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀崀ഀഀ
      ,[CampaignStartDate]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀഀ
      ,[CampaignStatus]਍      Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
      ,[TotalTime]਍      Ⰰ嬀䤀嘀刀吀椀洀攀崀ഀഀ
      ,[TalkTime]਍      Ⰰ嬀刀愀眀䌀漀渀琀愀挀琀崀ഀഀ
      ,[AbandonedContact]਍      Ⰰ嬀䌀漀渀琀愀挀琀崀ഀഀ
      ,[QualifiedContact]਍      Ⰰ嬀一漀渀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀ഀഀ
	  ,[Pkid]਍ऀ  Ⰰ嬀吀愀猀欀䤀搀崀ഀഀ
	  ,[TollFreeName]਍ऀ  Ⰰ嬀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀崀⤀ഀഀ
਍ऀ  匀䔀䰀䔀䌀吀 ഀഀ
	   [Company]਍      Ⰰ嬀䰀攀愀搀䤀䐀崀ഀഀ
      ,[GCLID]਍      Ⰰ嬀䠀愀猀栀攀搀䔀洀愀椀氀崀ഀഀ
      ,[Start_Date]਍      Ⰰ嬀䐀愀琀攀崀ഀഀ
      ,[Time]਍      Ⰰ嬀䐀愀礀倀愀爀琀崀ഀഀ
      ,[Hour]਍      Ⰰ嬀䴀椀渀甀琀攀崀ഀഀ
      ,[Seconds]਍      Ⰰ嬀䰀愀猀琀一愀洀攀崀ഀഀ
      ,[FirstName]਍      Ⰰ嬀倀栀漀渀攀崀ഀഀ
      ,[MobilePhone]਍      Ⰰ嬀䔀洀愀椀氀崀ഀഀ
      ,[Sourcecode]਍      Ⰰ嬀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀ഀഀ
      ,[CampaignAgency]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀ഀഀ
      ,[CampaignMedium]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀一愀洀攀崀ഀഀ
      ,[CampaignFormat]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀崀ഀഀ
      ,[CampaignLocation]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀崀ഀഀ
      ,[CampaignLanguage]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀ഀഀ
      ,[CampaignLandingPageURL]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀ഀഀ
      ,[CampaignEndDate]਍      Ⰰ嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀഀ
      ,[PostalCode]਍      Ⰰ嬀吀漀琀愀氀吀椀洀攀崀ഀഀ
      ,[IVRTime]਍      Ⰰ嬀吀愀氀欀吀椀洀攀崀ഀഀ
      ,[RawContact]਍      Ⰰ嬀䄀戀愀渀搀漀渀攀搀䌀漀渀琀愀挀琀崀ഀഀ
      ,[Contact]਍      Ⰰ嬀儀甀愀氀椀昀椀攀搀䌀漀渀琀愀挀琀崀ഀഀ
      ,[NonQualifiedContact]਍ऀ  Ⰰ嬀倀欀椀搀崀ഀഀ
	  ,[TaskId]਍ऀ  Ⰰ嬀吀漀氀氀䘀爀攀攀一愀洀攀崀ഀഀ
	  ,[TollFreeMobileName]਍ऀ  䘀刀伀䴀 ⌀䌀漀渀琀愀挀琀吀愀戀氀攀ഀഀ
	਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀吀愀猀欀ഀഀ
	DROP TABLE #ContactBP਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀吀愀戀氀攀ഀഀ
	DROP TABLE #temporalSource਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀漀爀愀氀倀栀漀渀攀ഀഀ
਍䔀一䐀ഀഀ
GO਍
