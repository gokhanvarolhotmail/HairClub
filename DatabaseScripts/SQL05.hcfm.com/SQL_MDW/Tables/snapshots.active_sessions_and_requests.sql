/* CreateDate: 01/03/2014 07:07:49.110 , ModifyDate: 01/03/2014 07:07:49.290 */
GO
CREATE TABLE [snapshots].[active_sessions_and_requests](
	[row_id] [int] NOT NULL,
	[session_id] [smallint] NOT NULL,
	[request_id] [int] NOT NULL,
	[exec_context_id] [int] NOT NULL,
	[blocking_session_id] [smallint] NULL,
	[blocking_exec_context_id] [int] NULL,
	[scheduler_id] [int] NULL,
	[database_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_id] [int] NULL,
	[task_state] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[request_status] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_status] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[executing_managed_code] [bit] NULL,
	[login_time] [datetimeoffset](7) NOT NULL,
	[is_user_process] [bit] NOT NULL,
	[host_name] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[program_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[login_name] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[wait_type] [nvarchar](45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[last_wait_type] [nvarchar](45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[wait_duration_ms] [bigint] NOT NULL,
	[wait_resource] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[resource_description] [nvarchar](140) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transaction_id] [bigint] NULL,
	[open_transaction_count] [int] NOT NULL,
	[transaction_isolation_level] [smallint] NULL,
	[request_cpu_time] [int] NULL,
	[request_logical_reads] [bigint] NULL,
	[request_reads] [bigint] NULL,
	[request_writes] [bigint] NULL,
	[request_total_elapsed_time] [int] NULL,
	[request_start_time] [datetimeoffset](7) NULL,
	[memory_usage] [int] NOT NULL,
	[session_cpu_time] [int] NOT NULL,
	[session_reads] [bigint] NOT NULL,
	[session_writes] [bigint] NOT NULL,
	[session_logical_reads] [bigint] NOT NULL,
	[session_total_scheduled_time] [int] NOT NULL,
	[session_total_elapsed_time] [int] NOT NULL,
	[session_last_request_start_time] [datetimeoffset](7) NOT NULL,
	[session_last_request_end_time] [datetimeoffset](7) NULL,
	[open_resultsets] [int] NULL,
	[session_row_count] [bigint] NOT NULL,
	[prev_error] [int] NOT NULL,
	[pending_io_count] [int] NULL,
	[command] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[plan_handle] [varbinary](64) NULL,
	[sql_handle] [varbinary](64) NULL,
	[statement_start_offset] [int] NULL,
	[statement_end_offset] [int] NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
	[is_blocking] [bit] NOT NULL,
 CONSTRAINT [PK_active_sessions_and_requests] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[row_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_blocking_session_id] ON [snapshots].[active_sessions_and_requests]
(
	[blocking_session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_collection_time] ON [snapshots].[active_sessions_and_requests]
(
	[collection_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[active_sessions_and_requests]  WITH CHECK ADD  CONSTRAINT [FK_active_sessions_and_requests_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[active_sessions_and_requests] CHECK CONSTRAINT [FK_active_sessions_and_requests_snapshots_internal]
GO
ALTER TABLE [snapshots].[active_sessions_and_requests]  WITH CHECK ADD  CONSTRAINT [CHK_active_sessions_and_requests_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[active_sessions_and_requests] CHECK CONSTRAINT [CHK_active_sessions_and_requests_check_operator]
GO
