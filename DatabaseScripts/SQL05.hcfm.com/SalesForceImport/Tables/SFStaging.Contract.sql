/* CreateDate: 03/03/2022 13:54:34.007 , ModifyDate: 03/08/2022 08:43:00.023 */
GO
CREATE TABLE [SFStaging].[Contract](
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
	[SpecialTerms] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivatedDate] [datetime2](7) NULL,
	[StatusCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
