/****** Object:  Table [dbo].[SLF_Prod_ServiceAppointment_DELTA_EMERGENCY]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开倀爀漀搀开匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀开䐀䔀䰀吀䄀开䔀䴀䔀刀䜀䔀一䌀夀崀⠀ഀഀ
	[Id] [nvarchar](max) NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](max) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](max) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastViewedDate] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀刀攀昀攀爀攀渀挀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ParentRecordId] [nvarchar](max) NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountId] [nvarchar](max) NULL,਍ऀ嬀圀漀爀欀吀礀瀀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactId] [nvarchar](max) NULL,਍ऀ嬀匀琀爀攀攀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[City] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[PostalCode] [nvarchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StateCode] [nvarchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Latitude] [decimal](38, 18) NULL,਍ऀ嬀䰀漀渀最椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[GeocodeAccuracy] [nvarchar](max) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[EarliestStartTime] [datetime2](7) NULL,਍ऀ嬀䐀甀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Duration] [decimal](38, 18) NULL,਍ऀ嬀䄀爀爀椀瘀愀氀圀椀渀搀漀眀匀琀愀爀琀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ArrivalWindowEndTime] [datetime2](7) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SchedStartTime] [datetime2](7) NULL,਍ऀ嬀匀挀栀攀搀䔀渀搀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActualStartTime] [datetime2](7) NULL,਍ऀ嬀䄀挀琀甀愀氀䔀渀搀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActualDuration] [decimal](38, 18) NULL,਍ऀ嬀䐀甀爀愀琀椀漀渀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[DurationInMinutes] [decimal](38, 18) NULL,਍ऀ嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Subject] [nvarchar](max) NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀匀琀愀琀甀猀䌀愀琀攀最漀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusCategory] [nvarchar](max) NULL,਍ऀ嬀匀攀爀瘀椀挀攀一漀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentType] [nvarchar](max) NULL,਍ऀ嬀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Phone] [nvarchar](max) NULL,਍ऀ嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[AdditionalInformation] [nvarchar](max) NULL,਍ऀ嬀䌀漀洀洀攀渀琀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Scheduled_End_Text__c] [nvarchar](max) NULL,਍ऀ嬀匀挀栀攀搀甀氀攀搀开匀琀愀爀琀开吀攀砀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Lead__c] [nvarchar](max) NULL,਍ऀ嬀䌀愀氀氀开唀爀氀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Get_Account_Name__c] [nvarchar](max) NULL,਍ऀ嬀䜀攀琀开䐀愀礀开䘀爀攀渀挀栀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Get_Day_Spanish__c] [nvarchar](max) NULL,਍ऀ嬀䜀攀琀开䐀愀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Get_Hour__c] [datetime2](7) NULL,਍ऀ嬀䰀攀愀搀开䘀椀爀猀琀开一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Owner_Email__c] [nvarchar](max) NULL,਍ऀ嬀䴀攀攀琀椀渀最开倀氀愀琀昀漀爀洀开䤀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Meeting_Platform__c] [nvarchar](max) NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
