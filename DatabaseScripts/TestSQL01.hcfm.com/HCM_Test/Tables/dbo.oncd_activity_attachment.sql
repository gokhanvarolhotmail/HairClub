/* CreateDate: 01/18/2005 09:34:13.263 , ModifyDate: 06/21/2012 10:21:48.790 */
GO
CREATE TABLE [dbo].[oncd_activity_attachment](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[storage_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncd_activity_attachment] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_attachment_i2] ON [dbo].[oncd_activity_attachment]
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_attachment]  WITH CHECK ADD  CONSTRAINT [activity_activity_att_179] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_attachment] CHECK CONSTRAINT [activity_activity_att_179]
GO
ALTER TABLE [dbo].[oncd_activity_attachment]  WITH CHECK ADD  CONSTRAINT [user_activity_att_449] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_attachment] CHECK CONSTRAINT [user_activity_att_449]
GO
ALTER TABLE [dbo].[oncd_activity_attachment]  WITH CHECK ADD  CONSTRAINT [user_activity_att_450] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_attachment] CHECK CONSTRAINT [user_activity_att_450]
GO
