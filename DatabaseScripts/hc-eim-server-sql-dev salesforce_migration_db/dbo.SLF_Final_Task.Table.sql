/****** Object:  Table [dbo].[SLF_Final_Task]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开䘀椀渀愀氀开吀愀猀欀崀⠀ഀഀ
	[Id] [varchar](250) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CallDurationInSeconds] [int] NULL,਍ऀ嬀䌀愀氀氀伀戀樀攀挀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CallDisposition] [nvarchar](max) NULL,਍ऀ嬀䌀愀氀氀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsClosed] [bit] NULL,਍ऀ嬀䌀漀洀瀀氀攀琀攀搀开䐀愀琀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CREATEDDATE] [nvarchar](4000) NOT NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ACTIVITYDATE] [nvarchar](4000) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀开䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsHighPriority] [bit] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䰀攀愀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[WhoId] [nvarchar](max) NULL,਍ऀ嬀倀攀爀猀漀渀开䄀挀挀漀甀渀琀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[Priority] [varchar](6) NOT NULL,਍ऀ嬀䤀猀嘀椀猀椀戀氀攀䤀渀匀攀氀昀匀攀爀瘀椀挀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Recording_Link__c] [nvarchar](max) NULL,਍ऀ嬀䈀爀椀最栀琀倀愀琀琀攀爀渀开开匀倀刀攀挀漀爀搀椀渀最伀爀吀爀愀渀猀挀爀椀瀀琀唀刀䰀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceActivityId] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䐀愀礀伀昀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceDayOfWeekMask] [int] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䔀渀搀䐀愀琀攀伀渀氀礀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceInstance] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䤀渀琀攀爀瘀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceMonthOfYear] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀匀琀愀爀琀䐀愀琀攀伀渀氀礀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceTimeZoneSidKey] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[WhatCount] [int] NULL,਍ऀ嬀圀栀愀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[WhoCount] [int] NULL,਍ऀ嬀刀攀洀椀渀搀攀爀䐀愀琀攀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsReminderSet] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀刀攀最攀渀攀爀愀琀攀搀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Result__c] [nvarchar](max) NULL,਍ऀ嬀匀攀爀瘀椀挀攀开吀攀爀爀椀琀漀爀礀开䌀愀氀氀攀爀开䤀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SPRecordingOrTranscriptURL__c] [nvarchar](max) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Subject] [nvarchar](max) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecordTypeId] [nvarchar](max) NULL,਍ऀ嬀吀愀猀欀匀甀戀琀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Type] [nvarchar](max) NULL,਍ऀ嬀刀漀眀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ngroup] [int] NOT NULL,਍ऀ嬀椀猀氀漀愀搀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[NewOwnerId] [varchar](250) NULL,਍ऀ嬀一攀眀䌀爀攀愀琀攀搀䈀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[NewRecordTypeId] [varchar](250) NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
