/****** Object:  Table [dbo].[SLF_NEW_Event_V9]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开一䔀圀开䔀瘀攀渀琀开嘀㤀崀⠀ഀഀ
	[Id] [varchar](250) NULL,਍ऀ嬀圀栀漀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[WhatId] [varchar](250) NULL,਍ऀ嬀圀栀漀䌀漀甀渀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[WhatCount] [varchar](250) NULL,਍ऀ嬀匀甀戀樀攀挀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Location] [varchar](250) NULL,਍ऀ嬀䤀猀䄀氀氀䐀愀礀䔀瘀攀渀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ActivityDateTime] [varchar](250) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[DurationInMinutes] [int] NULL,਍ऀ嬀匀琀愀爀琀䐀愀琀攀吀椀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[EndDateTime] [varchar](250) NULL,਍ऀ嬀䔀渀搀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Description] [varchar](250) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [varchar](250) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Type] [varchar](250) NULL,਍ऀ嬀䤀猀倀爀椀瘀愀琀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ShowAs] [varchar](250) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsChild] [bit] NULL,਍ऀ嬀䤀猀䜀爀漀甀瀀䔀瘀攀渀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[GroupEventType] [varchar](250) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [varchar](250) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [varchar](250) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䄀挀琀椀瘀椀琀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀匀琀愀爀琀䐀愀琀攀吀椀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceEndDateOnly] [nvarchar](1) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀吀椀洀攀娀漀渀攀匀椀搀䬀攀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceType] [nvarchar](1) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䤀渀琀攀爀瘀愀氀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceDayOfWeekMask] [nvarchar](1) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䐀愀礀伀昀䴀漀渀琀栀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceInstance] [varchar](250) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䴀漀渀琀栀伀昀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ReminderDateTime] [varchar](250) NULL,਍ऀ嬀䤀猀刀攀洀椀渀搀攀爀匀攀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[EventSubtype] [varchar](250) NULL,਍ऀ嬀䤀猀刀攀挀甀爀爀攀渀挀攀㈀䔀砀挀氀甀猀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Recurrence2PatternText] [varchar](250) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀㈀倀愀琀琀攀爀渀嘀攀爀猀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence2] [varchar](250) NULL,਍ऀ嬀䤀猀刀攀挀甀爀爀攀渀挀攀㈀䔀砀挀攀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Recurrence2PatternStartDate] [varchar](250) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀㈀倀愀琀琀攀爀渀吀椀洀攀娀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[ServiceAppointmentId] [varchar](250) NULL,਍ऀ嬀䈀爀椀最栀琀倀愀琀琀攀爀渀开匀倀刀攀挀漀爀搀椀渀最伀爀吀爀愀渀猀挀爀椀瀀琀唀刀䰀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Center_Name_c] [varchar](250) NULL,਍ऀ嬀䌀漀洀瀀氀攀琀攀搀开䐀愀琀攀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[External_ID_c] [varchar](250) NULL,਍ऀ嬀䰀攀愀搀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Meeting_Platform_Id_c] [varchar](250) NULL,਍ऀ嬀䴀攀攀琀椀渀最开倀氀愀琀昀漀爀洀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Person_Account_c] [varchar](250) NULL,਍ऀ嬀刀攀挀漀爀搀椀渀最开䰀椀渀欀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Result_c] [varchar](250) NULL,਍ऀ嬀匀倀刀攀挀漀爀搀椀渀最伀爀吀爀愀渀猀挀爀椀瀀琀唀刀䰀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Service_Appointment_c] [varchar](250) NULL,਍ऀ嬀匀攀爀瘀椀挀攀开吀攀爀爀椀琀漀爀礀开䌀愀氀氀攀爀开䤀搀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Agent_Link_c] [varchar](250) NULL,਍ऀ嬀䜀甀攀猀琀开䰀椀渀欀开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Opportunity_c] [varchar](250) NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
