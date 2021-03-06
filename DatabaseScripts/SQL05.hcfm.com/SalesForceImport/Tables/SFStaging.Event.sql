/* CreateDate: 03/03/2022 13:54:34.200 , ModifyDate: 03/08/2022 08:42:47.373 */
GO
CREATE TABLE [SFStaging].[Event](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[WhoId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhatId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhatCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAllDayEvent] [bit] NULL,
	[ActivityDateTime] [datetime2](7) NULL,
	[ActivityDate] [date] NULL,
	[DurationInMinutes] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDateTime] [datetime2](7) NULL,
	[EndDateTime] [datetime2](7) NULL,
	[EndDate] [date] NULL,
	[Description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPrivate] [bit] NULL,
	[ShowAs] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[IsChild] [bit] NULL,
	[IsGroupEvent] [bit] NULL,
	[GroupEventType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsArchived] [bit] NULL,
	[RecurrenceActivityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRecurrence] [bit] NULL,
	[RecurrenceStartDateTime] [datetime2](7) NULL,
	[RecurrenceEndDateOnly] [date] NULL,
	[RecurrenceTimeZoneSidKey] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceInterval] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceDayOfWeekMask] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceDayOfMonth] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceInstance] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceMonthOfYear] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReminderDateTime] [datetime2](7) NULL,
	[IsReminderSet] [bit] NULL,
	[EventSubtype] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRecurrence2Exclusion] [bit] NULL,
	[Recurrence2PatternText] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Recurrence2PatternVersion] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRecurrence2] [bit] NULL,
	[IsRecurrence2Exception] [bit] NULL,
	[Recurrence2PatternStartDate] [datetime2](7) NULL,
	[Recurrence2PatternTimeZone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceAppointmentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrightPattern__SPRecordingOrTranscriptURL__c] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Name__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Completed_Date__c] [date] NULL,
	[External_ID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform_Id__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Person_Account__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Recording_Link__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SPRecordingOrTranscriptURL__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Appointment__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Caller_Id__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agent_Link__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Guest_Link__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Opportunity__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Phone__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Activity_Type__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallBackDueDate__c] [date] NULL,
	[Invite__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AcceptedEventInviteeIds] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeclinedEventInviteeIds] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EventWhoIds] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UndecidedEventInviteeIds] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Event] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
