/****** Object:  Table [dbo].[DimAccount]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAccount]
(
	[AccountKey] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [varchar](50) NULL,
	[AccountFirstName] [varchar](250) NULL,
	[AccountLastName] [varchar](250) NULL,
	[AccountFullName] [varchar](250) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [varchar](50) NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedTimeKey] [int] NULL,
	[CreatedUserKey] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [varchar](50) NULL,
	[LastModifiedUserKey] [int] NULL,
	[BillingStreet] [varchar](150) NULL,
	[BillingCity] [varchar](150) NULL,
	[BillingState] [varchar](510) NULL,
	[BillingPostalCode] [varchar](150) NULL,
	[BillingCountry] [varchar](150) NULL,
	[BillingStateCode] [varchar](150) NULL,
	[BillingCountryCode] [varchar](150) NULL,
	[BillingGeographyKey] [int] NULL,
	[EthnicityKey] [int] NULL,
	[AccountEtnicity] [varchar](150) NULL,
	[GenderKey] [int] NULL,
	[AccountGender] [varchar](150) NULL,
	[AccountPhone] [varchar](150) NULL,
	[AccountEmail] [varchar](250) NULL,
	[PersonContactId] [varchar](50) NULL,
	[IsPersonAccount] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[NorwoodScale] [varchar](150) NULL,
	[LudwigScale] [varchar](150) NULL,
	[HairLossScaleKey] [int] NULL,
	[HairLossInFamily] [bit] NULL,
	[HairLossProductUsed] [varchar](250) NULL,
	[HairLossSpot] [varchar](250) NULL,
	[DiscStyle] [varchar](250) NULL,
	[AccountStatusKey] [int] NULL,
	[AccountStatus] [varchar](250) NULL,
	[CompanyKey] [int] NULL,
	[AccountCompany] [varchar](250) NULL,
	[SourceKey] [int] NULL,
	[AccountSource] [varchar](250) NULL,
	[AccountExternalId] [varchar](250) NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatus] [varchar](250) NULL,
	[SourceSystem] [varchar](250) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[AccountKey] ASC
	)
)
GO
