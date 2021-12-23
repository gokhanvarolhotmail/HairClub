/* CreateDate: 01/25/2010 11:09:09.710 , ModifyDate: 06/21/2012 10:01:08.733 */
GO
CREATE TABLE [dbo].[onca_campaign_product](
	[campaign_product_id] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[version_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[serial_number] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[installation_date] [datetime] NULL,
	[purchase_date] [datetime] NULL,
	[contract_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_campaign_product] PRIMARY KEY CLUSTERED
(
	[campaign_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_product_i2] ON [dbo].[onca_campaign_product]
(
	[campaign_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_product_i3] ON [dbo].[onca_campaign_product]
(
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_product_i4] ON [dbo].[onca_campaign_product]
(
	[product_code] ASC,
	[version_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_product_i5] ON [dbo].[onca_campaign_product]
(
	[version_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_product_i6] ON [dbo].[onca_campaign_product]
(
	[serial_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_campaign_product]  WITH CHECK ADD  CONSTRAINT [campaign_campaign_pro_1126] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[onca_campaign_product] CHECK CONSTRAINT [campaign_campaign_pro_1126]
GO
ALTER TABLE [dbo].[onca_campaign_product]  WITH CHECK ADD  CONSTRAINT [contract_campaign_pro_1130] FOREIGN KEY([contract_id])
REFERENCES [dbo].[oncd_contract] ([contract_id])
GO
ALTER TABLE [dbo].[onca_campaign_product] CHECK CONSTRAINT [contract_campaign_pro_1130]
GO
ALTER TABLE [dbo].[onca_campaign_product]  WITH CHECK ADD  CONSTRAINT [product_campaign_pro_1129] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[onca_campaign_product] CHECK CONSTRAINT [product_campaign_pro_1129]
GO
ALTER TABLE [dbo].[onca_campaign_product]  WITH CHECK ADD  CONSTRAINT [product_vers_campaign_pro_1131] FOREIGN KEY([version_code])
REFERENCES [dbo].[onca_product_version] ([version_code])
GO
ALTER TABLE [dbo].[onca_campaign_product] CHECK CONSTRAINT [product_vers_campaign_pro_1131]
GO
