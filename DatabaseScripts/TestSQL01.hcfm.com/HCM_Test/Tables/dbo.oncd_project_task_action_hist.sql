/* CreateDate: 01/25/2010 11:09:09.740 , ModifyDate: 06/21/2012 10:05:10.270 */
GO
CREATE TABLE [dbo].[oncd_project_task_action_hist](
	[project_task_action_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_action_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_task_action_hist] PRIMARY KEY CLUSTERED
(
	[project_task_action_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist]  WITH NOCHECK ADD  CONSTRAINT [project_mile_project_task_1044] FOREIGN KEY([project_milestone_id])
REFERENCES [dbo].[oncd_project_milestone] ([project_milestone_id])
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist] CHECK CONSTRAINT [project_mile_project_task_1044]
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist]  WITH NOCHECK ADD  CONSTRAINT [project_revi_project_task_768] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist] CHECK CONSTRAINT [project_revi_project_task_768]
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist]  WITH NOCHECK ADD  CONSTRAINT [project_task_project_task_1045] FOREIGN KEY([project_task_action_id])
REFERENCES [dbo].[oncd_project_task_action] ([project_task_action_id])
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist] CHECK CONSTRAINT [project_task_project_task_1045]
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist]  WITH NOCHECK ADD  CONSTRAINT [project_task_project_task_1046] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
GO
ALTER TABLE [dbo].[oncd_project_task_action_hist] CHECK CONSTRAINT [project_task_project_task_1046]
GO
