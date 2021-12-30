/* CreateDate: 01/03/2014 07:07:49.933 , ModifyDate: 01/03/2014 07:07:49.983 */
GO
CREATE TABLE [snapshots].[query_stats](
	[sql_handle] [varbinary](64) NOT NULL,
	[statement_start_offset] [int] NOT NULL,
	[statement_end_offset] [int] NOT NULL,
	[plan_generation_num] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NOT NULL,
	[creation_time] [datetimeoffset](7) NOT NULL,
	[last_execution_time] [datetimeoffset](7) NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[snapshot_execution_count] [bigint] NULL,
	[total_worker_time] [bigint] NOT NULL,
	[snapshot_worker_time] [bigint] NOT NULL,
	[min_worker_time] [bigint] NULL,
	[max_worker_time] [bigint] NOT NULL,
	[total_physical_reads] [bigint] NOT NULL,
	[snapshot_physical_reads] [bigint] NOT NULL,
	[min_physical_reads] [bigint] NULL,
	[max_physical_reads] [bigint] NOT NULL,
	[total_logical_writes] [bigint] NOT NULL,
	[snapshot_logical_writes] [bigint] NOT NULL,
	[min_logical_writes] [bigint] NULL,
	[max_logical_writes] [bigint] NOT NULL,
	[total_logical_reads] [bigint] NOT NULL,
	[snapshot_logical_reads] [bigint] NOT NULL,
	[min_logical_reads] [bigint] NULL,
	[max_logical_reads] [bigint] NOT NULL,
	[total_clr_time] [bigint] NULL,
	[snapshot_clr_time] [bigint] NULL,
	[min_clr_time] [bigint] NULL,
	[max_clr_time] [bigint] NULL,
	[total_elapsed_time] [bigint] NOT NULL,
	[snapshot_elapsed_time] [bigint] NOT NULL,
	[min_elapsed_time] [bigint] NULL,
	[max_elapsed_time] [bigint] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE CLUSTERED INDEX [CIDX_query_stats] ON [snapshots].[query_stats]
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[sql_handle] ASC,
	[statement_start_offset] ASC,
	[statement_end_offset] ASC,
	[plan_handle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[query_stats]  WITH CHECK ADD  CONSTRAINT [FK_query_stats_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[query_stats] CHECK CONSTRAINT [FK_query_stats_snapshots_internal]
GO
ALTER TABLE [snapshots].[query_stats]  WITH CHECK ADD  CONSTRAINT [CHK_query_stats_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[query_stats] CHECK CONSTRAINT [CHK_query_stats_check_operator]
GO
