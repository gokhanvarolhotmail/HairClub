/****** Object:  Table [dbo].[DimAccount]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAccount]
(
	[AccountKey] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [nvarchar](50) NULL,
	[AccountFirstName] [nvarchar](250) NULL,
	[AccountLastName] [nvarchar](250) NULL,
	[AccountFullName] [nvarchar](250) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [nvarchar](250) NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedTimeKey] [int] NULL,
	[CreatedUserKey] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](250) NULL,
	[LastModifiedUserKey] [int] NULL,
	[BillingStreet] [nvarchar](150) NULL,
	[BillingCity] [nvarchar](150) NULL,
	[BillingState] [nvarchar](510) NULL,
	[BillingPostalCode] [nvarchar](150) NULL,
	[BillingCountry] [nvarchar](150) NULL,
	[BillingStateCode] [nvarchar](150) NULL,
	[BillingCountryCode] [nvarchar](150) NULL,
	[BillingGeographyKey] [int] NULL,
	[EthnicityKey] [int] NULL,
	[AccountEtnicity] [nvarchar](150) NULL,
	[GenderKey] [int] NULL,
	[AccountGender] [nvarchar](150) NULL,
	[AccountPhone] [nvarchar](150) NULL,
	[AccountEmail] [nvarchar](250) NULL,
	[PersonContactId] [nvarchar](50) NULL,
	[IsPersonAccount] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[NorwoodScale] [nvarchar](150) NULL,
	[LudwigScale] [nvarchar](150) NULL,
	[HairLossScaleKey] [int] NULL,
	[HairLossInFamily] [nvarchar](250) NULL,
	[HairLossProductUsed] [nvarchar](250) NULL,
	[HairLossSpot] [nvarchar](250) NULL,
	[DiscStyle] [nvarchar](250) NULL,
	[AccountStatusKey] [int] NULL,
	[AccountStatus] [nvarchar](250) NULL,
	[CompanyKey] [int] NULL,
	[AccountCompany] [nvarchar](250) NULL,
	[SourceKey] [int] NULL,
	[AccountSource] [nvarchar](250) NULL,
	[AccountExternalId] [nvarchar](250) NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatus] [nvarchar](250) NULL,
	[SourceSystem] [nvarchar](250) NULL,
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
