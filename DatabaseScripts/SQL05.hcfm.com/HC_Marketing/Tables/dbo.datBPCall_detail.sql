/* CreateDate: 09/01/2020 15:56:33.603 , ModifyDate: 11/24/2020 14:15:21.610 */
GO
CREATE TABLE [dbo].[datBPCall_detail](
	[id] [binary](16) NULL,
	[pkid] [int] NULL,
	[agg_run_id] [binary](16) NULL,
	[media_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_time] [datetime] NULL,
	[ivr_time] [bigint] NULL,
	[queue_time] [bigint] NULL,
	[pending_time] [bigint] NULL,
	[talk_time] [bigint] NULL,
	[hold_time] [bigint] NULL,
	[held] [bigint] NULL,
	[max_hold] [bigint] NULL,
	[acw_time] [bigint] NULL,
	[duration] [bigint] NULL,
	[service_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[scenario_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trunk_description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_login_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_login_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_phone_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_phone_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_rank] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_rank] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[from_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_destination_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[connected_to_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[transferred_from_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[disposition] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_disposition_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_disposition_code] [int] NULL,
	[agent_disposition_notes] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reported_problem] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[global_interaction_id] [binary](16) NULL,
	[initial_call_id] [binary](16) NULL,
	[initial_start_time] [datetime] NULL,
	[initial_service_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_caller_phone_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_callee_phone_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_from_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_original_destination_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_connected_to_phone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[flagged] [int] NULL,
	[voice_signature] [int] NULL,
	[account_number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_city] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_city] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_country] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_country] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_id] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_subject] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_language] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[case_id] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[thread_id] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[case_number] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[case_search_result] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[response_email_id] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_monitored] [int] NULL,
	[callee_monitored] [int] NULL,
	[caller_interaction_step_id] [binary](16) NULL,
	[callee_interaction_step_id] [binary](16) NULL,
	[caller_cpa_rtp_server_id] [binary](16) NULL,
	[caller_cpa_recording_url] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_encryption_key_id] [binary](16) NULL,
	[callee_cpa_rtp_server_id] [binary](16) NULL,
	[callee_cpa_recording_url] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_encryption_key_id] [binary](16) NULL,
	[caller_has_screen_recording] [int] NULL,
	[callee_has_screen_recording] [int] NULL,
	[caller_interaction_id] [binary](16) NULL,
	[callee_interaction_id] [binary](16) NULL,
	[caller_has_voice_recording] [int] NULL,
	[callee_has_voice_recording] [int] NULL,
	[voice_recording_banned] [int] NULL,
	[monitoring_banned] [int] NULL,
	[email_detail_id] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_completion_time] [bigint] NULL,
	[email_kb_article_id] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[caller_team_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[callee_team_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[detail_record_count] [int] NULL,
	[in_service_level] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custom1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custom2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custom3] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custom4] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custom5] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sentiment] [decimal](5, 3) NULL,
	[erased_voice_recording] [int] NULL,
	[erased_voice_signature] [int] NULL,
	[erased_chat_transcript] [int] NULL,
	[erased_email] [int] NULL,
	[erased_screen_recording] [int] NULL,
	[ewt] [bigint] NULL,
	[cobrowsing] [int] NULL,
	[HC_Timestamp] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
