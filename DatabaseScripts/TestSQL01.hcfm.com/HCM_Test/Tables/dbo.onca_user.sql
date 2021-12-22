/* CreateDate: 04/13/2006 13:57:45.260 , ModifyDate: 10/23/2017 12:35:40.160 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_user](
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[department_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[job_function_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_value] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_date] [datetime] NULL,
	[password_expires] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[change_password] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[middle_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[full_name] [nchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[title] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cti_server] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cti_user_code] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cti_password] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cti_station] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cti_extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_set_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[startup_object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clear_cache] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_name] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[license_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[outlook_sync_frequency] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[outlook_sync_confirm] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_is_queue_user] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_user] PRIMARY KEY CLUSTERED
(
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user] ADD  CONSTRAINT [DF_onca_user_cst_is_queue_user]  DEFAULT (N'Y') FOR [cst_is_queue_user]
GO
ALTER TABLE [dbo].[onca_user]  WITH CHECK ADD  CONSTRAINT [action_set_user_859] FOREIGN KEY([action_set_code])
REFERENCES [dbo].[onca_action_set] ([action_set_code])
GO
ALTER TABLE [dbo].[onca_user] CHECK CONSTRAINT [action_set_user_859]
GO
ALTER TABLE [dbo].[onca_user]  WITH CHECK ADD  CONSTRAINT [department_user_227] FOREIGN KEY([department_code])
REFERENCES [dbo].[onca_department] ([department_code])
GO
ALTER TABLE [dbo].[onca_user] CHECK CONSTRAINT [department_user_227]
GO
ALTER TABLE [dbo].[onca_user]  WITH CHECK ADD  CONSTRAINT [job_function_user_265] FOREIGN KEY([job_function_code])
REFERENCES [dbo].[onca_job_function] ([job_function_code])
GO
ALTER TABLE [dbo].[onca_user] CHECK CONSTRAINT [job_function_user_265]
GO
ALTER TABLE [dbo].[onca_user]  WITH CHECK ADD  CONSTRAINT [object_user_1185] FOREIGN KEY([startup_object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onca_user] CHECK CONSTRAINT [object_user_1185]
GO
