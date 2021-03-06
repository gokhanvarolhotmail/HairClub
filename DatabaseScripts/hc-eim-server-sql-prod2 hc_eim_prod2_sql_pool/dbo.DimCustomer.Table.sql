/****** Object:  Table [dbo].[DimCustomer]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCustomer]
(
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerGUID] [nvarchar](100) NULL,
	[CustomerIdentifier] [nvarchar](100) NULL,
	[Centerkey] [int] NULL,
	[CenterId] [nvarchar](100) NULL,
	[CountryId] [nvarchar](100) NULL,
	[ContactId] [nvarchar](200) NULL,
	[CustomerFirstName] [nvarchar](200) NULL,
	[CustomerMiddleName] [nvarchar](200) NULL,
	[CustomerLastName] [nvarchar](200) NULL,
	[CustomerAddress1] [nvarchar](200) NULL,
	[CustomerCity] [nvarchar](100) NULL,
	[GeographyKey] [int] NULL,
	[StateId] [nvarchar](100) NULL,
	[PostalCode] [nvarchar](100) NULL,
	[Genderkey] [int] NULL,
	[GenderId] [int] NULL,
	[DateOfBirth] [date] NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[EmailAddress] [nvarchar](100) NULL,
	[Phone1] [nvarchar](100) NULL,
	[Phone2] [nvarchar](100) NULL,
	[LanguageKey] [int] NULL,
	[LanguageId] [nvarchar](100) NULL,
	[SalesforceContactId] [nvarchar](100) NULL,
	[LeadCreateDate] [date] NULL,
	[BosleySalesforceAccountID] [nvarchar](100) NULL,
	[SourceSystem] [nvarchar](100) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[CustomerCreatedDate] [datetime] NULL,
	[CustomerLastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CustomerKey] ASC
	)
)
GO
