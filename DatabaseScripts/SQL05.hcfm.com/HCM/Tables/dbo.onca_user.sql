/* CreateDate: 01/03/2018 16:31:33.760 , ModifyDate: 11/08/2018 11:05:01.163 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
