/****** Object:  Table [ODS].[SFDC_Task]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀ഀഀ
(਍ऀ嬀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecordTypeId] [varchar](8000) NULL,਍ऀ嬀圀栀漀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WhatId] [varchar](8000) NULL,਍ऀ嬀圀栀漀䌀漀甀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[WhatCount] [int] NULL,਍ऀ嬀匀甀戀樀攀挀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityDate] [datetime2](7) NULL,਍ऀ嬀匀琀愀琀甀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Priority] [varchar](8000) NULL,਍ऀ嬀䤀猀䠀椀最栀倀爀椀漀爀椀琀礀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [varchar](8000) NULL,਍ऀ嬀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyIsoCode] [varchar](8000) NULL,਍ऀ嬀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsDeleted] [bit] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsClosed] [bit] NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [varchar](8000) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀䌀愀氀氀䐀甀爀愀琀椀漀渀䤀渀匀攀挀漀渀搀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CallType] [varchar](8000) NULL,਍ऀ嬀䌀愀氀氀䐀椀猀瀀漀猀椀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CallObject] [varchar](8000) NULL,਍ऀ嬀刀攀洀椀渀搀攀爀䐀愀琀攀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsReminderSet] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䄀挀琀椀瘀椀琀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀匀琀愀爀琀䐀愀琀攀伀渀氀礀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceEndDateOnly] [datetime2](7) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀吀椀洀攀娀漀渀攀匀椀搀䬀攀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceType] [varchar](8000) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䤀渀琀攀爀瘀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceDayOfWeekMask] [int] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䐀愀礀伀昀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceInstance] [varchar](8000) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䴀漀渀琀栀伀昀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceRegeneratedType] [varchar](8000) NULL,਍ऀ嬀吀愀猀欀匀甀戀琀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CompletedDateTime] [datetime2](7) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀吀礀瀀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Action__c] [varchar](8000) NULL,਍ऀ嬀刀攀猀甀氀琀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NCCPromoCode__c] [varchar](8000) NULL,਍ऀ嬀䐀椀猀瀀氀愀礀一愀洀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityID__c] [varchar](8000) NULL,਍ऀ嬀䌀漀洀瀀氀攀琀椀漀渀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskCase__c] [varchar](8000) NULL,਍ऀ嬀䌀攀渀琀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedByL__c] [varchar](8000) NULL,਍ऀ嬀匀漀甀爀挀攀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Accommodation__c] [varchar](8000) NULL,਍ऀ嬀伀渀䌀䴀椀渀猀匀椀渀挀攀䌀爀攀愀琀攀搀开开挀崀 嬀渀甀洀攀爀椀挀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[UserCode__c] [varchar](8000) NULL,਍ऀ嬀䌀愀氀氀䈀愀挀欀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Lead__c] [varchar](8000) NULL,਍ऀ嬀一漀䄀瀀瀀琀䌀愀渀挀攀氀刀攀愀猀漀渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Campaign__c] [varchar](8000) NULL,਍ऀ嬀倀爀漀洀漀䌀漀搀攀䐀椀猀瀀氀愀礀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OncCreatedDate__c] [datetime2](7) NULL,਍ऀ嬀䌀愀氀氀攀爀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StartTime__c] [varchar](8000) NULL,਍ऀ嬀䔀渀搀吀椀洀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[EventID__c] [varchar](8000) NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[EventHRID__c] [varchar](8000) NULL,਍ऀ嬀䌀愀氀氀䈀愀挀欀吀椀洀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CallbackTimeFormatted__c] [varchar](8000) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterNumber__c] [varchar](8000) NULL,਍ऀ嬀䌀漀渀琀愀挀琀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadCity__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀匀漀甀爀挀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadState__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀娀椀瀀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NobleAddition__c] [bit] NULL,਍ऀ嬀一漀戀氀攀䔀砀挀攀瀀琀椀漀渀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Recording_Link__c] [varchar](8000) NULL,਍ऀ嬀倀爀漀洀漀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PromoCodeID__c] [varchar](8000) NULL,਍ऀ嬀刀攀挀攀椀瘀攀䈀爀漀挀栀甀爀攀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[StartTimeFormatted__c] [varchar](8000) NULL,਍ऀ嬀吀攀砀琀一甀洀戀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TextOptIn__c] [bit] NULL,਍ऀ嬀吀椀洀攀娀漀渀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SPRecordingOrTranscriptURL__c] [varchar](8000) NULL,਍ऀ嬀䐀䈀开䄀挀琀椀瘀椀琀礀开吀礀瀀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[EndTimeFormatted__c] [varchar](8000) NULL,਍ऀ嬀䤀渀伀甀琀一甀洀戀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IPAddress__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䔀琀栀渀椀挀椀琀礀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadFirstName__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䜀攀渀搀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadLanguage__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䰀愀猀琀一愀洀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadLudwigScale__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀倀栀漀渀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DISC__c] [varchar](8000) NULL,਍ऀ嬀倀爀椀挀攀儀甀漀琀攀搀开开挀崀 嬀渀甀洀攀爀椀挀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[LudwigScale__c] [varchar](8000) NULL,਍ऀ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NorwoodScale__c] [varchar](8000) NULL,਍ऀ嬀伀挀挀甀瀀愀琀椀漀渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SolutionOffered__c] [varchar](8000) NULL,਍ऀ嬀一漀匀愀氀攀刀攀愀猀漀渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Performer__c] [varchar](8000) NULL,਍ऀ嬀䘀漀氀氀漀眀唀瀀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[UniqueTaskID__c] [varchar](8000) NULL,਍ऀ嬀䠀愀椀爀䰀漀猀猀匀挀愀氀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SaleTypeCode__c] [varchar](8000) NULL,਍ऀ嬀匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ConfirmCallOptOut__c] [bit] NULL,਍ऀ嬀吀漀䈀攀倀爀漀挀攀猀猀攀搀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[LastProcessedDate__c] [datetime2](7) NULL,਍ऀ嬀䰀攀愀搀伀渀挀䌀漀渀琀愀挀琀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncBirthday__c] [datetime2](7) NULL,਍ऀ嬀䰀攀愀搀伀渀挀䜀攀渀搀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncEthnicity__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀伀渀挀䄀最攀开开挀崀 嬀渀甀洀攀爀椀挀崀⠀㌀㠀Ⰰ ㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[CenterID__c] [varchar](8000) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Email__c] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀攀搀䈀礀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadCampaignID__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OncBatchProcessedDate__c] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedTime__c] [datetime2](7) NULL,਍ऀ嬀刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivitySource__c] [varchar](8000) NULL,਍ऀ嬀䐀攀瘀椀挀攀吀礀瀀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OriginalLeadId__c] [varchar](8000) NULL,਍ऀ嬀吀愀猀欀䌀爀攀愀琀椀漀渀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Consultation_Form__c] [varchar](8000) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ConsultationFormURL__c] [varchar](8000) NULL,਍ऀ嬀刀攀昀攀爀爀愀氀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PerformerID__c] [varchar](8000) NULL,਍ऀ嬀吀愀猀欀圀栀漀䤀搀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 䠀䄀匀䠀 ⠀ 嬀䤀搀崀 ⤀Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
