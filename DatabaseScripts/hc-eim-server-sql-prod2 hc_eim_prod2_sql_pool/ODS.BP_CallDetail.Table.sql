/****** Object:  Table [ODS].[BP_CallDetail]    Script Date: 2/22/2022 9:20:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[BP_CallDetail]
(
	[id] [varbinary](max) NULL,
	[pkid] [int] NULL,
	[agg_run_id] [varbinary](max) NULL,
	[media_type] [nvarchar](max) NULL,
	[start_time] [datetime2](7) NULL,
	[ivr_time] [bigint] NULL,
	[queue_time] [bigint] NULL,
	[pending_time] [bigint] NULL,
	[talk_time] [bigint] NULL,
	[hold_time] [bigint] NULL,
	[held] [bigint] NULL,
	[max_hold] [bigint] NULL,
	[acw_time] [bigint] NULL,
	[duration] [bigint] NULL,
	[service_name] [nvarchar](max) NULL,
	[scenario_name] [nvarchar](max) NULL,
	[trunk_description] [nvarchar](max) NULL,
	[caller_login_id] [nvarchar](max) NULL,
	[callee_login_id] [nvarchar](max) NULL,
	[caller_phone_type] [nvarchar](max) NULL,
	[callee_phone_type] [nvarchar](max) NULL,
	[caller_rank] [nvarchar](max) NULL,
	[callee_rank] [nvarchar](max) NULL,
	[from_phone] [nvarchar](max) NULL,
	[original_destination_phone] [nvarchar](max) NULL,
	[connected_to_phone] [nvarchar](max) NULL,
	[transferred_from_phone] [nvarchar](max) NULL,
	[disposition] [nvarchar](max) NULL,
	[agent_disposition_name] [nvarchar](max) NULL,
	[agent_disposition_code] [int] NULL,
	[agent_disposition_notes] [nvarchar](max) NULL,
	[reported_problem] [nvarchar](max) NULL,
	[initial_start_time] [datetime2](7) NULL,
	[initial_service_name] [nvarchar](max) NULL,
	[initial_caller_phone_type] [nvarchar](max) NULL,
	[initial_callee_phone_type] [nvarchar](max) NULL,
	[initial_from_phone] [nvarchar](max) NULL,
	[initial_original_destination_phone] [nvarchar](max) NULL,
	[initial_connected_to_phone] [nvarchar](max) NULL,
	[flagged] [bit] NULL,
	[voice_signature] [bit] NULL,
	[account_number] [nvarchar](max) NULL,
	[caller_first_name] [nvarchar](max) NULL,
	[callee_first_name] [nvarchar](max) NULL,
	[caller_last_name] [nvarchar](max) NULL,
	[callee_last_name] [nvarchar](max) NULL,
	[caller_city] [nvarchar](max) NULL,
	[callee_city] [nvarchar](max) NULL,
	[caller_country] [nvarchar](max) NULL,
	[callee_country] [nvarchar](max) NULL,
	[email_id] [nvarchar](max) NULL,
	[email_subject] [nvarchar](max) NULL,
	[email_language] [nvarchar](max) NULL,
	[case_id] [nvarchar](max) NULL,
	[thread_id] [nvarchar](max) NULL,
	[case_number] [nvarchar](max) NULL,
	[case_search_result] [nvarchar](max) NULL,
	[response_email_id] [nvarchar](max) NULL,
	[caller_monitored] [bit] NULL,
	[callee_monitored] [bit] NULL,
	[caller_interaction_step_id] [varbinary](max) NULL,
	[callee_interaction_step_id] [varbinary](max) NULL,
	[caller_cpa_rtp_server_id] [varbinary](max) NULL,
	[caller_cpa_recording_url] [nvarchar](max) NULL,
	[caller_encryption_key_id] [varbinary](max) NULL,
	[callee_cpa_rtp_server_id] [varbinary](max) NULL,
	[callee_cpa_recording_url] [nvarchar](max) NULL,
	[callee_encryption_key_id] [varbinary](max) NULL,
	[caller_has_screen_recording] [bit] NULL,
	[callee_has_screen_recording] [bit] NULL,
	[caller_interaction_id] [varbinary](max) NULL,
	[callee_interaction_id] [varbinary](max) NULL,
	[caller_has_voice_recording] [bit] NULL,
	[callee_has_voice_recording] [bit] NULL,
	[voice_recording_banned] [bit] NULL,
	[monitoring_banned] [bit] NULL,
	[email_detail_id] [nvarchar](max) NULL,
	[email_completion_time] [bigint] NULL,
	[email_kb_article_id] [nvarchar](max) NULL,
	[caller_team_name] [nvarchar](max) NULL,
	[callee_team_name] [nvarchar](max) NULL,
	[detail_record_count] [int] NULL,
	[in_service_level] [nvarchar](max) NULL,
	[custom1] [nvarchar](max) NULL,
	[custom2] [nvarchar](max) NULL,
	[custom3] [nvarchar](max) NULL,
	[custom4] [nvarchar](max) NULL,
	[custom5] [nvarchar](max) NULL,
	[sentiment] [decimal](38, 18) NULL,
	[erased_voice_recording] [bit] NULL,
	[erased_voice_signature] [bit] NULL,
	[erased_chat_transcript] [bit] NULL,
	[erased_email] [bit] NULL,
	[erased_screen_recording] [bit] NULL,
	[ewt] [bigint] NULL,
	[cobrowsing] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
