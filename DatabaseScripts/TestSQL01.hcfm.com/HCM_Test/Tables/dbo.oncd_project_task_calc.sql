/* CreateDate: 01/25/2010 11:09:09.647 , ModifyDate: 06/21/2012 10:05:10.283 */
GO
CREATE TABLE [dbo].[oncd_project_task_calc](
	[project_task_calc_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_calc_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_task_calc] PRIMARY KEY CLUSTERED
(
	[project_task_calc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task_calc]  WITH CHECK ADD  CONSTRAINT [project_elem_project_task_757] FOREIGN KEY([project_element_calc_id])
REFERENCES [dbo].[oncd_project_element_calc] ([project_element_calc_id])
GO
ALTER TABLE [dbo].[oncd_project_task_calc] CHECK CONSTRAINT [project_elem_project_task_757]
GO
ALTER TABLE [dbo].[oncd_project_task_calc]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_778] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_task_calc] CHECK CONSTRAINT [project_task_project_task_778]
GO
