/* CreateDate: 01/18/2005 09:34:14.513 , ModifyDate: 06/21/2012 10:05:24.177 */
GO
CREATE TABLE [dbo].[oncd_knowledge_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_knowledge_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_knowledge_blob]  WITH CHECK ADD  CONSTRAINT [knowledge_at_knowledge_bl_206] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_knowledge_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_knowledge_blob] CHECK CONSTRAINT [knowledge_at_knowledge_bl_206]
GO
