/* CreateDate: 01/25/2010 11:09:10.067 , ModifyDate: 06/21/2012 10:05:10.157 */
GO
CREATE TABLE [dbo].[oncd_project_signoff_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_project_signoff_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_signoff_blob]  WITH NOCHECK ADD  CONSTRAINT [project_sign_project_sign_775] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_project_signoff_attach] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_signoff_blob] CHECK CONSTRAINT [project_sign_project_sign_775]
GO
