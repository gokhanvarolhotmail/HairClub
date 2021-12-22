/* CreateDate: 07/19/2006 11:08:55.620 , ModifyDate: 06/21/2012 10:05:29.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_incident_attachment](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[storage_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncd_incident_attachment] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_attachment_i2] ON [dbo].[oncd_incident_attachment]
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_incident_attachment]  WITH CHECK ADD  CONSTRAINT [incident_incident_att_145] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_incident_attachment] CHECK CONSTRAINT [incident_incident_att_145]
GO
ALTER TABLE [dbo].[oncd_incident_attachment]  WITH CHECK ADD  CONSTRAINT [user_incident_att_662] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident_attachment] CHECK CONSTRAINT [user_incident_att_662]
GO
ALTER TABLE [dbo].[oncd_incident_attachment]  WITH CHECK ADD  CONSTRAINT [user_incident_att_663] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident_attachment] CHECK CONSTRAINT [user_incident_att_663]
GO
