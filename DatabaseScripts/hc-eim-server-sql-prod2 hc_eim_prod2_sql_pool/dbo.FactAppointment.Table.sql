/****** Object:  Table [dbo].[FactAppointment]    Script Date: 2/22/2022 9:20:30 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
(਍ऀ嬀䘀愀挀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[FactTimeKey] [int] NULL,਍ऀ嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentDate] [datetime] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀吀椀洀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentDateKey] [int] NULL,਍ऀ嬀䰀攀愀搀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadId] [varchar](50) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AccountId] [varchar](50) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ContactId] [varchar](50) NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WorkTypeKey] [int] NULL,਍ऀ嬀圀漀爀欀吀礀瀀攀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountAddress] [varchar](100) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䌀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountState] [varchar](100) NULL,਍ऀ嬀䄀挀挀漀甀渀琀倀漀猀琀愀氀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountCountry] [varchar](100) NULL,਍ऀ嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentDescription] [varchar](8000) NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterKey] [int] NULL,਍ऀ嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterNumber] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentType] [varchar](100) NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䌀攀渀琀攀爀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ExternalId] [varchar](50) NULL,਍ऀ嬀匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MeetingPlatformKey] [int] NULL,਍ऀ嬀䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[MeetingPlatform] [varchar](100) NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime] NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentId] [varchar](50) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusKey] [int] NULL,਍ऀ嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[BeBackFlag] [bit] NULL,਍ऀ嬀伀氀搀匀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[AppoinmentStatusCategory] [varchar](1048) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsOld] [int] NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OpportunityStatus] [nvarchar](500) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[OpportunityReferralCode] [nvarchar](1024) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀愀琀椀漀渀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[OpportunityAmmount] [numeric](38, 18) NULL,਍ऀ嬀倀攀爀昀漀爀洀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[performerKey] [int] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
