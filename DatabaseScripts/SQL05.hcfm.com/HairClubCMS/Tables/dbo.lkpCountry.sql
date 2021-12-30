/* CreateDate: 05/05/2020 17:42:38.840 , ModifyDate: 05/05/2020 17:42:58.487 */
GO
CREATE TABLE [dbo].[lkpCountry](
	[CountryID] [int] NOT NULL,
	[CountrySortOrder] [int] NOT NULL,
	[CountryDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CurrencyTypeID] [int] NULL,
	[ValidateZipCodeFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsStateEnabled] [bit] NOT NULL,
	[IsAddressRequired] [bit] NOT NULL,
	[IsPhoneNumberRequired] [bit] NOT NULL,
	[PhoneNumberMask] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberValidationRegEx] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberDisplayFormat] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneCountryCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpCountry] PRIMARY KEY CLUSTERED
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
