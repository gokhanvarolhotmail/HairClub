/* CreateDate: 03/03/2022 13:53:55.673 , ModifyDate: 03/07/2022 12:17:20.910 */
GO
CREATE TABLE [SF].[Commissions_Log__c](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Service_Appointment__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ACE_Approved__c] [bit] NULL,
	[Comments__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_To_Proposed_Change__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_To__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commissions_Logic_Details__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[My_Commission_Log__c] [bit] NULL,
	[Related_Lead__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Related_Person_Account__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[System_Generated__c] [bit] NULL,
	[Commission_To_Manager__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_To_Company__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Commissions_Log__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Commissions_Log__c]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Commissions_Log__c]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_Account_Related_Person_Account__c] FOREIGN KEY([Related_Person_Account__c])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_Account_Related_Person_Account__c]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_Lead_Related_Lead__c] FOREIGN KEY([Related_Lead__c])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_Lead_Related_Lead__c]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_ServiceAppointment_Service_Appointment__c] FOREIGN KEY([Service_Appointment__c])
REFERENCES [SF].[ServiceAppointment] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_ServiceAppointment_Service_Appointment__c]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_User_Commission_To__c] FOREIGN KEY([Commission_To__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_User_Commission_To__c]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_User_Commission_To_Proposed_Change__c] FOREIGN KEY([Commission_To_Proposed_Change__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_User_Commission_To_Proposed_Change__c]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_User_CreatedById]
GO
ALTER TABLE [SF].[Commissions_Log__c]  WITH NOCHECK ADD  CONSTRAINT [fk_Commissions_Log__c_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Commissions_Log__c] NOCHECK CONSTRAINT [fk_Commissions_Log__c_User_LastModifiedById]
GO
