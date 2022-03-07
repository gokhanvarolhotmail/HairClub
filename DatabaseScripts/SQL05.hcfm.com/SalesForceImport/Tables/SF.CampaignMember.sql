/* CreateDate: 03/03/2022 13:53:55.480 , ModifyDate: 03/07/2022 12:17:31.630 */
GO
CREATE TABLE [SF].[CampaignMember](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[FirstRespondedDate] [date] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCall] [bit] NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[LeadSource] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyOrAccount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOrContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOrContactOwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Opportunity__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Device_Type__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Do_Not_Call_from_Lead_Contact__c] [bit] NULL,
	[Last_Activity_Date__c] [date] NULL,
	[Lead_Status__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Time_Zone__c] [date] NULL,
 CONSTRAINT [pk_CampaignMember] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[CampaignMember]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[CampaignMember]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Account_LeadOrContactId] FOREIGN KEY([LeadOrContactId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Account_LeadOrContactId]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Campaign_CampaignId] FOREIGN KEY([CampaignId])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Campaign_CampaignId]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Contact_ContactId] FOREIGN KEY([ContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Contact_ContactId]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Contact_LeadOrContactId] FOREIGN KEY([LeadOrContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Contact_LeadOrContactId]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Lead_LeadId] FOREIGN KEY([LeadId])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Lead_LeadId]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Lead_LeadOrContactId] FOREIGN KEY([LeadOrContactId])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Lead_LeadOrContactId]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_Opportunity_Opportunity__c] FOREIGN KEY([Opportunity__c])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_Opportunity_Opportunity__c]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_User_CreatedById]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_User_LastModifiedById]
GO
ALTER TABLE [SF].[CampaignMember]  WITH NOCHECK ADD  CONSTRAINT [fk_CampaignMember_User_LeadOrContactOwnerId] FOREIGN KEY([LeadOrContactOwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[CampaignMember] NOCHECK CONSTRAINT [fk_CampaignMember_User_LeadOrContactOwnerId]
GO
