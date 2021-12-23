/* CreateDate: 01/18/2005 09:34:07.437 , ModifyDate: 10/23/2017 12:35:40.117 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_county]  WITH CHECK ADD  CONSTRAINT [country_county_817] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[onca_county] CHECK CONSTRAINT [country_county_817]
GO
ALTER TABLE [dbo].[onca_county]  WITH CHECK ADD  CONSTRAINT [state_county_818] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[onca_county] CHECK CONSTRAINT [state_county_818]
GO
ALTER TABLE [dbo].[onca_county]  WITH CHECK ADD  CONSTRAINT [time_zone_county_819] FOREIGN KEY([time_zone_code])
REFERENCES [dbo].[onca_time_zone] ([time_zone_code])
GO
ALTER TABLE [dbo].[onca_county] CHECK CONSTRAINT [time_zone_county_819]
GO
