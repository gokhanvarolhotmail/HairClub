/* CreateDate: 03/03/2022 13:53:57.360 , ModifyDate: 03/04/2022 07:55:32.870 */
GO
CREATE TABLE [SF].[Task](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhatId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhatCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDate] [date] NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Priority] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsHighPriority] [bit] NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosed] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsArchived] [bit] NULL,
	[CallDurationInSeconds] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallDisposition] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallObject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReminderDateTime] [datetime2](7) NULL,
	[IsReminderSet] [bit] NULL,
	[RecurrenceActivityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRecurrence] [bit] NULL,
	[RecurrenceStartDateOnly] [date] NULL,
	[RecurrenceEndDateOnly] [date] NULL,
	[RecurrenceTimeZoneSidKey] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceInterval] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceDayOfWeekMask] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceDayOfMonth] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceInstance] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceMonthOfYear] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceRegeneratedType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskSubtype] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletedDateTime] [datetime2](7) NULL,
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
	[TaskWhoIds] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Task] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Task]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Task]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
