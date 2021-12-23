/* CreateDate: 11/08/2012 13:35:48.677 , ModifyDate: 11/08/2012 13:38:00.307 */
GO
CREATE TABLE [dbo].[oncd_company_address](
	[company_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_3] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_4] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_address] PRIMARY KEY CLUSTERED
(
	[company_address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [address_type_company_addr_510] FOREIGN KEY([address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [address_type_company_addr_510]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [company_company_addr_94] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [company_company_addr_94]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [country_company_addr_513] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [country_company_addr_513]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [county_company_addr_512] FOREIGN KEY([county_code])
REFERENCES [dbo].[onca_county] ([county_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [county_company_addr_512]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [state_company_addr_511] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [state_company_addr_511]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [time_zone_company_addr_514] FOREIGN KEY([time_zone_code])
REFERENCES [dbo].[onca_time_zone] ([time_zone_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [time_zone_company_addr_514]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [user_company_addr_515] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [user_company_addr_515]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [user_company_addr_516] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [user_company_addr_516]
GO
