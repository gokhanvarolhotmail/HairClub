/* CreateDate: 01/25/2010 11:09:09.787 , ModifyDate: 06/21/2012 10:05:10.297 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_task_trigger](
	[project_task_trigger_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_task_trigger] PRIMARY KEY CLUSTERED
(
	[project_task_trigger_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger]  WITH CHECK ADD  CONSTRAINT [project_mile_project_task_760] FOREIGN KEY([project_milestone_id])
REFERENCES [dbo].[oncd_project_milestone] ([project_milestone_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_task_trigger] CHECK CONSTRAINT [project_mile_project_task_760]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1056] FOREIGN KEY([project_task_status_code])
REFERENCES [dbo].[onca_project_task_status] ([project_task_status_code])
GO
ALTER TABLE [dbo].[oncd_project_task_trigger] CHECK CONSTRAINT [project_task_project_task_1056]
GO
ALTER TABLE [dbo].[oncd_project_task_trigger]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_779] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
GO
ALTER TABLE [dbo].[oncd_project_task_trigger] CHECK CONSTRAINT [project_task_project_task_779]
GO
