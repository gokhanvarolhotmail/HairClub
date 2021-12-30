/* CreateDate: 05/05/2020 17:42:44.640 , ModifyDate: 05/05/2020 18:41:02.770 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
