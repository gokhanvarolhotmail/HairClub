/* CreateDate: 01/18/2005 09:34:09.373 , ModifyDate: 06/21/2012 10:05:29.323 */
GO
CREATE TABLE [dbo].[oncd_incident_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_incident_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_incident_blob]  WITH NOCHECK ADD  CONSTRAINT [incident_att_incident_blo_146] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_incident_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_incident_blob] CHECK CONSTRAINT [incident_att_incident_blo_146]
GO
