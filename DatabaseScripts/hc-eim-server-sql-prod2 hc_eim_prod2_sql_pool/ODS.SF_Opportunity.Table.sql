/****** Object:  Table [ODS].[SF_Opportunity]    Script Date: 3/9/2022 8:40:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_Opportunity]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[AccountId] [varchar](8000) NULL,
	[RecordTypeId] [varchar](8000) NULL,
	[IsPrivate] [bit] NULL,
	[Name] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[StageName] [varchar](8000) NULL,
	[Amount] [numeric](38, 18) NULL,
	[Probability] [numeric](38, 18) NULL,
	[ExpectedRevenue] [numeric](38, 18) NULL,
	[TotalOpportunityQuantity] [numeric](38, 18) NULL,
	[CloseDate] [datetime2](7) NULL,
	[Type] [varchar](8000) NULL,
	[NextStep] [varchar](8000) NULL,
	[LeadSource] [varchar](8000) NULL,
	[IsClosed] [bit] NULL,
	[IsWon] [bit] NULL,
	[ForecastCategory] [varchar](8000) NULL,
	[ForecastCategoryName] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[CampaignId] [varchar](8000) NULL,
	[HasOpportunityLineItem] [bit] NULL,
	[Pricebook2Id] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[FiscalQuarter] [int] NULL,
	[FiscalYear] [int] NULL,
	[Fiscal] [varchar](8000) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[SyncedQuoteId] [varchar](8000) NULL,
	[ContractId] [varchar](8000) NULL,
	[HasOpenActivity] [bit] NULL,
	[HasOverdueTask] [bit] NULL,
	[Budget_Confirmed__c] [bit] NULL,
	[Discovery_Completed__c] [bit] NULL,
	[ROI_Analysis_Completed__c] [bit] NULL,
	[Loss_Reason__c] [varchar](8000) NULL,
	[Appointment_Source__c] [varchar](8000) NULL,
	[Hair_Loss_Experience__c] [varchar](8000) NULL,
	[Hair_Loss_Family__c] [varchar](8000) NULL,
	[Hair_Loss_Or_Volume__c] [varchar](8000) NULL,
	[Hair_Loss_Product_Other__c] [varchar](8000) NULL,
	[Hair_Loss_Product_Used__c] [varchar](8000) NULL,
	[Hair_Loss_Spot__c] [varchar](8000) NULL,
	[IP_Address__c] [varchar](8000) NULL,
	[Ludwig_Scale__c] [varchar](8000) NULL,
	[Norwood_Scale__c] [varchar](8000) NULL,
	[Referral_Code_Expiration_Date__c] [datetime2](7) NULL,
	[Referral_Code__c] [varchar](8000) NULL,
	[Solution_Offered__c] [varchar](8000) NULL,
	[Source_Code__c] [varchar](8000) NULL,
	[Service_Territory__c] [varchar](8000) NULL,
	[GCLID__c] [varchar](8000) NULL,
	[Promo_Code__c] [varchar](8000) NULL,
	[Ammount__c] [numeric](38, 18) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
