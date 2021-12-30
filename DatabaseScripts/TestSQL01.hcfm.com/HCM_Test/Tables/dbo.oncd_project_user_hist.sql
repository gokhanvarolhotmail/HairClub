/* CreateDate: 01/25/2010 11:09:09.820 , ModifyDate: 06/21/2012 10:05:10.383 */
GO
CREATE TABLE [dbo].[oncd_project_user_hist](
	[project_user_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_user_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_user_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_user_hist] PRIMARY KEY CLUSTERED
(
	[project_user_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_user_hist]  WITH CHECK ADD  CONSTRAINT [project_revi_project_user_772] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_user_hist] CHECK CONSTRAINT [project_revi_project_user_772]
GO
ALTER TABLE [dbo].[oncd_project_user_hist]  WITH CHECK ADD  CONSTRAINT [project_user_project_user_1070] FOREIGN KEY([project_user_role_code])
REFERENCES [dbo].[onca_project_user_role] ([project_user_role_code])
GO
ALTER TABLE [dbo].[oncd_project_user_hist] CHECK CONSTRAINT [project_user_project_user_1070]
GO
ALTER TABLE [dbo].[oncd_project_user_hist]  WITH CHECK ADD  CONSTRAINT [project_user_project_user_1072] FOREIGN KEY([project_user_id])
REFERENCES [dbo].[oncd_project_user] ([project_user_id])
GO
ALTER TABLE [dbo].[oncd_project_user_hist] CHECK CONSTRAINT [project_user_project_user_1072]
GO
ALTER TABLE [dbo].[oncd_project_user_hist]  WITH CHECK ADD  CONSTRAINT [user_project_user_1068] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user_hist] CHECK CONSTRAINT [user_project_user_1068]
GO
ALTER TABLE [dbo].[oncd_project_user_hist]  WITH CHECK ADD  CONSTRAINT [user_project_user_1069] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user_hist] CHECK CONSTRAINT [user_project_user_1069]
GO
ALTER TABLE [dbo].[oncd_project_user_hist]  WITH CHECK ADD  CONSTRAINT [user_project_user_1071] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user_hist] CHECK CONSTRAINT [user_project_user_1071]
GO
