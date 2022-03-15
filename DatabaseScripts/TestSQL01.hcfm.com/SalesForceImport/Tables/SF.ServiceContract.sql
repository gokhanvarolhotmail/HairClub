/* CreateDate: 03/03/2022 13:53:56.883 , ModifyDate: 03/03/2022 22:19:12.907 */
GO
CREATE TABLE [SF].[ServiceContract](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Term] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ActivationDate] [datetime2](7) NULL,
	[ApprovalStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingLatitude] [decimal](25, 15) NULL,
	[BillingLongitude] [decimal](25, 15) NULL,
	[BillingGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingLatitude] [decimal](25, 15) NULL,
	[ShippingLongitude] [decimal](25, 15) NULL,
	[ShippingGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pricebook2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingHandling] [decimal](16, 2) NULL,
	[Tax] [decimal](16, 2) NULL,
	[Subtotal] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TotalPrice] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LineItemCount] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SpecialTerms] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Discount] [decimal](3, 2) NULL,
	[GrandTotal] [decimal](16, 2) NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentServiceContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RootServiceContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceContract] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceContract]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceContract]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
