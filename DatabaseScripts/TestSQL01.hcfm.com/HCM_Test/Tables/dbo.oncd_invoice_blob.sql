/* CreateDate: 01/25/2010 11:09:10.113 , ModifyDate: 06/21/2012 10:05:24.090 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_invoice_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_invoice_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_invoice_blob]  WITH CHECK ADD  CONSTRAINT [invoice_atta_invoice_blob_739] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_invoice_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_invoice_blob] CHECK CONSTRAINT [invoice_atta_invoice_blob_739]
GO
