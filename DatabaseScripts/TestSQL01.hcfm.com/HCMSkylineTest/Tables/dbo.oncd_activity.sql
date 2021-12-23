/* CreateDate: 11/08/2012 11:01:24.477 , ModifyDate: 07/07/2015 13:10:18.537 */
GO
CREATE TABLE [dbo].[oncd_activity](
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
	[cst_time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_utc_start_date] [datetime] NULL,
	[cst_brochure_download] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_in_noble_queue] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity] PRIMARY KEY CLUSTERED
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity] ADD  CONSTRAINT [DF_oncd_activity_cst_brochure_download]  DEFAULT (N'N') FOR [cst_brochure_download]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH NOCHECK ADD  CONSTRAINT [FK_oncd_activity_csta_promotion_code] FOREIGN KEY([cst_promotion_code])
REFERENCES [dbo].[csta_promotion_code] ([promotion_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [FK_oncd_activity_csta_promotion_code]
GO
