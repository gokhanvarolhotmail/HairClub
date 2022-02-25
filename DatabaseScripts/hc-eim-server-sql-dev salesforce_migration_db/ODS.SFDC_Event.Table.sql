/****** Object:  Table [ODS].[SFDC_Event]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䔀瘀攀渀琀崀ഀഀ
(਍ऀ嬀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WhoId] [varchar](8000) NULL,਍ऀ嬀圀栀愀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[WhoCount] [int] NULL,਍ऀ嬀圀栀愀琀䌀漀甀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Subject] [varchar](8000) NULL,਍ऀ嬀䰀漀挀愀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsAllDayEvent] [bit] NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityDate] [datetime2](7) NULL,਍ऀ嬀䐀甀爀愀琀椀漀渀䤀渀䴀椀渀甀琀攀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[StartDateTime] [datetime2](7) NULL,਍ऀ嬀䔀渀搀䐀愀琀攀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[Description] [varchar](8000) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OwnerId] [varchar](8000) NULL,਍ऀ嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Type] [varchar](8000) NULL,਍ऀ嬀䤀猀倀爀椀瘀愀琀攀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ShowAs] [varchar](8000) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsChild] [bit] NULL,਍ऀ嬀䤀猀䜀爀漀甀瀀䔀瘀攀渀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[GroupEventType] [varchar](8000) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CreatedById] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedById] [varchar](8000) NULL,਍ऀ嬀匀礀猀琀攀洀䴀漀搀猀琀愀洀瀀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[IsArchived] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䄀挀琀椀瘀椀琀礀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀匀琀愀爀琀䐀愀琀攀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceEndDateOnly] [datetime2](7) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀吀椀洀攀娀漀渀攀匀椀搀䬀攀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RecurrenceType] [varchar](8000) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䤀渀琀攀爀瘀愀氀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceDayOfWeekMask] [int] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䐀愀礀伀昀䴀漀渀琀栀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[RecurrenceInstance] [varchar](8000) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀䴀漀渀琀栀伀昀夀攀愀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ReminderDateTime] [datetime2](7) NULL,਍ऀ嬀䤀猀刀攀洀椀渀搀攀爀匀攀琀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[EventSubtype] [varchar](8000) NULL,਍ऀ嬀䤀猀刀攀挀甀爀爀攀渀挀攀㈀䔀砀挀氀甀猀椀漀渀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Recurrence2PatternText] [varchar](8000) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀㈀倀愀琀琀攀爀渀嘀攀爀猀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsRecurrence2] [bit] NULL,਍ऀ嬀䤀猀刀攀挀甀爀爀攀渀挀攀㈀䔀砀挀攀瀀琀椀漀渀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[Recurrence2PatternStartDate] [datetime2](7) NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀㈀倀愀琀琀攀爀渀吀椀洀攀娀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ActivityType__c] [varchar](8000) NULL,਍ऀ嬀䄀挀琀椀漀渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Result__c] [varchar](8000) NULL,਍ऀ嬀一䌀䌀倀爀漀洀漀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DisplayName__c] [varchar](8000) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CompletionDate__c] [datetime2](7) NULL,਍ऀ嬀吀愀猀欀䌀愀猀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Center__c] [varchar](8000) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀䰀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SourceCode__c] [varchar](8000) NULL,਍ऀ嬀䄀挀挀漀洀洀漀搀愀琀椀漀渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[OnCMinsSinceCreated__c] [numeric](38, 18) NULL,਍ऀ嬀唀猀攀爀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CallBackDate__c] [datetime2](7) NULL,਍ऀ嬀䰀攀愀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NoApptCancelReason__c] [varchar](8000) NULL,਍ऀ嬀䌀愀洀瀀愀椀最渀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PromoCodeDisplay__c] [varchar](8000) NULL,਍ऀ嬀伀渀挀䌀爀攀愀琀攀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[CallerID__c] [varchar](8000) NULL,਍ऀ嬀匀琀愀爀琀吀椀洀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[EndTime__c] [varchar](8000) NULL,਍ऀ嬀䔀瘀攀渀琀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentDate__c] [datetime2](7) NULL,਍ऀ嬀䔀瘀攀渀琀䠀刀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CallBackTime__c] [varchar](8000) NULL,਍ऀ嬀䌀愀氀氀戀愀挀欀吀椀洀攀䘀漀爀洀愀琀琀攀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignID__c] [varchar](8000) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactID__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䌀椀琀礀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadSource__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀匀琀愀琀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadZipCode__c] [varchar](8000) NULL,਍ऀ嬀一漀戀氀攀䄀搀搀椀琀椀漀渀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[NobleException__c] [bit] NULL,਍ऀ嬀刀攀挀漀爀搀椀渀最开䰀椀渀欀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PromoCode__c] [varchar](8000) NULL,਍ऀ嬀倀爀漀洀漀䌀漀搀攀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ReceiveBrochure__c] [bit] NULL,਍ऀ嬀匀琀愀爀琀吀椀洀攀䘀漀爀洀愀琀琀攀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TextNumber__c] [varchar](8000) NULL,਍ऀ嬀吀攀砀琀伀瀀琀䤀渀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[TimeZone__c] [varchar](8000) NULL,਍ऀ嬀匀倀刀攀挀漀爀搀椀渀最伀爀吀爀愀渀猀挀爀椀瀀琀唀刀䰀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DB_Activity_Type__c] [varchar](8000) NULL,਍ऀ嬀䔀渀搀吀椀洀攀䘀漀爀洀愀琀琀攀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[InOutNumber__c] [varchar](8000) NULL,਍ऀ嬀䤀倀䄀搀搀爀攀猀猀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadEthnicity__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䘀椀爀猀琀一愀洀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadGender__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䰀愀渀最甀愀最攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadLastName__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䰀甀搀眀椀最匀挀愀氀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadPhone__c] [varchar](8000) NULL,਍ऀ嬀䐀䤀匀䌀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PriceQuoted__c] [numeric](38, 18) NULL,਍ऀ嬀䰀甀搀眀椀最匀挀愀氀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MaritalStatus__c] [varchar](8000) NULL,਍ऀ嬀一漀爀眀漀漀搀匀挀愀氀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Occupation__c] [varchar](8000) NULL,਍ऀ嬀匀漀氀甀琀椀漀渀伀昀昀攀爀攀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[NoSaleReason__c] [varchar](8000) NULL,਍ऀ嬀倀攀爀昀漀爀洀攀爀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FollowUpDate__c] [datetime2](7) NULL,਍ऀ嬀唀渀椀焀甀攀吀愀猀欀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[HairLossScale__c] [varchar](8000) NULL,਍ऀ嬀匀愀氀攀吀礀瀀攀䌀漀搀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[SaleTypeDescription__c] [varchar](8000) NULL,਍ऀ嬀䌀漀渀昀椀爀洀䌀愀氀氀伀瀀琀伀甀琀开开挀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[ToBeProcessed__c] [bit] NULL,਍ऀ嬀䰀愀猀琀倀爀漀挀攀猀猀攀搀䐀愀琀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncContactID__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀伀渀挀䈀椀爀琀栀搀愀礀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncGender__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀伀渀挀䔀琀栀渀椀挀椀琀礀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOncAge__c] [numeric](38, 18) NULL,਍ऀ嬀䌀攀渀琀攀爀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Converted__c] [varchar](8000) NULL,਍ऀ嬀䔀洀愀椀氀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifedBy__c] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䌀愀洀瀀愀椀最渀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadID__c] [varchar](8000) NULL,਍ऀ嬀伀渀挀䈀愀琀挀栀倀爀漀挀攀猀猀攀搀䐀愀琀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastModifiedDate__c] [datetime2](7) NULL,਍ऀ嬀䌀爀攀愀琀攀搀吀椀洀攀开开挀崀 嬀搀愀琀攀琀椀洀攀㈀崀⠀㜀⤀ 一唀䰀䰀Ⰰഀഀ
	[ReportCreateDate__c] [datetime2](7) NULL,਍ऀ嬀䄀挀琀椀瘀椀琀礀匀漀甀爀挀攀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DeviceType__c] [varchar](8000) NULL,਍ऀ嬀伀爀椀最椀渀愀氀䰀攀愀搀䤀搀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TaskCreationDate__c] [datetime2](7) NULL,਍ऀ嬀䌀漀渀猀甀氀琀愀琀椀漀渀开䘀漀爀洀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Customer__c] [varchar](8000) NULL,਍ऀ嬀䌀漀渀猀甀氀琀愀琀椀漀渀䘀漀爀洀唀刀䰀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ReferralCode__c] [varchar](8000) NULL,਍ऀ嬀倀攀爀昀漀爀洀攀爀䤀䐀开开挀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AcceptedEventInviteeIds] [varchar](8000) NULL,਍ऀ嬀䐀攀挀氀椀渀攀搀䔀瘀攀渀琀䤀渀瘀椀琀攀攀䤀搀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[EventWhoIds] [varchar](8000) NULL,਍ऀ嬀唀渀搀攀挀椀搀攀搀䔀瘀攀渀琀䤀渀瘀椀琀攀攀䤀搀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
