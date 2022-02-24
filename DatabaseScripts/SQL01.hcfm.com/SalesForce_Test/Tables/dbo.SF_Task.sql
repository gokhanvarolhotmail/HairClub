/* CreateDate: 02/21/2022 15:14:17.970 , ModifyDate: 02/21/2022 15:14:17.970 */
GO
CREATE TABLE [dbo].[SF_Task](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RecordTypeId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhatId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoCount] [int] NULL,
	[WhatCount] [int] NULL,
	[Subject] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDate] [date] NULL,
	[Status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Priority] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsHighPriority] [bit] NOT NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosed] [bit] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SystemModstamp] [datetime2](7) NOT NULL,
	[IsArchived] [bit] NOT NULL,
	[CallDurationInSeconds] [int] NULL,
	[CallType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallDisposition] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallObject] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReminderDateTime] [datetime2](7) NULL,
	[IsReminderSet] [bit] NOT NULL,
	[RecurrenceActivityId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRecurrence] [bit] NOT NULL,
	[RecurrenceStartDateOnly] [date] NULL,
	[RecurrenceEndDateOnly] [date] NULL,
	[RecurrenceTimeZoneSidKey] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceInterval] [int] NULL,
	[RecurrenceDayOfWeekMask] [int] NULL,
	[RecurrenceDayOfMonth] [int] NULL,
	[RecurrenceInstance] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceMonthOfYear] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceRegeneratedType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskSubtype] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletedDateTime] [datetime2](7) NULL,
	[BrightPattern__SPRecordingOrTranscriptURL__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Name__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Completed_Date__c] [date] NULL,
	[External_ID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform_Id__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Person_Account__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Recording_Link__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SPRecordingOrTranscriptURL__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Appointment__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Caller_Id__c] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agent_Link__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Guest_Link__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Opportunity__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Phone__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Activity_Type__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallBackDueDate__c] [date] NULL,
	[Invite__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO