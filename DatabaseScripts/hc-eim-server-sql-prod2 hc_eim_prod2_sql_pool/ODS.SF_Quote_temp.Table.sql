/****** Object:  Table [ODS].[SF_Quote_temp]    Script Date: 3/9/2022 8:40:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[SF_Quote_temp]
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
	[OpportunityId] [varchar](8000) NULL,
	[Pricebook2Id] [varchar](8000) NULL,
	[ContactId] [varchar](8000) NULL,
	[QuoteNumber] [varchar](8000) NULL,
	[IsSyncing] [bit] NULL,
	[ShippingHandling] [numeric](38, 18) NULL,
	[Tax] [numeric](38, 18) NULL,
	[Status] [varchar](8000) NULL,
	[ExpirationDate] [datetime2](7) NULL,
	[Description] [varchar](8000) NULL,
	[Subtotal] [numeric](38, 18) NULL,
	[TotalPrice] [numeric](38, 18) NULL,
	[LineItemCount] [int] NULL,
	[BillingStreet] [varchar](8000) NULL,
	[BillingCity] [varchar](8000) NULL,
	[BillingState] [varchar](8000) NULL,
	[BillingPostalCode] [varchar](8000) NULL,
	[BillingCountry] [varchar](8000) NULL,
	[BillingStateCode] [varchar](8000) NULL,
	[BillingCountryCode] [varchar](8000) NULL,
	[BillingLatitude] [numeric](38, 18) NULL,
	[BillingLongitude] [numeric](38, 18) NULL,
	[BillingGeocodeAccuracy] [varchar](8000) NULL,
	[ShippingStreet] [varchar](8000) NULL,
	[ShippingCity] [varchar](8000) NULL,
	[ShippingState] [varchar](8000) NULL,
	[ShippingPostalCode] [varchar](8000) NULL,
	[ShippingCountry] [varchar](8000) NULL,
	[ShippingStateCode] [varchar](8000) NULL,
	[ShippingCountryCode] [varchar](8000) NULL,
	[ShippingLatitude] [numeric](38, 18) NULL,
	[ShippingLongitude] [numeric](38, 18) NULL,
	[ShippingGeocodeAccuracy] [varchar](8000) NULL,
	[QuoteToStreet] [varchar](8000) NULL,
	[QuoteToCity] [varchar](8000) NULL,
	[QuoteToState] [varchar](8000) NULL,
	[QuoteToPostalCode] [varchar](8000) NULL,
	[QuoteToCountry] [varchar](8000) NULL,
	[QuoteToStateCode] [varchar](8000) NULL,
	[QuoteToCountryCode] [varchar](8000) NULL,
	[QuoteToLatitude] [numeric](38, 18) NULL,
	[QuoteToLongitude] [numeric](38, 18) NULL,
	[QuoteToGeocodeAccuracy] [varchar](8000) NULL,
	[AdditionalStreet] [varchar](8000) NULL,
	[AdditionalCity] [varchar](8000) NULL,
	[AdditionalState] [varchar](8000) NULL,
	[AdditionalPostalCode] [varchar](8000) NULL,
	[AdditionalCountry] [varchar](8000) NULL,
	[AdditionalStateCode] [varchar](8000) NULL,
	[AdditionalCountryCode] [varchar](8000) NULL,
	[AdditionalLatitude] [numeric](38, 18) NULL,
	[AdditionalLongitude] [numeric](38, 18) NULL,
	[AdditionalGeocodeAccuracy] [varchar](8000) NULL,
	[BillingName] [varchar](8000) NULL,
	[ShippingName] [varchar](8000) NULL,
	[QuoteToName] [varchar](8000) NULL,
	[AdditionalName] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[Fax] [varchar](8000) NULL,
	[ContractId] [varchar](8000) NULL,
	[AccountId] [varchar](8000) NULL,
	[Discount] [numeric](38, 18) NULL,
	[GrandTotal] [numeric](38, 18) NULL,
	[CanCreateQuoteLineItems] [bit] NULL
)
WITH (DATA_SOURCE = [hc-eim-file-system-bi-dev_steimdatalakedev_dfs_core_windows_net],LOCATION = N'Salesforce/Quote/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
