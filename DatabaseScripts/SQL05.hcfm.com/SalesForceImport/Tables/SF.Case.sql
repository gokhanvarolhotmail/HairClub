/* CreateDate: 03/03/2022 13:53:55.607 , ModifyDate: 03/07/2022 12:17:31.690 */
GO
CREATE TABLE [SF].[Case](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssetId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProductId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntitlementId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SuppliedName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SuppliedEmail] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SuppliedPhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SuppliedCompany] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Reason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Origin] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Priority] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosed] [bit] NULL,
	[ClosedDate] [datetime2](7) NULL,
	[IsEscalated] [bit] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosedOnCreate] [bit] NULL,
	[SlaStartDate] [datetime2](7) NULL,
	[SlaExitDate] [datetime2](7) NULL,
	[IsStopped] [bit] NULL,
	[StopStartDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[ContactPhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMobile] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactEmail] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ServiceContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MilestoneStatus] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accommodation__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssignedTo__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallType__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseAltPhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseName__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CasePhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Case_Source_Chat__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Category__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterEmployee__c] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Content__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Courteous__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateofAppointment__c] [date] NULL,
	[DateofIncident__c] [date] NULL,
	[Didyousignup__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Estimated_Completion_Date__c] [date] NULL,
	[FeedbackType__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadEmail__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadId__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadPhone__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OptionOffered__c] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Points__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PricePlan__c] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Resolution__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SignIn__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeofIncident__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title__c] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Wereyouontime__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Case] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Case]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Case]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Account_AccountId]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Account_Center__c] FOREIGN KEY([Center__c])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Account_Center__c]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Campaign_Campaign__c] FOREIGN KEY([Campaign__c])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Campaign_Campaign__c]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Case_MasterRecordId] FOREIGN KEY([MasterRecordId])
REFERENCES [SF].[Case] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Case_MasterRecordId]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Case_ParentId] FOREIGN KEY([ParentId])
REFERENCES [SF].[Case] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Case_ParentId]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Contact_ContactId] FOREIGN KEY([ContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Contact_ContactId]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_EmailMessage_SourceId] FOREIGN KEY([SourceId])
REFERENCES [SF].[EmailMessage] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_EmailMessage_SourceId]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_Lead_LeadId__c] FOREIGN KEY([LeadId__c])
REFERENCES [SF].[Lead] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_Lead_LeadId__c]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_ServiceContract_ServiceContractId] FOREIGN KEY([ServiceContractId])
REFERENCES [SF].[ServiceContract] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_ServiceContract_ServiceContractId]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_User_CreatedById]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_User_LastModifiedById]
GO
ALTER TABLE [SF].[Case]  WITH NOCHECK ADD  CONSTRAINT [fk_Case_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Case] NOCHECK CONSTRAINT [fk_Case_User_OwnerId]
GO
