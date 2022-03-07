/* CreateDate: 03/03/2022 13:53:56.740 , ModifyDate: 03/07/2022 12:17:33.337 */
GO
CREATE TABLE [SF].[Quote](
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
	[OpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pricebook2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSyncing] [bit] NULL,
	[ShippingHandling] [decimal](16, 2) NULL,
	[Tax] [decimal](16, 2) NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpirationDate] [date] NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subtotal] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TotalPrice] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LineItemCount] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[QuoteToStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToLatitude] [decimal](25, 15) NULL,
	[QuoteToLongitude] [decimal](25, 15) NULL,
	[QuoteToGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalLatitude] [decimal](25, 15) NULL,
	[AdditionalLongitude] [decimal](25, 15) NULL,
	[AdditionalGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuoteToName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Discount] [decimal](3, 2) NULL,
	[GrandTotal] [decimal](16, 2) NULL,
	[CanCreateQuoteLineItems] [bit] NULL,
 CONSTRAINT [pk_Quote] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Quote]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Quote]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_Account_AccountId]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_Contact_ContactId] FOREIGN KEY([ContactId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_Contact_ContactId]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_Contract_ContractId] FOREIGN KEY([ContractId])
REFERENCES [SF].[Contract] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_Contract_ContractId]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_Opportunity_OpportunityId] FOREIGN KEY([OpportunityId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_Opportunity_OpportunityId]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_User_CreatedById]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_User_LastModifiedById]
GO
ALTER TABLE [SF].[Quote]  WITH NOCHECK ADD  CONSTRAINT [fk_Quote_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Quote] NOCHECK CONSTRAINT [fk_Quote_User_OwnerId]
GO
