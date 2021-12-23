/* CreateDate: 01/25/2010 11:09:10.007 , ModifyDate: 06/21/2012 10:05:24.087 */
GO
CREATE TABLE [dbo].[oncd_invoice_attachment](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[invoice_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[storage_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_invoice_attachment] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_attachment_i2_] ON [dbo].[oncd_invoice_attachment]
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_invoice_attachment]  WITH NOCHECK ADD  CONSTRAINT [invoice_invoice_atta_737] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[oncd_invoice] ([invoice_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_invoice_attachment] CHECK CONSTRAINT [invoice_invoice_atta_737]
GO
ALTER TABLE [dbo].[oncd_invoice_attachment]  WITH NOCHECK ADD  CONSTRAINT [user_invoice_atta_968] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_attachment] CHECK CONSTRAINT [user_invoice_atta_968]
GO
ALTER TABLE [dbo].[oncd_invoice_attachment]  WITH NOCHECK ADD  CONSTRAINT [user_invoice_atta_969] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_attachment] CHECK CONSTRAINT [user_invoice_atta_969]
GO
