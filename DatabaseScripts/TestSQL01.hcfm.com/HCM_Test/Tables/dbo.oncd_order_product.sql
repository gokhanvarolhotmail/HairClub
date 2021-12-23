/* CreateDate: 01/18/2005 09:34:14.123 , ModifyDate: 06/21/2012 10:05:17.980 */
GO
CREATE TABLE [dbo].[oncd_order_product](
	[order_product_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[order_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quantity] [int] NULL,
	[price] [decimal](15, 4) NULL,
	[discount_percent] [int] NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_order_product] PRIMARY KEY CLUSTERED
(
	[order_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_order_product_i2] ON [dbo].[oncd_order_product]
(
	[order_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_order_product]  WITH NOCHECK ADD  CONSTRAINT [order_order_produc_173] FOREIGN KEY([order_id])
REFERENCES [dbo].[oncd_order] ([order_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_order_product] CHECK CONSTRAINT [order_order_produc_173]
GO
ALTER TABLE [dbo].[oncd_order_product]  WITH NOCHECK ADD  CONSTRAINT [product_order_produc_718] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[oncd_order_product] CHECK CONSTRAINT [product_order_produc_718]
GO
ALTER TABLE [dbo].[oncd_order_product]  WITH NOCHECK ADD  CONSTRAINT [user_order_produc_719] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order_product] CHECK CONSTRAINT [user_order_produc_719]
GO
ALTER TABLE [dbo].[oncd_order_product]  WITH NOCHECK ADD  CONSTRAINT [user_order_produc_720] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order_product] CHECK CONSTRAINT [user_order_produc_720]
GO
