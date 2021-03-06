/****** Object:  Table [ODS].[SF_Order_temp]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[SF_Order_temp]
(
	[Id] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[ContractId] [varchar](8000) NULL,
	[AccountId] [varchar](8000) NULL,
	[Pricebook2Id] [varchar](8000) NULL,
	[OriginalOrderId] [varchar](8000) NULL,
	[EffectiveDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[IsReductionOrder] [bit] NULL,
	[Status] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[CustomerAuthorizedById] [varchar](8000) NULL,
	[CompanyAuthorizedById] [varchar](8000) NULL,
	[Type] [varchar](8000) NULL,
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
	[ActivatedDate] [datetime2](7) NULL,
	[ActivatedById] [varchar](8000) NULL,
	[StatusCode] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[OrderNumber] [varchar](8000) NULL,
	[TotalAmount] [numeric](38, 18) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL
)
WITH (DATA_SOURCE = [hc-eim-file-system-bi-dev_steimdatalakedev_dfs_core_windows_net],LOCATION = N'Salesforce/Order/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
