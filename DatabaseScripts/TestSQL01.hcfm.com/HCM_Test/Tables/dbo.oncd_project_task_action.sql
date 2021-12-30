/* CreateDate: 01/25/2010 11:09:09.757 , ModifyDate: 06/21/2012 10:05:10.227 */
GO
CREATE TABLE [dbo].[oncd_project_task_action](
	[project_task_action_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_task_action] PRIMARY KEY CLUSTERED
(
	[project_task_action_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_action]  WITH CHECK ADD  CONSTRAINT [project_mile_project_task_759] FOREIGN KEY([project_milestone_id])
REFERENCES [dbo].[oncd_project_milestone] ([project_milestone_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_task_action] CHECK CONSTRAINT [project_mile_project_task_759]
GO
ALTER TABLE [dbo].[oncd_project_task_action]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1043] FOREIGN KEY([project_task_status_code])
REFERENCES [dbo].[onca_project_task_status] ([project_task_status_code])
GO
ALTER TABLE [dbo].[oncd_project_task_action] CHECK CONSTRAINT [project_task_project_task_1043]
GO
ALTER TABLE [dbo].[oncd_project_task_action]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_777] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
GO
ALTER TABLE [dbo].[oncd_project_task_action] CHECK CONSTRAINT [project_task_project_task_777]
GO
