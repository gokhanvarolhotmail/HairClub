/* CreateDate: 01/25/2010 11:09:10.160 , ModifyDate: 06/21/2012 10:05:10.393 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_user_task](
	[project_user_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_user_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[task_priority] [int] NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[project_user_task_time] [int] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_user_task] PRIMARY KEY CLUSTERED
(
	[project_user_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_user_task_i2] ON [dbo].[oncd_project_user_task]
(
	[project_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_user_task_i3] ON [dbo].[oncd_project_user_task]
(
	[project_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_user_task] ADD  DEFAULT ((1)) FOR [task_priority]
GO
ALTER TABLE [dbo].[oncd_project_user_task] ADD  DEFAULT ((0)) FOR [project_user_task_time]
GO
ALTER TABLE [dbo].[oncd_project_user_task]  WITH CHECK ADD  CONSTRAINT [project_task_project_user_781] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_user_task] CHECK CONSTRAINT [project_task_project_user_781]
GO
ALTER TABLE [dbo].[oncd_project_user_task]  WITH CHECK ADD  CONSTRAINT [project_user_project_user_784] FOREIGN KEY([project_user_id])
REFERENCES [dbo].[oncd_project_user] ([project_user_id])
GO
ALTER TABLE [dbo].[oncd_project_user_task] CHECK CONSTRAINT [project_user_project_user_784]
GO
ALTER TABLE [dbo].[oncd_project_user_task]  WITH CHECK ADD  CONSTRAINT [user_project_user_1073] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user_task] CHECK CONSTRAINT [user_project_user_1073]
GO
ALTER TABLE [dbo].[oncd_project_user_task]  WITH CHECK ADD  CONSTRAINT [user_project_user_1074] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_user_task] CHECK CONSTRAINT [user_project_user_1074]
GO
