/* CreateDate: 01/03/2018 16:31:35.290 , ModifyDate: 11/08/2018 11:05:01.587 */
GO
CREATE TABLE [dbo].[onca_county](
	[county_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[county_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_seat] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[elevation] [int] NULL,
	[persons_per_house] [decimal](15, 4) NULL,
	[population] [int] NULL,
	[area] [int] NULL,
	[households] [int] NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_county] PRIMARY KEY CLUSTERED
(
	[county_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
