/****** Object:  Table [dbo].[SLF_Final_Event]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀匀䰀䘀开䘀椀渀愀氀开䔀瘀攀渀琀崀⠀ഀഀ
	[Id] [varchar](1) NOT NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](max) NULL,਍ऀ嬀䤀猀䄀氀氀䐀愀礀䔀瘀攀渀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀伀眀渀攀爀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Completed_Date__c] [nvarchar](4000) NOT NULL,਍ऀ嬀䤀猀刀攀挀甀爀爀攀渀挀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](max) NULL,਍ऀ嬀䌀刀䔀䄀吀䔀䐀䐀䄀吀䔀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ACTIVITYDATE] [nvarchar](4000) NOT NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀吀椀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[DurationInMinutes] [int] NULL,਍ऀ嬀䔀渀搀䐀愀琀攀吀椀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[EventSubtype] [nvarchar](max) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀开䤀䐀开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[GroupEventType] [nvarchar](max) NULL,਍ऀ嬀䤀猀䌀栀椀氀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsGroupEvent] [bit] NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䈀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate] [nvarchar](4000) NOT NULL,਍ऀ嬀䰀攀愀搀开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Location] [nvarchar](max) NULL,਍ऀ嬀圀栀漀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Person_Account_c] [varchar](1) NOT NULL,਍ऀ嬀䤀猀倀爀椀瘀愀琀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsVisibleInSelfService] [bit] NULL,਍ऀ嬀刀攀挀漀爀搀椀渀最开䰀椀渀欀开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BrightPattern__SPRecordingOrTranscriptURL__c] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䄀挀琀椀瘀椀琀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceType] [nvarchar](max) NULL,਍ऀ嬀圀栀愀琀䌀漀甀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[WhatId] [varchar](250) NULL,਍ऀ嬀圀栀漀䌀漀甀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ReminderDateTime] [datetime2](7) NULL,਍ऀ嬀䤀猀刀攀洀椀渀搀攀爀匀攀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Result__c] [nvarchar](max) NULL,਍ऀ嬀匀攀爀瘀椀挀攀开吀攀爀爀椀琀漀爀礀开䌀愀氀氀攀爀开䤀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ShowAs] [nvarchar](max) NULL,਍ऀ嬀匀倀刀攀挀漀爀搀椀渀最伀爀吀爀愀渀猀挀爀椀瀀琀唀刀䰀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[StartDateTime] [nvarchar](4000) NOT NULL,਍ऀ嬀匀甀戀樀攀挀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SystemModstamp] [datetime2](7) NULL,਍ऀ嬀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityID__c] [nvarchar](max) NULL,਍ऀ嬀渀最爀漀甀瀀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[isload] [int] NOT NULL,਍ऀ嬀一攀眀伀眀渀攀爀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀㔀　⤀ 一唀䰀䰀Ⰰഀഀ
	[NewCreatedById] [varchar](250) NULL਍⤀ 伀一 嬀倀刀䤀䴀䄀刀夀崀 吀䔀堀吀䤀䴀䄀䜀䔀开伀一 嬀倀刀䤀䴀䄀刀夀崀ഀഀ
GO਍
