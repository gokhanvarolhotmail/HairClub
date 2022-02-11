/****** Object:  Table [dbo].[T_2065_255c5c44786e4d0b8941a6e740c89894]    Script Date: 2/10/2022 9:07:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2065_255c5c44786e4d0b8941a6e740c89894]
(
	[CustomerGUID] [nvarchar](max) NULL,
	[CustomerIdentifier] [nvarchar](max) NULL,
	[Centerkey] [int] NULL,
	[CenterId] [nvarchar](max) NULL,
	[CountryId] [nvarchar](max) NULL,
	[ContactId] [nvarchar](max) NULL,
	[CustomerFirstName] [nvarchar](max) NULL,
	[CustomerMiddleName] [nvarchar](max) NULL,
	[CustomerLastName] [nvarchar](max) NULL,
	[CustomerAddress1] [nvarchar](max) NULL,
	[CustomerCity] [nvarchar](max) NULL,
	[GeographyKey] [int] NULL,
	[StateId] [nvarchar](max) NULL,
	[PostalCode] [nvarchar](max) NULL,
	[Genderkey] [int] NULL,
	[GenderId] [int] NULL,
	[DateOfBirth] [date] NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[Phone1] [nvarchar](max) NULL,
	[Phone2] [nvarchar](max) NULL,
	[LanguageKey] [int] NULL,
	[LanguageId] [nvarchar](max) NULL,
	[SalesforceContactId] [nvarchar](max) NULL,
	[LeadCreateDate] [date] NULL,
	[BosleySalesforceAccountID] [nvarchar](max) NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[DWH_LoadDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[IsActive] [int] NULL,
	[CustomerCreatedDate] [datetime2](7) NULL,
	[CustomerLastUpdateDate] [datetime2](7) NULL,
	[rf431e1c28ded4ceaa9d5a76d2aa409e9] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
