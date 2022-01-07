/****** Object:  Table [ODS].[SFDC_Event]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SFDC_Event]
(
	[Id] [varchar](8000) NULL,
	[WhoId] [varchar](8000) NULL,
	[WhatId] [varchar](8000) NULL,
	[WhoCount] [int] NULL,
	[WhatCount] [int] NULL,
	[Subject] [varchar](8000) NULL,
	[Location] [varchar](8000) NULL,
	[IsAllDayEvent] [bit] NULL,
	[ActivityDateTime] [datetime2](7) NULL,
	[ActivityDate] [datetime2](7) NULL,
	[DurationInMinutes] [int] NULL,
	[StartDateTime] [datetime2](7) NULL,
	[EndDateTime] [datetime2](7) NULL,
	[Description] [varchar](8000) NULL,
	[AccountId] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[Type] [varchar](8000) NULL,
	[IsPrivate] [bit] NULL,
	[ShowAs] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[IsChild] [bit] NULL,
	[IsGroupEvent] [bit] NULL,
	[GroupEventType] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsArchived] [bit] NULL,
	[RecurrenceActivityId] [varchar](8000) NULL,
	[IsRecurrence] [bit] NULL,
	[RecurrenceStartDateTime] [datetime2](7) NULL,
	[RecurrenceEndDateOnly] [datetime2](7) NULL,
	[RecurrenceTimeZoneSidKey] [varchar](8000) NULL,
	[RecurrenceType] [varchar](8000) NULL,
	[RecurrenceInterval] [int] NULL,
	[RecurrenceDayOfWeekMask] [int] NULL,
	[RecurrenceDayOfMonth] [int] NULL,
	[RecurrenceInstance] [varchar](8000) NULL,
	[RecurrenceMonthOfYear] [varchar](8000) NULL,
	[ReminderDateTime] [datetime2](7) NULL,
	[IsReminderSet] [bit] NULL,
	[EventSubtype] [varchar](8000) NULL,
	[IsRecurrence2Exclusion] [bit] NULL,
	[Recurrence2PatternText] [varchar](8000) NULL,
	[Recurrence2PatternVersion] [varchar](8000) NULL,
	[IsRecurrence2] [bit] NULL,
	[IsRecurrence2Exception] [bit] NULL,
	[Recurrence2PatternStartDate] [datetime2](7) NULL,
	[Recurrence2PatternTimeZone] [varchar](8000) NULL,
	[ActivityType__c] [varchar](8000) NULL,
	[Action__c] [varchar](8000) NULL,
	[Result__c] [varchar](8000) NULL,
	[NCCPromoCode__c] [varchar](8000) NULL,
	[DisplayName__c] [varchar](8000) NULL,
	[ActivityID__c] [varchar](8000) NULL,
	[CompletionDate__c] [datetime2](7) NULL,
	[TaskCase__c] [varchar](8000) NULL,
	[Center__c] [varchar](8000) NULL,
	[CreatedByL__c] [varchar](8000) NULL,
	[SourceCode__c] [varchar](8000) NULL,
	[Accommodation__c] [varchar](8000) NULL,
	[OnCMinsSinceCreated__c] [numeric](38, 18) NULL,
	[UserCode__c] [varchar](8000) NULL,
	[CallBackDate__c] [datetime2](7) NULL,
	[Lead__c] [varchar](8000) NULL,
	[NoApptCancelReason__c] [varchar](8000) NULL,
	[Campaign__c] [varchar](8000) NULL,
	[PromoCodeDisplay__c] [varchar](8000) NULL,
	[OncCreatedDate__c] [datetime2](7) NULL,
	[CallerID__c] [varchar](8000) NULL,
	[StartTime__c] [varchar](8000) NULL,
	[EndTime__c] [varchar](8000) NULL,
	[EventID__c] [varchar](8000) NULL,
	[AppointmentDate__c] [datetime2](7) NULL,
	[EventHRID__c] [varchar](8000) NULL,
	[CallBackTime__c] [varchar](8000) NULL,
	[CallbackTimeFormatted__c] [varchar](8000) NULL,
	[CampaignID__c] [varchar](8000) NULL,
	[CenterNumber__c] [varchar](8000) NULL,
	[ContactID__c] [varchar](8000) NULL,
	[LeadCity__c] [varchar](8000) NULL,
	[LeadSource__c] [varchar](8000) NULL,
	[LeadState__c] [varchar](8000) NULL,
	[LeadZipCode__c] [varchar](8000) NULL,
	[NobleAddition__c] [bit] NULL,
	[NobleException__c] [bit] NULL,
	[Recording_Link__c] [varchar](8000) NULL,
	[PromoCode__c] [varchar](8000) NULL,
	[PromoCodeID__c] [varchar](8000) NULL,
	[ReceiveBrochure__c] [bit] NULL,
	[StartTimeFormatted__c] [varchar](8000) NULL,
	[TextNumber__c] [varchar](8000) NULL,
	[TextOptIn__c] [bit] NULL,
	[TimeZone__c] [varchar](8000) NULL,
	[SPRecordingOrTranscriptURL__c] [varchar](8000) NULL,
	[DB_Activity_Type__c] [varchar](8000) NULL,
	[EndTimeFormatted__c] [varchar](8000) NULL,
	[InOutNumber__c] [varchar](8000) NULL,
	[IPAddress__c] [varchar](8000) NULL,
	[LeadEthnicity__c] [varchar](8000) NULL,
	[LeadFirstName__c] [varchar](8000) NULL,
	[LeadGender__c] [varchar](8000) NULL,
	[LeadLanguage__c] [varchar](8000) NULL,
	[LeadLastName__c] [varchar](8000) NULL,
	[LeadLudwigScale__c] [varchar](8000) NULL,
	[LeadPhone__c] [varchar](8000) NULL,
	[DISC__c] [varchar](8000) NULL,
	[PriceQuoted__c] [numeric](38, 18) NULL,
	[LudwigScale__c] [varchar](8000) NULL,
	[MaritalStatus__c] [varchar](8000) NULL,
	[NorwoodScale__c] [varchar](8000) NULL,
	[Occupation__c] [varchar](8000) NULL,
	[SolutionOffered__c] [varchar](8000) NULL,
	[NoSaleReason__c] [varchar](8000) NULL,
	[Performer__c] [varchar](8000) NULL,
	[FollowUpDate__c] [datetime2](7) NULL,
	[UniqueTaskID__c] [varchar](8000) NULL,
	[HairLossScale__c] [varchar](8000) NULL,
	[SaleTypeCode__c] [varchar](8000) NULL,
	[SaleTypeDescription__c] [varchar](8000) NULL,
	[ConfirmCallOptOut__c] [bit] NULL,
	[ToBeProcessed__c] [bit] NULL,
	[LastProcessedDate__c] [datetime2](7) NULL,
	[LeadOncContactID__c] [varchar](8000) NULL,
	[LeadOncBirthday__c] [datetime2](7) NULL,
	[LeadOncGender__c] [varchar](8000) NULL,
	[LeadOncEthnicity__c] [varchar](8000) NULL,
	[LeadOncAge__c] [numeric](38, 18) NULL,
	[CenterID__c] [varchar](8000) NULL,
	[Converted__c] [varchar](8000) NULL,
	[Email__c] [varchar](8000) NULL,
	[LastModifedBy__c] [varchar](8000) NULL,
	[LeadCampaignID__c] [varchar](8000) NULL,
	[LeadID__c] [varchar](8000) NULL,
	[OncBatchProcessedDate__c] [varchar](8000) NULL,
	[LastModifiedDate__c] [datetime2](7) NULL,
	[CreatedTime__c] [datetime2](7) NULL,
	[ReportCreateDate__c] [datetime2](7) NULL,
	[ActivitySource__c] [varchar](8000) NULL,
	[DeviceType__c] [varchar](8000) NULL,
	[OriginalLeadId__c] [varchar](8000) NULL,
	[TaskCreationDate__c] [datetime2](7) NULL,
	[Consultation_Form__c] [varchar](8000) NULL,
	[Customer__c] [varchar](8000) NULL,
	[ConsultationFormURL__c] [varchar](8000) NULL,
	[ReferralCode__c] [varchar](8000) NULL,
	[PerformerID__c] [varchar](8000) NULL,
	[AcceptedEventInviteeIds] [varchar](8000) NULL,
	[DeclinedEventInviteeIds] [varchar](8000) NULL,
	[EventWhoIds] [varchar](8000) NULL,
	[UndecidedEventInviteeIds] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
