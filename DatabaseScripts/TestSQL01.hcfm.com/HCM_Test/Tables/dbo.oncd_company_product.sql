/* CreateDate: 01/18/2005 09:34:13.967 , ModifyDate: 06/21/2012 10:10:48.440 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_company_product](
	[company_product_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
 CONSTRAINT [pk_oncd_company_product] PRIMARY KEY CLUSTERED
(
	[company_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_product_i2] ON [dbo].[oncd_company_product]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_product_i3] ON [dbo].[oncd_company_product]
(
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_product_i4] ON [dbo].[oncd_company_product]
(
	[product_code] ASC,
	[version_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_product_i5] ON [dbo].[oncd_company_product]
(
	[version_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_product_i6] ON [dbo].[oncd_company_product]
(
	[serial_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_product]  WITH CHECK ADD  CONSTRAINT [company_company_prod_171] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_product] CHECK CONSTRAINT [company_company_prod_171]
GO
ALTER TABLE [dbo].[oncd_company_product]  WITH CHECK ADD  CONSTRAINT [contract_company_prod_330] FOREIGN KEY([contract_id])
REFERENCES [dbo].[oncd_contract] ([contract_id])
GO
ALTER TABLE [dbo].[oncd_company_product] CHECK CONSTRAINT [contract_company_prod_330]
GO
ALTER TABLE [dbo].[oncd_company_product]  WITH CHECK ADD  CONSTRAINT [product_company_prod_543] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[oncd_company_product] CHECK CONSTRAINT [product_company_prod_543]
GO
ALTER TABLE [dbo].[oncd_company_product]  WITH CHECK ADD  CONSTRAINT [product_vers_company_prod_1089] FOREIGN KEY([version_code])
REFERENCES [dbo].[onca_product_version] ([version_code])
GO
ALTER TABLE [dbo].[oncd_company_product] CHECK CONSTRAINT [product_vers_company_prod_1089]
GO
ALTER TABLE [dbo].[oncd_company_product]  WITH CHECK ADD  CONSTRAINT [user_company_prod_541] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_product] CHECK CONSTRAINT [user_company_prod_541]
GO
ALTER TABLE [dbo].[oncd_company_product]  WITH CHECK ADD  CONSTRAINT [user_company_prod_542] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_product] CHECK CONSTRAINT [user_company_prod_542]
GO
