/* CreateDate: 08/29/2008 09:52:39.633 , ModifyDate: 01/31/2022 08:32:31.760 */
GO
CREATE TABLE [dbo].[cfgPostalCode](
	[zip_code] [int] NOT NULL,
	[city] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_code] [int] NULL,
	[facility_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateID] [int] NULL,
	[CountryID] [int] NULL,
 CONSTRAINT [PK_lkpPostalCode] PRIMARY KEY CLUSTERED
(
	[zip_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgPostalCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgPostalCode_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[cfgPostalCode] CHECK CONSTRAINT [FK_cfgPostalCode_lkpCountry]
GO
ALTER TABLE [dbo].[cfgPostalCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgPostalCode_lkpState] FOREIGN KEY([StateID])
REFERENCES [dbo].[lkpState] ([StateID])
GO
ALTER TABLE [dbo].[cfgPostalCode] CHECK CONSTRAINT [FK_cfgPostalCode_lkpState]
GO
