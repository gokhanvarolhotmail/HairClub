/* CreateDate: 01/25/2010 11:09:10.053 , ModifyDate: 06/21/2012 10:05:10.300 */
GO
CREATE TABLE [dbo].[oncd_project_task_trigger_hist](
	[project_task_trigger_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_trigger_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_task_trigger_hist] PRIMARY KEY CLUSTERED
(
	[project_task_trigger_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist]  WITH CHECK ADD  CONSTRAINT [project_mile_project_task_1057] FOREIGN KEY([project_milestone_id])
REFERENCES [dbo].[oncd_project_milestone] ([project_milestone_id])
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist] CHECK CONSTRAINT [project_mile_project_task_1057]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist]  WITH CHECK ADD  CONSTRAINT [project_revi_project_task_771] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist] CHECK CONSTRAINT [project_revi_project_task_771]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1058] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist] CHECK CONSTRAINT [project_task_project_task_1058]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1076] FOREIGN KEY([project_task_trigger_id])
REFERENCES [dbo].[oncd_project_task_trigger] ([project_task_trigger_id])
GO
ALTER TABLE [dbo].[oncd_project_task_trigger_hist] CHECK CONSTRAINT [project_task_project_task_1076]
GO
