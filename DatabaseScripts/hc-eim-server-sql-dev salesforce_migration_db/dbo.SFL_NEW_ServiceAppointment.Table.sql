/****** Object:  Table [dbo].[SFL_NEW_ServiceAppointment]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䘀䰀开一䔀圀开匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀崀⠀ഀഀ
	[Id] [nvarchar](18) NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀一甀洀戀攀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](765) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](18) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](18) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastViewedDate] [datetime2](0) NULL,਍ऀ嬀䰀愀猀琀刀攀昀攀爀攀渀挀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ParentRecordId] [nvarchar](18) NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountId] [nvarchar](18) NULL,਍ऀ嬀圀漀爀欀吀礀瀀攀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactId] [nvarchar](18) NULL,਍ऀ嬀匀琀爀攀攀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[City] [nvarchar](120) NULL,਍ऀ嬀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[PostalCode] [nvarchar](60) NULL,਍ऀ嬀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[StateCode] [nvarchar](765) NULL,਍ऀ嬀䌀漀甀渀琀爀礀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Latitude] [decimal](18, 15) NULL,਍ऀ嬀䰀漀渀最椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ ㄀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[GeocodeAccuracy] [nvarchar](765) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[EarliestStartTime] [datetime2](0) NULL,਍ऀ嬀䐀甀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Duration] [decimal](18, 2) NULL,਍ऀ嬀䄀爀爀椀瘀愀氀圀椀渀搀漀眀匀琀愀爀琀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ArrivalWindowEndTime] [datetime2](0) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[SchedStartTime] [datetime2](0) NULL,਍ऀ嬀匀挀栀攀搀䔀渀搀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ActualStartTime] [datetime2](0) NULL,਍ऀ嬀䄀挀琀甀愀氀䔀渀搀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ActualDuration] [decimal](18, 2) NULL,਍ऀ嬀䐀甀爀愀琀椀漀渀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[DurationInMinutes] [decimal](18, 2) NULL,਍ऀ嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Subject] [nvarchar](765) NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀匀琀愀琀甀猀䌀愀琀攀最漀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[StatusCategory] [nvarchar](765) NULL,਍ऀ嬀匀攀爀瘀椀挀攀一漀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentType] [nvarchar](765) NULL,਍ऀ嬀䔀洀愀椀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㐀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Phone] [nvarchar](120) NULL,਍ऀ嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[AdditionalInformation] [nvarchar](765) NULL,਍ऀ嬀䌀漀洀洀攀渀琀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Confirmer_User__c] [nvarchar](18) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀开䤀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Meeting_Platform_Id__c] [nvarchar](765) NULL,਍ऀ嬀䴀攀攀琀椀渀最开倀氀愀琀昀漀爀洀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Service_Appointment__c] [nvarchar](18) NULL,਍ऀ嬀圀漀爀欀开吀礀瀀攀开䜀爀漀甀瀀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[Appointment_Type__c] [nvarchar](3900) NULL,਍ऀ嬀匀挀栀攀搀甀氀攀搀开䔀渀搀开吀攀砀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Scheduled_Start_Text__c] [nvarchar](765) NULL,਍ऀ嬀䄀最攀渀琀开䄀瀀瀀漀椀渀琀洀攀渀琀开䰀椀渀欀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Automatic_Trigger__c] [bit] NULL,਍ऀ嬀䜀甀攀猀琀开䄀瀀瀀漀椀渀琀洀攀渀琀开䰀椀渀欀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Meeting_Point__c] [bit] NULL,਍ऀ嬀嘀椀搀攀漀开匀攀猀猀椀漀渀开䴀漀搀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㜀㘀㔀⤀ 一唀䰀䰀Ⰰഀഀ
	[Agent_Link__c] [nvarchar](3900) NULL,਍ऀ嬀䜀甀攀猀琀开䰀椀渀欀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀㤀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Is_Video_Appointment__c] [bit] NULL,਍ऀ嬀匀椀最栀琀挀愀氀氀开䄀瀀瀀漀椀渀琀洀攀渀琀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Test_date__c] [datetime2](0) NULL,਍ऀ嬀䄀爀攀开礀漀甀开猀甀爀攀开挀漀渀昀椀爀洀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㌀㤀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Appointment_Start_Date__c] [datetime2](0) NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀开䔀渀搀开䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Lead__c] [nvarchar](18) NULL,਍ऀ嬀倀攀爀猀漀渀开䄀挀挀漀甀渀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
