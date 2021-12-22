/* CreateDate: 01/18/2005 09:34:14.030 , ModifyDate: 06/21/2012 10:05:17.807 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_opportunity_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_opportunity_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity_blob]  WITH CHECK ADD  CONSTRAINT [opportunity__opportunity__181] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_opportunity_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_blob] CHECK CONSTRAINT [opportunity__opportunity__181]
GO
