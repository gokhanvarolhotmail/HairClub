/* CreateDate: 04/06/2021 13:44:47.960 , ModifyDate: 04/06/2021 13:44:47.960 */
GO
CREATE TABLE [dbo].[Event](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhatId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoCount] [int] NULL,
	[WhatCount] [int] NULL,
	[Subject] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAllDayEvent] [bit] NULL,
	[ActivityDateTime] [datetime] NULL,
	[ActivityDate] [date] NULL,
	[DurationInMinutes] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[Description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPrivate] [bit] NULL,
	[ShowAs] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[IsChild] [bit] NULL,
	[IsGroupEvent] [bit] NULL,
	[GroupEventType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime] NULL,
	[IsArchived] [bit] NULL,
	[RecurrenceActivityId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRecurrence] [bit] NULL,
	[RecurrenceStartDateTime] [datetime] NULL,
	[RecurrenceEndDateOnly] [date] NULL,
	[RecurrenceTimeZoneSidKey] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceInterval] [int] NULL,
	[RecurrenceDayOfWeekMask] [int] NULL,
	[RecurrenceDayOfMonth] [int] NULL,
	[RecurrenceInstance] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecurrenceMonthOfYear] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReminderDateTime] [datetime] NULL,
	[IsReminderSet] [bit] NULL,
	[EventSubtype] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrightPattern__SPRecordingOrTranscriptURL__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SPRecordingOrTranscriptURL__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Recording_Link__c] [nvarchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
