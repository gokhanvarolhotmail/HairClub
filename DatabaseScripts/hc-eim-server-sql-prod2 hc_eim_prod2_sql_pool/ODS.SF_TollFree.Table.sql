/****** Object:  Table [ODS].[SF_TollFree]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_TollFree]
(
	[Id] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[ACEDescription__c] [varchar](8000) NULL,
	[ActiveCampaignsDesktop__c] [numeric](38, 18) NULL,
	[ActiveCampaignsMobile__c] [numeric](38, 18) NULL,
	[Company__c] [varchar](8000) NULL,
	[DNIS__c] [numeric](38, 18) NULL,
	[Description__c] [varchar](8000) NULL,
	[LanguageCode__c] [numeric](38, 18) NULL,
	[LocationCode__c] [numeric](38, 18) NULL,
	[Misc_Code__c] [numeric](38, 18) NULL,
	[Notes__c] [varchar](8000) NULL,
	[Number__c] [varchar](8000) NULL,
	[PDNIS__c] [numeric](38, 18) NULL,
	[PromoCode__c] [varchar](8000) NULL,
	[SourceCode__c] [varchar](8000) NULL,
	[TotalActiveCampaigns__c] [numeric](38, 18) NULL,
	[TotalCampaignsDesktop__c] [numeric](38, 18) NULL,
	[TotalCampaignsMobile__c] [numeric](38, 18) NULL,
	[TotalCampaigns__c] [numeric](38, 18) NULL,
	[External_ID__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
