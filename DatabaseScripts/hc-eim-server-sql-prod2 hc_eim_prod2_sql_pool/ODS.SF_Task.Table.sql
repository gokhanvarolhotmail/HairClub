/****** Object:  Table [ODS].[SF_Task]    Script Date: 2/18/2022 8:28:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_Task]
(
	[Id] [nvarchar](max) NULL,
	[RecordTypeId] [nvarchar](max) NULL,
	[WhoId] [nvarchar](max) NULL,
	[WhatId] [nvarchar](max) NULL,
	[WhoCount] [int] NULL,
	[WhatCount] [int] NULL,
	[Subject] [nvarchar](max) NULL,
	[ActivityDate] [datetime2](7) NULL,
	[Status] [nvarchar](max) NULL,
	[Priority] [nvarchar](max) NULL,
	[IsHighPriority] [bit] NULL,
	[OwnerId] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CurrencyIsoCode] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[AccountId] [nvarchar](max) NULL,
	[IsClosed] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [nvarchar](max) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsArchived] [bit] NULL,
	[CallDurationInSeconds] [int] NULL,
	[CallType] [nvarchar](max) NULL,
	[CallDisposition] [nvarchar](max) NULL,
	[CallObject] [nvarchar](max) NULL,
	[ReminderDateTime] [datetime2](7) NULL,
	[IsReminderSet] [bit] NULL,
	[RecurrenceActivityId] [nvarchar](max) NULL,
	[IsRecurrence] [bit] NULL,
	[RecurrenceStartDateOnly] [datetime2](7) NULL,
	[RecurrenceEndDateOnly] [datetime2](7) NULL,
	[RecurrenceTimeZoneSidKey] [nvarchar](max) NULL,
	[RecurrenceType] [nvarchar](max) NULL,
	[RecurrenceInterval] [int] NULL,
	[RecurrenceDayOfWeekMask] [int] NULL,
	[RecurrenceDayOfMonth] [int] NULL,
	[RecurrenceInstance] [nvarchar](max) NULL,
	[RecurrenceMonthOfYear] [nvarchar](max) NULL,
	[RecurrenceRegeneratedType] [nvarchar](max) NULL,
	[TaskSubtype] [nvarchar](max) NULL,
	[CompletedDateTime] [datetime2](7) NULL,
	[Center_Name__c] [nvarchar](max) NULL,
	[Completed_Date__c] [datetime2](7) NULL,
	[External_ID__c] [nvarchar](max) NULL,
	[Lead__c] [nvarchar](max) NULL,
	[Person_Account__c] [nvarchar](max) NULL,
	[Recording_Link__c] [nvarchar](max) NULL,
	[Result__c] [nvarchar](max) NULL,
	[SPRecordingOrTranscriptURL__c] [nvarchar](max) NULL,
	[Service_Appointment__c] [nvarchar](max) NULL,
	[Service_Territory_Caller_Id__c] [nvarchar](max) NULL,
	[TaskWhoIds] [nvarchar](max) NULL,
	[BrightPattern__SPRecordingOrTranscriptURL__c] [nvarchar](max) NULL,
	[Meeting_Platform_Id__c] [nvarchar](max) NULL,
	[Meeting_Platform__c] [nvarchar](max) NULL,
	[Agent_Link__c] [nvarchar](max) NULL,
	[Guest_Link__c] [nvarchar](max) NULL,
	[Opportunity__c] [nvarchar](max) NULL,
	[Center_Phone__c] [nvarchar](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
