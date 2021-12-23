/* CreateDate: 06/14/2005 09:12:02.130 , ModifyDate: 06/21/2012 10:05:17.933 */
GO
CREATE TABLE [dbo].[oncd_order_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_order_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_order_blob]  WITH NOCHECK ADD  CONSTRAINT [order_attach_order_blob_403] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_order_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_order_blob] CHECK CONSTRAINT [order_attach_order_blob_403]
GO
