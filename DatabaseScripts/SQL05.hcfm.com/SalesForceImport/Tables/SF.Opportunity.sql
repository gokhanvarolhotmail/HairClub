/* CreateDate: 03/03/2022 13:53:56.240 , ModifyDate: 03/07/2022 12:17:33.233 */
GO
CREATE TABLE [SF].[Opportunity](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPrivate] [bit] NULL,
	[Name] [varchar](120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StageName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [decimal](16, 2) NULL,
	[Probability] [decimal](3, 0) NULL,
	[ExpectedRevenue] [decimal](16, 2) NULL,
	[TotalOpportunityQuantity] [decimal](16, 2) NULL,
	[CloseDate] [date] NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NextStep] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSource] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosed] [bit] NULL,
	[IsWon] [bit] NULL,
	[ForecastCategory] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ForecastCategoryName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasOpportunityLineItem] [bit] NULL,
	[Pricebook2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Territory2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsExcludedFromTerritory2Filter] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[PushCount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastStageChangeDate] [datetime2](7) NULL,
	[FiscalQuarter] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FiscalYear] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fiscal] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[SyncedQuoteId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasOpenActivity] [bit] NULL,
	[HasOverdueTask] [bit] NULL,
	[IqScore] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastAmountChangedHistoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastCloseDateChangedHistoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Budget_Confirmed__c] [bit] NULL,
	[Discovery_Completed__c] [bit] NULL,
	[ROI_Analysis_Completed__c] [bit] NULL,
	[Appointment_Source__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Loss_Reason__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Cancellation_Reason__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Experience__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Family__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Or_Volume__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Product_Other__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Product_Used__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Spot__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IP_Address__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ludwig_Scale__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Norwood_Scale__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referral_Code_Expiration_Date__c] [date] NULL,
	[Referral_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Competitor__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Source_Code__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Submitted_for_Approval__c] [bit] NULL,
	[Ammount__c] [decimal](16, 2) NULL,
	[GCLID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Promo_Code__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Approver__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goals_Expectations__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_many_times_a_week_do_you_think__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_much_time_a_week_do_you_spend__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mobile__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Opportunity_Owner__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Other_Reason__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Owner__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_are_your_main_concerns_today__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_else_would_be_helpful_for_your__c] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_methods_have_you_used_or_currently__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefersionLogId__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_Paid__c] [bit] NULL,
	[Owner_Division__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Number__c] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_Override__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Opportunity] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Opportunity]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Opportunity]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_Account_AccountId]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_Campaign_CampaignId] FOREIGN KEY([CampaignId])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_Campaign_CampaignId]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_Contact_ContactId] FOREIGN KEY([ContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_Contact_ContactId]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_Contract_ContractId] FOREIGN KEY([ContractId])
REFERENCES [SF].[Contract] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_Contract_ContractId]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_PromoCode__c_Promo_Code__c] FOREIGN KEY([Promo_Code__c])
REFERENCES [SF].[PromoCode__c] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_PromoCode__c_Promo_Code__c]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_Quote_SyncedQuoteId] FOREIGN KEY([SyncedQuoteId])
REFERENCES [SF].[Quote] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_Quote_SyncedQuoteId]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_ServiceTerritory_Service_Territory__c] FOREIGN KEY([Service_Territory__c])
REFERENCES [SF].[ServiceTerritory] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_ServiceTerritory_Service_Territory__c]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_User_Approver__c] FOREIGN KEY([Approver__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_User_Approver__c]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_User_Commission_Override__c] FOREIGN KEY([Commission_Override__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_User_Commission_Override__c]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_User_CreatedById]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_User_LastModifiedById]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_User_Owner__c] FOREIGN KEY([Owner__c])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_User_Owner__c]
GO
ALTER TABLE [SF].[Opportunity]  WITH NOCHECK ADD  CONSTRAINT [fk_Opportunity_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Opportunity] NOCHECK CONSTRAINT [fk_Opportunity_User_OwnerId]
GO
