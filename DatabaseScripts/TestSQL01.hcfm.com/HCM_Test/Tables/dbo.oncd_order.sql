/* CreateDate: 01/18/2005 09:34:14.060 , ModifyDate: 06/21/2012 10:05:17.943 */
GO
CREATE TABLE [dbo].[oncd_order](
	[order_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_number] [int] NULL,
	[po_number] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_ship_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_terms_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_date] [datetime] NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[order_amount] [decimal](15, 4) NULL,
	[commission_amount] [decimal](15, 4) NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_order] PRIMARY KEY CLUSTERED
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_order_I2] ON [dbo].[oncd_order]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_order_i3] ON [dbo].[oncd_order]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_order_i4] ON [dbo].[oncd_order]
(
	[opportunity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_order_i5] ON [dbo].[oncd_order]
(
	[order_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_order_i6] ON [dbo].[oncd_order]
(
	[order_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [company_order_176] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [company_order_176]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [contact_order_177] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [contact_order_177]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [opportunity_order_178] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [opportunity_order_178]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [order_ship_order_706] FOREIGN KEY([order_ship_code])
REFERENCES [dbo].[onca_order_ship] ([order_ship_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [order_ship_order_706]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [order_status_order_708] FOREIGN KEY([order_status_code])
REFERENCES [dbo].[onca_order_status] ([order_status_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [order_status_order_708]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [order_terms_order_707] FOREIGN KEY([order_terms_code])
REFERENCES [dbo].[onca_order_terms] ([order_terms_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [order_terms_order_707]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [order_type_order_709] FOREIGN KEY([order_type_code])
REFERENCES [dbo].[onca_order_type] ([order_type_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [order_type_order_709]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [user_order_710] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [user_order_710]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [user_order_711] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [user_order_711]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [user_order_712] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [user_order_712]
GO
ALTER TABLE [dbo].[oncd_order]  WITH NOCHECK ADD  CONSTRAINT [user_order_713] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order] CHECK CONSTRAINT [user_order_713]
GO
