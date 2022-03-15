/****** Object:  Table [ODS].[SF_Event]    Script Date: 3/15/2022 2:11:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_Event]
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
	[BrightPattern__SPRecordingOrTranscriptURL__c] [varchar](8000) NULL,
	[Center_Name__c] [varchar](8000) NULL,
	[Completed_Date__c] [datetime2](7) NULL,
	[External_ID__c] [varchar](8000) NULL,
	[Lead__c] [varchar](8000) NULL,
	[Meeting_Platform_Id__c] [varchar](8000) NULL,
	[Meeting_Platform__c] [varchar](8000) NULL,
	[Person_Account__c] [varchar](8000) NULL,
	[Recording_Link__c] [varchar](8000) NULL,
	[Result__c] [varchar](8000) NULL,
	[SPRecordingOrTranscriptURL__c] [varchar](8000) NULL,
	[Service_Appointment__c] [varchar](8000) NULL,
	[Service_Territory_Caller_Id__c] [varchar](8000) NULL,
	[Agent_Link__c] [varchar](8000) NULL,
	[Guest_Link__c] [varchar](8000) NULL,
	[Opportunity__c] [varchar](8000) NULL,
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
