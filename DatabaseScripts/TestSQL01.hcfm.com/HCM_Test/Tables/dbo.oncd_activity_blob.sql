/* CreateDate: 01/18/2005 09:34:13.437 , ModifyDate: 06/21/2012 10:21:48.790 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_activity_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_activity_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_blob]  WITH CHECK ADD  CONSTRAINT [activity_att_activity_blo_180] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_activity_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_blob] CHECK CONSTRAINT [activity_att_activity_blo_180]
GO
