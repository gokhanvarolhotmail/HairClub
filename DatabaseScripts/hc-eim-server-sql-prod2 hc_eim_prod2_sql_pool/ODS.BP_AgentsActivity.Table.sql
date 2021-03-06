/****** Object:  Table [ODS].[BP_AgentsActivity]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[BP_AgentsActivity]
(
	[id] [varbinary](max) NULL,
	[pkid] [int] NULL,
	[activity_id] [varbinary](max) NULL,
	[login_id] [varchar](8000) NULL,
	[first_name] [varchar](8000) NULL,
	[last_name] [varchar](8000) NULL,
	[team_name] [varchar](8000) NULL,
	[agent_country] [varchar](8000) NULL,
	[agent_city] [varchar](8000) NULL,
	[rank] [varchar](8000) NULL,
	[agg_run_id] [varbinary](max) NULL,
	[start_time] [datetime2](7) NULL,
	[activity] [varchar](8000) NULL,
	[duration] [bigint] NULL,
	[detail] [varchar](8000) NULL,
	[pending_time] [bigint] NULL,
	[talk_time] [bigint] NULL,
	[hold_time] [bigint] NULL,
	[held] [bigint] NULL,
	[max_hold] [bigint] NULL,
	[acw_time] [bigint] NULL,
	[service_name] [varchar](8000) NULL,
	[origination_number] [varchar](8000) NULL,
	[destination_number] [varchar](8000) NULL,
	[external_number] [varchar](8000) NULL,
	[other_party_phone_type] [varchar](8000) NULL,
	[disposition] [varchar](8000) NULL,
	[agent_disposition_name] [varchar](8000) NULL,
	[agent_disposition_code] [int] NULL,
	[agent_disposition_notes] [varchar](8000) NULL,
	[session_id] [varbinary](max) NULL,
	[media_type] [varchar](8000) NULL,
	[case_number] [varchar](8000) NULL,
	[email_completion_time] [bigint] NULL,
	[workitem_id] [varchar](8000) NULL,
	[call_detail_id] [varbinary](max) NULL,
	[has_screen_recording] [bit] NULL,
	[cobrowsing] [bit] NULL,
	[custom1] [varchar](8000) NULL,
	[custom2] [varchar](8000) NULL,
	[custom3] [varchar](8000) NULL,
	[custom4] [varchar](8000) NULL,
	[custom5] [varchar](8000) NULL,
	[ip_address] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
