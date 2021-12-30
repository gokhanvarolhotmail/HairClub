/* CreateDate: 11/14/2011 09:23:51.580 , ModifyDate: 09/10/2019 22:44:47.650 */
GO
CREATE TABLE [dbo].[cstd_activity_history](
	[activity_history_id] [int] IDENTITY(1,1) NOT NULL,
	[activity_history_date] [datetime] NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[recur_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[incident_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [datetime] NULL,
	[start_time] [datetime] NULL,
	[duration] [int] NULL,
	[action_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[completion_date] [datetime] NULL,
	[completion_time] [datetime] NULL,
	[completed_by_user_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_status_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_result_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_address_type_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notify_when_completed] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time_from] [datetime] NULL,
	[confirmed_time_to] [datetime] NULL,
	[document_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[milestone_activity_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_override_time_zone] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_lock_date] [datetime] NULL,
	[cst_lock_by_user_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_promotion_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_no_followup_flag] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_followup_time] [datetime] NULL,
	[cst_followup_date] [datetime] NULL,
	[cst_time_zone_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_utc_start_date] [datetime] NULL,
 CONSTRAINT [PK_cstd_activity_history] PRIMARY KEY CLUSTERED
(
	[activity_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_activity_history] ADD  CONSTRAINT [DF_cstd_activity_history_activity_history_date]  DEFAULT (getdate()) FOR [activity_history_date]
GO
