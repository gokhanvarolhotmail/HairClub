/* CreateDate: 01/18/2005 09:34:08.030 , ModifyDate: 07/21/2014 01:22:48.290 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_user_address](
	[user_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_3] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_4] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_user_address] PRIMARY KEY CLUSTERED
(
	[user_address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_address]  WITH CHECK ADD  CONSTRAINT [address_type_user_address_860] FOREIGN KEY([address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[onca_user_address] CHECK CONSTRAINT [address_type_user_address_860]
GO
ALTER TABLE [dbo].[onca_user_address]  WITH CHECK ADD  CONSTRAINT [country_user_address_861] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[onca_user_address] CHECK CONSTRAINT [country_user_address_861]
GO
ALTER TABLE [dbo].[onca_user_address]  WITH CHECK ADD  CONSTRAINT [county_user_address_862] FOREIGN KEY([county_code])
REFERENCES [dbo].[onca_county] ([county_code])
GO
ALTER TABLE [dbo].[onca_user_address] CHECK CONSTRAINT [county_user_address_862]
GO
ALTER TABLE [dbo].[onca_user_address]  WITH CHECK ADD  CONSTRAINT [state_user_address_863] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[onca_user_address] CHECK CONSTRAINT [state_user_address_863]
GO
ALTER TABLE [dbo].[onca_user_address]  WITH CHECK ADD  CONSTRAINT [time_zone_user_address_864] FOREIGN KEY([time_zone_code])
REFERENCES [dbo].[onca_time_zone] ([time_zone_code])
GO
ALTER TABLE [dbo].[onca_user_address] CHECK CONSTRAINT [time_zone_user_address_864]
GO
ALTER TABLE [dbo].[onca_user_address]  WITH CHECK ADD  CONSTRAINT [user_user_address_137] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_address] CHECK CONSTRAINT [user_user_address_137]
GO
