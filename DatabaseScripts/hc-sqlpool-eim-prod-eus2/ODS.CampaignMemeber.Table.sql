/****** Object:  Table [ODS].[CampaignMemeber]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[CampaignMemeber]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](8000) NULL,
	[LeadId] [varchar](8000) NULL,
	[ContactId] [varchar](8000) NULL,
	[Status] [varchar](8000) NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[FirstRespondedDate] [datetime2](7) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[Salutation] [varchar](8000) NULL,
	[Name] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[Title] [varchar](8000) NULL,
	[Street] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[State] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[Fax] [varchar](8000) NULL,
	[MobilePhone] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[DoNotCall] [bit] NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[LeadSource] [varchar](8000) NULL,
	[CompanyOrAccount] [varchar](8000) NULL,
	[Type] [varchar](8000) NULL,
	[LeadOrContactId] [varchar](8000) NULL,
	[LeadOrContactOwnerId] [varchar](8000) NULL,
	[et4ae5__Activity__c] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Test_files/CampaignMember.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
