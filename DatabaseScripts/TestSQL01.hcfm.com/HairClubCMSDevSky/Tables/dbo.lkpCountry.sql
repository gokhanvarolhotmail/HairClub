/* CreateDate: 11/14/2008 08:34:54.050 , ModifyDate: 12/07/2021 16:20:16.053 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpCountry] ADD  CONSTRAINT [DF_lkpCountry_ValidateZipCodeFlag]  DEFAULT ((0)) FOR [ValidateZipCodeFlag]
GO
ALTER TABLE [dbo].[lkpCountry] ADD  CONSTRAINT [DF_lkpCountry_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpCountry] ADD  DEFAULT ((0)) FOR [IsStateEnabled]
GO
ALTER TABLE [dbo].[lkpCountry] ADD  DEFAULT ((0)) FOR [IsAddressRequired]
GO
ALTER TABLE [dbo].[lkpCountry] ADD  DEFAULT ((0)) FOR [IsPhoneNumberRequired]
GO
ALTER TABLE [dbo].[lkpCountry]  WITH CHECK ADD  CONSTRAINT [FK_lkpCountry_lkpCurrencyType] FOREIGN KEY([CurrencyTypeID])
REFERENCES [dbo].[lkpCurrencyType] ([CurrencyTypeID])
GO
ALTER TABLE [dbo].[lkpCountry] CHECK CONSTRAINT [FK_lkpCountry_lkpCurrencyType]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Determines when on client save if the state and city should be looked up or validated by the zip code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'lkpCountry', @level2type=N'COLUMN',@level2name=N'ValidateZipCodeFlag'
GO
