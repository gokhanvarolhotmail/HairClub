/* CreateDate: 03/03/2022 13:53:56.033 , ModifyDate: 03/07/2022 12:17:33.927 */
GO
CREATE TABLE [SF].[Event](
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
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[Recurrence2PatternText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Event]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Event]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Account_AccountId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Account_Person_Account__c] FOREIGN KEY([Person_Account__c])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Account_Person_Account__c]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Account_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Account_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_AssignedResource_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[AssignedResource] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_AssignedResource_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Campaign_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Campaign_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Case_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Case] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Case_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Commissions_Log__c_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Commissions_Log__c] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Commissions_Log__c_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Contact_WhoId] FOREIGN KEY([WhoId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Contact_WhoId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Contract_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Contract] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Contract_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ContractLineItem_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ContractLineItem] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ContractLineItem_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Event_RecurrenceActivityId] FOREIGN KEY([RecurrenceActivityId])
REFERENCES [SF].[Event] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Event_RecurrenceActivityId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Lead_Lead__c] FOREIGN KEY([Lead__c])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Lead_Lead__c]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Lead_WhoId] FOREIGN KEY([WhoId])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Lead_WhoId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Location_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Location] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Location_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Opportunity_Opportunity__c] FOREIGN KEY([Opportunity__c])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Opportunity_Opportunity__c]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Opportunity_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Opportunity_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Order_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Order] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Order_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_PromoCode__c_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[PromoCode__c] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_PromoCode__c_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_Quote_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Quote] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_Quote_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ServiceAppointment_Service_Appointment__c] FOREIGN KEY([Service_Appointment__c])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ServiceAppointment_Service_Appointment__c]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ServiceAppointment_ServiceAppointmentId] FOREIGN KEY([ServiceAppointmentId])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ServiceAppointment_ServiceAppointmentId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ServiceAppointment_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ServiceAppointment_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ServiceContract_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ServiceContract] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ServiceContract_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ServiceResource_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ServiceResource] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ServiceResource_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_User_CreatedById]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_User_LastModifiedById]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_User_OwnerId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_WorkOrder_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[WorkOrder] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_WorkOrder_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_WorkOrderLineItem_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[WorkOrderLineItem] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_WorkOrderLineItem_WhatId]
GO
ALTER TABLE [SF].[Event]  WITH NOCHECK ADD  CONSTRAINT [fk_Event_ZipCode__c_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ZipCode__c] ([Id])
GO
ALTER TABLE [SF].[Event] NOCHECK CONSTRAINT [fk_Event_ZipCode__c_WhatId]
GO
