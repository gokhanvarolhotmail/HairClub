/* CreateDate: 01/25/2010 11:09:09.863 , ModifyDate: 06/21/2012 10:05:10.380 */
GO
CREATE TABLE [dbo].[oncd_project_user](
	[project_user_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_user_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_user] PRIMARY KEY CLUSTERED
(
	[project_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_user_i2] ON [dbo].[oncd_project_user]
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_user_i3] ON [dbo].[oncd_project_user]
(
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_user]  WITH CHECK ADD  CONSTRAINT [project_project_user_750] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_user] CHECK CONSTRAINT [project_project_user_750]
GO
ALTER TABLE [dbo].[oncd_project_user]  WITH CHECK ADD  CONSTRAINT [project_user_project_user_1066] FOREIGN KEY([project_user_role_code])
REFERENCES [dbo].[onca_project_user_role] ([project_user_role_code])
GO
ALTER TABLE [dbo].[oncd_project_user] CHECK CONSTRAINT [project_user_project_user_1066]
GO
ALTER TABLE [dbo].[oncd_project_user]  WITH CHECK ADD  CONSTRAINT [user_project_user_1064] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user] CHECK CONSTRAINT [user_project_user_1064]
GO
ALTER TABLE [dbo].[oncd_project_user]  WITH CHECK ADD  CONSTRAINT [user_project_user_1065] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user] CHECK CONSTRAINT [user_project_user_1065]
GO
ALTER TABLE [dbo].[oncd_project_user]  WITH CHECK ADD  CONSTRAINT [user_project_user_1067] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user] CHECK CONSTRAINT [user_project_user_1067]
GO
