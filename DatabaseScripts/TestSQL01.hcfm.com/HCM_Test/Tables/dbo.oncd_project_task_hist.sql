/* CreateDate: 01/25/2010 11:09:09.693 , ModifyDate: 06/21/2012 10:05:10.297 */
GO
CREATE TABLE [dbo].[oncd_project_task_hist](
	[project_task_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[project_task_time] [int] NULL,
	[generated_flag] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_task_hist] PRIMARY KEY CLUSTERED
(
	[project_task_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [project_elem_project_task_1052] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [project_elem_project_task_1052]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [project_revi_project_task_770] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [project_revi_project_task_770]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1053] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [project_task_project_task_1053]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1054] FOREIGN KEY([project_task_code])
REFERENCES [dbo].[onca_project_task] ([project_task_code])
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [project_task_project_task_1054]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1055] FOREIGN KEY([project_task_status_code])
REFERENCES [dbo].[onca_project_task_status] ([project_task_status_code])
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [project_task_project_task_1055]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [user_project_task_1050] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [user_project_task_1050]
GO
ALTER TABLE [dbo].[oncd_project_task_hist]  WITH CHECK ADD  CONSTRAINT [user_project_task_1051] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_task_hist] CHECK CONSTRAINT [user_project_task_1051]
GO
