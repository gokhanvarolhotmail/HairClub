/* CreateDate: 11/08/2012 13:38:00.230 , ModifyDate: 07/11/2017 10:53:44.140 */
GO
CREATE TABLE [dbo].[oncd_contact_address](
	[contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
	[company_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_valid_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_address] PRIMARY KEY CLUSTERED
(
	[contact_address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_address_test1] ON [dbo].[oncd_contact_address]
(
	[primary_flag] ASC,
	[contact_id] ASC
)
INCLUDE([address_line_1],[address_line_2],[city],[state_code],[zip_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_address_test2] ON [dbo].[oncd_contact_address]
(
	[state_code] ASC,
	[primary_flag] ASC,
	[city] ASC,
	[zip_code] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [address_type_contact_addr_566] FOREIGN KEY([address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [address_type_contact_addr_566]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [company_addr_contact_addr_798] FOREIGN KEY([company_address_id])
REFERENCES [dbo].[oncd_company_address] ([company_address_id])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [company_addr_contact_addr_798]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_addr_64] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [contact_contact_addr_64]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [country_contact_addr_567] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [country_contact_addr_567]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [county_contact_addr_568] FOREIGN KEY([county_code])
REFERENCES [dbo].[onca_county] ([county_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [county_contact_addr_568]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [state_contact_addr_572] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [state_contact_addr_572]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [time_zone_contact_addr_573] FOREIGN KEY([time_zone_code])
REFERENCES [dbo].[onca_time_zone] ([time_zone_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [time_zone_contact_addr_573]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [user_contact_addr_570] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [user_contact_addr_570]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [user_contact_addr_571] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [user_contact_addr_571]
GO
