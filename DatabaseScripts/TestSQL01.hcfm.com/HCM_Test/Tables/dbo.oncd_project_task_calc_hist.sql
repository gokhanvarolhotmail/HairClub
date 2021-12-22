/* CreateDate: 01/25/2010 11:09:09.850 , ModifyDate: 06/21/2012 10:05:10.283 */
GO
CREATE TABLE [dbo].[oncd_project_task_calc_hist](
	[project_task_calc_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_calc_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_calc_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_task_calc_hist] PRIMARY KEY CLUSTERED
(
	[project_task_calc_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist]  WITH CHECK ADD  CONSTRAINT [project_elem_project_task_1048] FOREIGN KEY([project_element_calc_id])
REFERENCES [dbo].[oncd_project_element_calc] ([project_element_calc_id])
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist] CHECK CONSTRAINT [project_elem_project_task_1048]
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist]  WITH CHECK ADD  CONSTRAINT [project_revi_project_task_769] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist] CHECK CONSTRAINT [project_revi_project_task_769]
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1047] FOREIGN KEY([project_task_calc_id])
REFERENCES [dbo].[oncd_project_task_calc] ([project_task_calc_id])
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist] CHECK CONSTRAINT [project_task_project_task_1047]
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1049] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
GO
ALTER TABLE [dbo].[oncd_project_task_calc_hist] CHECK CONSTRAINT [project_task_project_task_1049]
GO
