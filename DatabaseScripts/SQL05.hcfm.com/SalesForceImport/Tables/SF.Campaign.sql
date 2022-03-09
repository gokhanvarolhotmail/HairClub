/* CreateDate: 03/03/2022 13:53:55.417 , ModifyDate: 03/08/2022 08:42:47.783 */
GO
CREATE TABLE [SF].[Campaign](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpectedRevenue] [decimal](18, 0) NULL,
	[BudgetedCost] [decimal](18, 0) NULL,
	[ActualCost] [decimal](18, 0) NULL,
	[ExpectedResponse] [decimal](8, 2) NULL,
	[NumberSent] [decimal](18, 0) NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfLeads] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfConvertedLeads] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfContacts] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfResponses] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfOpportunities] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfWonOpportunities] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountAllOpportunities] [decimal](18, 0) NULL,
	[AmountWonOpportunities] [decimal](18, 0) NULL,
	[HierarchyNumberOfLeads] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HierarchyNumberOfConvertedLeads] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HierarchyNumberOfContacts] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HierarchyNumberOfResponses] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HierarchyNumberOfOpportunities] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HierarchyNumberOfWonOpportunities] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HierarchyAmountAllOpportunities] [decimal](18, 0) NULL,
	[HierarchyAmountWonOpportunities] [decimal](18, 0) NULL,
	[HierarchyNumberSent] [decimal](18, 0) NULL,
	[HierarchyExpectedRevenue] [decimal](18, 0) NULL,
	[HierarchyBudgetedCost] [decimal](18, 0) NULL,
	[HierarchyActualCost] [decimal](18, 0) NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[CampaignMemberRecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Channel__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Company__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Priority__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Promo_Code__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode_L__c] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreeNumber__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Audience__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DPNCode__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWCCode__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWFCode__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MPNCode__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MWCCode__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MWFCode__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gleam_Id__c] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DialerMiscCode__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Origin__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dialer_Misc_Code__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Toll_Free_Desktop__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Toll_Free_Mobile__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DB_Campaign_Tactic__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignSource__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Campaign] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Campaign]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Campaign]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
