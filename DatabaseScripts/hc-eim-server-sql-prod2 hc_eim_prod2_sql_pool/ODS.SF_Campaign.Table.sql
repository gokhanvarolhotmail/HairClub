/****** Object:  Table [ODS].[SF_Campaign]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_Campaign]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](8000) NULL,
	[ParentId] [varchar](8000) NULL,
	[Type] [varchar](8000) NULL,
	[RecordTypeId] [varchar](8000) NULL,
	[Status] [varchar](8000) NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[ExpectedRevenue] [numeric](38, 18) NULL,
	[BudgetedCost] [numeric](38, 18) NULL,
	[ActualCost] [numeric](38, 18) NULL,
	[ExpectedResponse] [numeric](38, 18) NULL,
	[NumberSent] [numeric](38, 18) NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](8000) NULL,
	[NumberOfLeads] [int] NULL,
	[NumberOfConvertedLeads] [int] NULL,
	[NumberOfContacts] [int] NULL,
	[NumberOfResponses] [int] NULL,
	[NumberOfOpportunities] [int] NULL,
	[NumberOfWonOpportunities] [int] NULL,
	[AmountAllOpportunities] [numeric](38, 18) NULL,
	[AmountWonOpportunities] [numeric](38, 18) NULL,
	[OwnerId] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[CampaignMemberRecordTypeId] [varchar](8000) NULL,
	[Channel__c] [varchar](8000) NULL,
	[Company__c] [varchar](8000) NULL,
	[External_Id__c] [varchar](8000) NULL,
	[Language__c] [varchar](8000) NULL,
	[SourceCode_L__c] [varchar](8000) NULL,
	[Promo_Code__c] [varchar](8000) NULL,
	[TollFreeNumber__c] [varchar](8000) NULL,
	[Location__c] [varchar](8000) NULL,
	[Media__c] [varchar](8000) NULL,
	[Format__c] [varchar](8000) NULL,
	[Audience__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
