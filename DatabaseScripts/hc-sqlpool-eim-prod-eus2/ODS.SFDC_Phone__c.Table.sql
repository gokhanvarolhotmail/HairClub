/****** Object:  Table [ODS].[SFDC_Phone__c]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SFDC_Phone__c]
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
	[Type__c] [varchar](8000) NULL,
	[DoNotCall__c] [bit] NULL,
	[Status__c] [varchar](8000) NULL,
	[Lead__c] [varchar](8000) NULL,
	[Customer__c] [varchar](8000) NULL,
	[PhoneAbr__c] [varchar](8000) NULL,
	[AreaCodeAndPrefixAbr__c] [varchar](8000) NULL,
	[EBRDNC__c] [bit] NULL,
	[PhoneCountryCode__c] [varchar](8000) NULL,
	[PhoneNumber__c] [varchar](8000) NULL,
	[DoNotText__c] [bit] NULL,
	[PhoneExtension__c] [varchar](8000) NULL,
	[SortOrder__c] [numeric](38, 18) NULL,
	[LastDNCDate__c] [datetime2](7) NULL,
	[ContactPhoneID__c] [varchar](8000) NULL,
	[ValidFlag__c] [bit] NULL,
	[DNCFlag__c] [bit] NULL,
	[Wireless__c] [bit] NULL,
	[DNCPrompt__c] [varchar](8000) NULL,
	[OncCreatedByUserCode__c] [varchar](8000) NULL,
	[AreaCode__c] [numeric](38, 18) NULL,
	[EBRDNCDate__c] [datetime2](7) NULL,
	[EBRDNCEndDate__c] [datetime2](7) NULL,
	[EBRDNCRemainingDays__c] [numeric](38, 18) NULL,
	[OktoCall__c] [bit] NULL,
	[OncLastUpdatedUserCode__c] [varchar](8000) NULL,
	[PhoneIndex__c] [numeric](38, 18) NULL,
	[OncContactID__c] [varchar](8000) NULL,
	[OncCreatedDate__c] [datetime2](7) NULL,
	[OncUpdatedDate__c] [datetime2](7) NULL,
	[PhoneDupe__c] [varchar](8000) NULL,
	[ToBeProcessed__c] [bit] NULL,
	[LastProcessedDate__c] [datetime2](7) NULL,
	[Lead_Do_Not_Call__c] [varchar](8000) NULL,
	[Converted__c] [varchar](8000) NULL,
	[CaseSafeID__c] [varchar](8000) NULL,
	[LeadDoNotText__c] [varchar](8000) NULL,
	[LeadDoNotContact__c] [varchar](8000) NULL,
	[PersonAccount__c] [varchar](8000) NULL,
	[SFDCOriginalLastModDate__c] [datetime2](7) NULL,
	[SFDCOriginalLastModifiedDate__c] [datetime2](7) NULL,
	[SFDCOriginalLeadId__c] [varchar](8000) NULL,
	[DNCFlag2__c] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
