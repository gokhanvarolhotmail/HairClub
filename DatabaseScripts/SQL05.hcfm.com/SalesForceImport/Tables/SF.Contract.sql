/* CreateDate: 03/03/2022 13:53:55.817 , ModifyDate: 03/07/2022 12:17:32.243 */
GO
CREATE TABLE [SF].[Contract](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Pricebook2Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerExpirationNotice] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
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
	[ContractTerm] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanySignedId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanySignedDate] [date] NULL,
	[CustomerSignedId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerSignedTitle] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerSignedDate] [date] NULL,
	[SpecialTerms] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivatedDate] [datetime2](7) NULL,
	[StatusCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[ContractNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastApprovedDate] [datetime2](7) NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
 CONSTRAINT [pk_Contract] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Contract]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Contract]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_Account_AccountId] FOREIGN KEY([AccountId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_Account_AccountId]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_Contact_CustomerSignedId] FOREIGN KEY([CustomerSignedId])
REFERENCES [SF].[Contact] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_Contact_CustomerSignedId]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_User_ActivatedById] FOREIGN KEY([ActivatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_User_ActivatedById]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_User_CompanySignedId] FOREIGN KEY([CompanySignedId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_User_CompanySignedId]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_User_CreatedById]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_User_LastModifiedById]
GO
ALTER TABLE [SF].[Contract]  WITH NOCHECK ADD  CONSTRAINT [fk_Contract_User_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[Contract] NOCHECK CONSTRAINT [fk_Contract_User_OwnerId]
GO
