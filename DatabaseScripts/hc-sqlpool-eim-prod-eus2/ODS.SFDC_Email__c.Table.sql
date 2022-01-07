/****** Object:  Table [ODS].[SFDC_Email__c]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SFDC_Email__c]
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
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Primary__c] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[Status__c] [varchar](8000) NULL,
	[Lead__c] [varchar](8000) NULL,
	[OncContactEmailID__c] [varchar](8000) NULL,
	[Customer__c] [varchar](8000) NULL,
	[OncCreatedDate__c] [datetime2](7) NULL,
	[OncUpdatedDate__c] [datetime2](7) NULL,
	[OncCreatedByUserCode__c] [varchar](8000) NULL,
	[OncLastUpdatedUserCode__c] [varchar](8000) NULL,
	[OncContactID__c] [varchar](8000) NULL,
	[ToBeProcessed__c] [bit] NULL,
	[LastProcessedDate__c] [datetime2](7) NULL,
	[Converted__c] [varchar](8000) NULL,
	[SFDCOriginalLastModDate__c] [datetime2](7) NULL,
	[SFDCOriginalLastModifiedDate__c] [datetime2](7) NULL,
	[SFDCOriginalLeadId__c] [varchar](8000) NULL,
	[Account__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
