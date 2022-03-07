/* CreateDate: 03/03/2022 13:53:57.360 , ModifyDate: 03/07/2022 12:17:33.947 */
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
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Account_AccountId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Account_Person_Account__c] FOREIGN KEY([Person_Account__c])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Account_Person_Account__c]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Account_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Account_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_AssignedResource_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[AssignedResource] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_AssignedResource_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Campaign_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Campaign_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Case_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Case] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Case_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Commissions_Log__c_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Commissions_Log__c] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Commissions_Log__c_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Contact_WhoId] FOREIGN KEY([WhoId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Contact_WhoId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Contract_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Contract] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Contract_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_ContractLineItem_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ContractLineItem] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_ContractLineItem_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Lead_Lead__c] FOREIGN KEY([Lead__c])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Lead_Lead__c]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Lead_WhoId] FOREIGN KEY([WhoId])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Lead_WhoId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Location_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Location] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Location_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Opportunity_Opportunity__c] FOREIGN KEY([Opportunity__c])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Opportunity_Opportunity__c]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Opportunity_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Opportunity_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Order_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Order] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Order_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_PromoCode__c_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[PromoCode__c] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_PromoCode__c_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Quote_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[Quote] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Quote_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_ServiceAppointment_Service_Appointment__c] FOREIGN KEY([Service_Appointment__c])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_ServiceAppointment_Service_Appointment__c]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_ServiceAppointment_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_ServiceAppointment_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_ServiceContract_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ServiceContract] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_ServiceContract_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_ServiceResource_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ServiceResource] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_ServiceResource_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_Task_RecurrenceActivityId] FOREIGN KEY([RecurrenceActivityId])
REFERENCES [SF].[Task] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_Task_RecurrenceActivityId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_User_CreatedById]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_User_LastModifiedById]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_User_OwnerId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_WorkOrder_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[WorkOrder] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_WorkOrder_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_WorkOrderLineItem_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[WorkOrderLineItem] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_WorkOrderLineItem_WhatId]
GO
ALTER TABLE [SF].[Task]  WITH NOCHECK ADD  CONSTRAINT [fk_Task_ZipCode__c_WhatId] FOREIGN KEY([WhatId])
REFERENCES [SF].[ZipCode__c] ([Id])
GO
ALTER TABLE [SF].[Task] NOCHECK CONSTRAINT [fk_Task_ZipCode__c_WhatId]
GO
