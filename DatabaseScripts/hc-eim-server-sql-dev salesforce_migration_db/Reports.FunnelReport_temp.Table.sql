/****** Object:  Table [Reports].[FunnelReport_temp]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀刀攀瀀漀爀琀猀崀⸀嬀䘀甀渀渀攀氀刀攀瀀漀爀琀开琀攀洀瀀崀ഀഀ
(਍ऀ嬀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ContactID] [nvarchar](18) NULL,਍ऀ嬀匀愀氀攀猀䘀漀爀挀攀吀愀猀欀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[BrightPatternID] [nvarchar](18) NULL,਍ऀ嬀䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[SaleforceLeadID] [nvarchar](18) NULL,਍ऀ嬀䌀漀洀瀀愀渀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FunnelStep] [nvarchar](50) NULL,਍ऀ嬀䘀甀渀渀攀氀猀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalGCLID] [nvarchar](100) NULL,਍ऀ嬀䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀唀吀䌀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[LeadCreateDateEST] [datetime] NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[ActivityDateEST] [datetime] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䌀爀攀愀琀攀搀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentScheduled] [datetime] NULL,਍ऀ嬀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[Time] [time](7) NULL,਍ऀ嬀䐀愀礀倀愀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Hour] [varchar](10) NULL,਍ऀ嬀䴀椀渀甀琀攀崀 嬀猀洀愀氀氀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Seconds] [smallint] NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀漀渀琀愀挀琀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalSourcecode] [nvarchar](30) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䐀椀愀氀攀搀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalPhoneNumberAreaCode] [nvarchar](10) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalCampaignChannel] [nvarchar](50) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalCampaignFormat] [nvarchar](50) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalCampaignPromotionCode] [nvarchar](100) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[OriginalCampaignEndDate] [datetime] NULL,਍ऀ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentSourcecode] [nvarchar](30) NULL,਍ऀ嬀刀攀挀攀渀琀䐀椀愀氀攀搀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentPhoneNumberAreaCode] [nvarchar](10) NULL,਍ऀ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentCampaignChannel] [nvarchar](50) NULL,਍ऀ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentCampaignFormat] [nvarchar](50) NULL,਍ऀ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecentCampaignPromotionCode] [nvarchar](100) NULL,਍ऀ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[RecentCampaignEndDate] [datetime] NULL,਍ऀ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[PostalCode] [nvarchar](50) NULL,਍ऀ嬀刀攀最椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MarketDMA] [nvarchar](100) NULL,਍ऀ嬀䌀攀渀琀攀爀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterRegion] [nvarchar](100) NULL,਍ऀ嬀䌀攀渀琀攀爀䐀䴀䄀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterType] [nvarchar](50) NULL,਍ऀ嬀䌀攀渀琀攀爀伀眀渀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Language] [nvarchar](50) NULL,਍ऀ嬀䜀攀渀搀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastName] [nvarchar](250) NULL,਍ऀ嬀䘀椀爀猀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Phone] [nvarchar](250) NULL,਍ऀ嬀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Email] [nvarchar](250) NULL,਍ऀ嬀䔀琀栀渀椀挀椀琀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossCondition] [nvarchar](50) NULL,਍ऀ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Occupation] [nvarchar](50) NULL,਍ऀ嬀䈀椀爀琀栀夀攀愀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AgeBands] [nvarchar](50) NULL,਍ऀ嬀一攀眀䌀漀渀琀愀挀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NewLead] [int] NULL,਍ऀ嬀一攀眀䄀瀀瀀漀椀渀琀洀攀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NewShow] [int] NULL,਍ऀ嬀一攀眀匀愀氀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NewLeadToAppointment] [int] NULL,਍ऀ嬀一攀眀䰀攀愀搀吀漀匀栀漀眀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NewLeadToSale] [int] NULL,਍ऀ嬀儀甀漀琀攀搀倀爀椀挀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[PrimarySolution] [nvarchar](50) NULL,਍ऀ嬀䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最崀 嬀渀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotCallFlag] [nchar](1) NULL,਍ऀ嬀䐀漀一漀琀匀䴀匀䘀氀愀最崀 嬀渀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotEmailFlag] [nchar](1) NULL,਍ऀ嬀䐀漀一漀琀䴀愀椀氀䘀氀愀最崀 嬀渀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [datetime] NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ReportCreateDate] [datetime] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
