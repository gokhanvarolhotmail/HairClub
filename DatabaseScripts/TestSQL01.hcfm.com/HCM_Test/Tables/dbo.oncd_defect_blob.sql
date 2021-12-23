/* CreateDate: 01/18/2005 09:34:16.403 , ModifyDate: 06/21/2012 10:05:29.213 */
GO
CREATE TABLE [dbo].[oncd_defect_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_defect_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_defect_blob]  WITH NOCHECK ADD  CONSTRAINT [defect_attac_defect_blob_222] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_defect_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_defect_blob] CHECK CONSTRAINT [defect_attac_defect_blob_222]
GO
