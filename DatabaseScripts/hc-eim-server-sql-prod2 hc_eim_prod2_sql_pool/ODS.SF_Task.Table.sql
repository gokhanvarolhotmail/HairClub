/****** Object:  Table [ODS].[SF_Task]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀匀䘀开吀愀猀欀崀ഀഀ
(਍ऀ嬀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecordTypeId] [nvarchar](max) NULL,਍ऀ嬀圀栀漀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[WhatId] [nvarchar](max) NULL,਍ऀ嬀圀栀漀䌀漀甀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[WhatCount] [int] NULL,਍ऀ嬀匀甀戀樀攀挀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityDate] [datetime2](7) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Priority] [nvarchar](max) NULL,਍ऀ嬀䤀猀䠀椀最栀倀爀椀漀爀椀琀礀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [nvarchar](max) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [nvarchar](max) NULL,਍ऀ嬀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsClosed] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [nvarchar](max) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [nvarchar](max) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀䌀愀氀氀䐀甀爀愀琀椀漀渀䤀渀匀攀挀漀渀搀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CallType] [nvarchar](max) NULL,਍ऀ嬀䌀愀氀氀䐀椀猀瀀漀猀椀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CallObject] [nvarchar](max) NULL,਍ऀ嬀刀攀洀椀渀搀攀爀䐀愀琀攀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsReminderSet] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䄀挀琀椀瘀椀琀礀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀匀琀愀爀琀䐀愀琀攀伀渀氀礀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceEndDateOnly] [datetime2](7) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀吀椀洀攀娀漀渀攀匀椀搀䬀攀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceType] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䤀渀琀攀爀瘀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceDayOfWeekMask] [int] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䐀愀礀伀昀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceInstance] [nvarchar](max) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䴀漀渀琀栀伀昀夀攀愀爀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceRegeneratedType] [nvarchar](max) NULL,਍ऀ嬀吀愀猀欀匀甀戀琀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[CompletedDateTime] [datetime2](7) NULL,਍ऀ嬀䌀攀渀琀攀爀开一愀洀攀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Completed_Date__c] [datetime2](7) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀开䤀䐀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Lead__c] [nvarchar](max) NULL,਍ऀ嬀倀攀爀猀漀渀开䄀挀挀漀甀渀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Recording_Link__c] [nvarchar](max) NULL,਍ऀ嬀刀攀猀甀氀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[SPRecordingOrTranscriptURL__c] [nvarchar](max) NULL,਍ऀ嬀匀攀爀瘀椀挀攀开䄀瀀瀀漀椀渀琀洀攀渀琀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Service_Territory_Caller_Id__c] [nvarchar](max) NULL,਍ऀ嬀吀愀猀欀圀栀漀䤀搀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[BrightPattern__SPRecordingOrTranscriptURL__c] [nvarchar](max) NULL,਍ऀ嬀䴀攀攀琀椀渀最开倀氀愀琀昀漀爀洀开䤀搀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Meeting_Platform__c] [nvarchar](max) NULL,਍ऀ嬀䄀最攀渀琀开䰀椀渀欀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Guest_Link__c] [nvarchar](max) NULL,਍ऀ嬀伀瀀瀀漀爀琀甀渀椀琀礀开开挀崀 嬀渀瘀愀爀挀栀愀爀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[Center_Phone__c] [nvarchar](max) NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䠀䔀䄀倀ഀഀ
)਍䜀伀ഀഀ
