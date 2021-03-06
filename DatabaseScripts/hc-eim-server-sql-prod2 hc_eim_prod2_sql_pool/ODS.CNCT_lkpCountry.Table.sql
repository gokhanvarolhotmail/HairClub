/****** Object:  Table [ODS].[CNCT_lkpCountry]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpCountry]
(
	[CountryID] [int] NULL,
	[CountrySortOrder] [int] NULL,
	[CountryDescription] [nvarchar](max) NULL,
	[CountryDescriptionShort] [nvarchar](max) NULL,
	[CurrencyTypeID] [int] NULL,
	[ValidateZipCodeFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[IsStateEnabled] [bit] NULL,
	[IsAddressRequired] [bit] NULL,
	[IsPhoneNumberRequired] [bit] NULL,
	[PhoneNumberMask] [nvarchar](max) NULL,
	[PhoneNumberValidationRegEx] [nvarchar](max) NULL,
	[PhoneNumberDisplayFormat] [nvarchar](max) NULL,
	[PhoneCountryCode] [nvarchar](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
