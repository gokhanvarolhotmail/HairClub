/****** Object:  Table [dbo].[SLF_Final_ServiceAppointment_Delta_EMERGENCY]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开䘀椀渀愀氀开匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀开䐀攀氀琀愀开䔀䴀䔀刀䜀䔀一䌀夀崀⠀ഀഀ
	[ActualDuration] [decimal](38, 18) NULL,਍ऀ嬀䄀挀琀甀愀氀䔀渀搀吀椀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ActualStartTime] [nvarchar](4000) NOT NULL,਍ऀ嬀䄀搀搀椀琀椀漀渀愀氀䤀渀昀漀爀洀愀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentType] [varchar](7) NOT NULL,਍ऀ嬀䄀爀爀椀瘀愀氀圀椀渀搀漀眀䔀渀搀吀椀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ArrivalWindowStartTime] [nvarchar](4000) NOT NULL,਍ऀ嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[City] [nvarchar](max) NULL,਍ऀ嬀䌀漀洀洀攀渀琀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Country] [nvarchar](max) NULL,਍ऀ嬀䌀漀甀渀琀爀礀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](max) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](max) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[DueDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䐀甀爀愀琀椀漀渀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[DurationInMinutes] [decimal](38, 18) NULL,਍ऀ嬀䐀甀爀愀琀椀漀渀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[EarliestStartTime] [nvarchar](4000) NOT NULL,਍ऀ嬀䔀洀愀椀䰀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[External_Id__c] [nvarchar](max) NULL,਍ऀ嬀䜀攀漀挀漀搀攀䄀挀挀甀爀愀挀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Id] [varchar](1) NOT NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[LastReferencedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䰀愀猀琀嘀椀攀眀攀搀䐀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Latitude] [decimal](38, 18) NULL,਍ऀ嬀䰀漀渀最椀琀甀搀攀崀 嬀搀攀挀椀洀愀氀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [varchar](18) NOT NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ParentRecordStatusCategory] [nvarchar](max) NULL,਍ऀ嬀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㐀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Phone] [nvarchar](max) NULL,਍ऀ嬀倀漀猀琀愀氀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SchedEndTime] [nvarchar](4000) NOT NULL,਍ऀ嬀匀挀栀攀搀匀琀愀爀琀吀椀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ServiceNote] [nvarchar](max) NULL,਍ऀ嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Service_Appointment__c] [varchar](1) NOT NULL,਍ऀ嬀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StateCode] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Street] [nvarchar](max) NULL,਍ऀ嬀匀甀戀樀攀挀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[WorkTypeId] [nvarchar](250) NULL,਍ऀ嬀圀漀爀欀开吀礀瀀攀开䜀爀漀甀瀀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[FlagPersonLead] [int] NOT NULL,਍ऀ嬀䘀氀愀最崀 嬀瘀愀爀挀栀愀爀崀⠀㘀⤀ 一唀䰀䰀ഀഀ
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]਍䜀伀ഀഀ
