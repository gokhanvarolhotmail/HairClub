/* CreateDate: 11/01/2007 17:16:59.593 , ModifyDate: 01/25/2010 11:00:42.413 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_activity_orphan](
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [datetime] NULL,
	[start_time] [datetime] NULL,
	[duration] [int] NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[completion_date] [datetime] NULL,
	[completion_time] [datetime] NULL,
	[completed_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notify_when_completed] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time_from] [datetime] NULL,
	[confirmed_time_to] [datetime] NULL,
	[document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[milestone_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_override_time_zone] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_lock_date] [datetime] NULL,
	[cst_lock_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_no_followup_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_followup_time] [datetime] NULL,
	[cst_followup_date] [datetime] NULL,
	[cst_time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_orphan] ADD  CONSTRAINT [russncd_acti__resul__3493CFA7]  DEFAULT (' ') FOR [result_code]
GO
ALTER TABLE [dbo].[oncd_activity_orphan] ADD  CONSTRAINT [russncd_acti__cst_o__3587F3E0]  DEFAULT (' ') FOR [cst_override_time_zone]
GO
