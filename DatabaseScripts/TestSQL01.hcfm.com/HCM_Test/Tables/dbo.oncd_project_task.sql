/* CreateDate: 01/25/2010 11:09:09.647 , ModifyDate: 06/21/2012 10:05:10.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_task](
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[project_task_time] [int] NULL,
	[project_task_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_task] PRIMARY KEY CLUSTERED
(
	[project_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_task_i2_] ON [dbo].[oncd_project_task]
(
	[project_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_task]  WITH CHECK ADD  CONSTRAINT [project_elem_project_task_756] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_task] CHECK CONSTRAINT [project_elem_project_task_756]
GO
ALTER TABLE [dbo].[oncd_project_task]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1042] FOREIGN KEY([project_task_status_code])
REFERENCES [dbo].[onca_project_task_status] ([project_task_status_code])
GO
ALTER TABLE [dbo].[oncd_project_task] CHECK CONSTRAINT [project_task_project_task_1042]
GO
ALTER TABLE [dbo].[oncd_project_task]  WITH CHECK ADD  CONSTRAINT [project_task_project_task_1188] FOREIGN KEY([project_task_code])
REFERENCES [dbo].[onca_project_task] ([project_task_code])
GO
ALTER TABLE [dbo].[oncd_project_task] CHECK CONSTRAINT [project_task_project_task_1188]
GO
ALTER TABLE [dbo].[oncd_project_task]  WITH CHECK ADD  CONSTRAINT [user_project_task_1040] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_task] CHECK CONSTRAINT [user_project_task_1040]
GO
ALTER TABLE [dbo].[oncd_project_task]  WITH CHECK ADD  CONSTRAINT [user_project_task_1041] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_task] CHECK CONSTRAINT [user_project_task_1041]
GO
