/* CreateDate: 01/18/2005 09:34:07.953 , ModifyDate: 10/23/2017 12:35:40.143 */
GO
CREATE TABLE [dbo].[onca_time_zone](
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[greenwich_offset] [float] NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_time_zone] PRIMARY KEY CLUSTERED
(
	[time_zone_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_time_zone]  WITH NOCHECK ADD  CONSTRAINT [country_time_zone_858] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[onca_time_zone] CHECK CONSTRAINT [country_time_zone_858]
GO
