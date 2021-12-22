/* CreateDate: 01/25/2010 11:09:09.693 , ModifyDate: 06/21/2012 10:05:10.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_time](
	[project_time_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_time_date] [datetime] NOT NULL,
	[description] [nchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_time] [int] NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[email_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[task_complete_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_time] PRIMARY KEY CLUSTERED
(
	[project_time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [index_oncd_project_time_i2] ON [dbo].[oncd_project_time]
(
	[project_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [index_oncd_project_time_i3_] ON [dbo].[oncd_project_time]
(
	[user_code] ASC,
	[project_time_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [index_oncd_project_time_i4] ON [dbo].[oncd_project_time]
(
	[project_time_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_time]  WITH CHECK ADD  CONSTRAINT [project_task_project_time_780] FOREIGN KEY([project_task_id])
REFERENCES [dbo].[oncd_project_task] ([project_task_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_time] CHECK CONSTRAINT [project_task_project_time_780]
GO
ALTER TABLE [dbo].[oncd_project_time]  WITH CHECK ADD  CONSTRAINT [user_project_time_1059] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_time] CHECK CONSTRAINT [user_project_time_1059]
GO
ALTER TABLE [dbo].[oncd_project_time]  WITH CHECK ADD  CONSTRAINT [user_project_time_1060] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_time] CHECK CONSTRAINT [user_project_time_1060]
GO
ALTER TABLE [dbo].[oncd_project_time]  WITH CHECK ADD  CONSTRAINT [user_project_time_1061] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_time] CHECK CONSTRAINT [user_project_time_1061]
GO
