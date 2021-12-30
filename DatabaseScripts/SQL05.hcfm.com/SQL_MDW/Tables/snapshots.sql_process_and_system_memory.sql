/* CreateDate: 01/03/2014 07:07:49.757 , ModifyDate: 01/03/2014 07:07:49.863 */
GO
CREATE TABLE [snapshots].[sql_process_and_system_memory](
	[sql_physical_memory_in_use_kb] [bigint] NOT NULL,
	[sql_large_page_allocations_kb] [bigint] NOT NULL,
	[sql_locked_page_allocations_kb] [bigint] NOT NULL,
	[sql_total_virtual_address_space_kb] [bigint] NOT NULL,
	[sql_virtual_address_space_reserved_kb] [bigint] NOT NULL,
	[sql_virtual_address_space_committed_kb] [bigint] NOT NULL,
	[sql_virtual_address_space_available_kb] [bigint] NOT NULL,
	[sql_page_fault_count] [bigint] NOT NULL,
	[sql_memory_utilization_percentage] [int] NOT NULL,
	[sql_available_commit_limit_kb] [bigint] NOT NULL,
	[sql_process_physical_memory_low] [bit] NOT NULL,
	[sql_process_virtual_memory_low] [bit] NOT NULL,
	[system_total_physical_memory_kb] [bigint] NOT NULL,
	[system_available_physical_memory_kb] [bigint] NOT NULL,
	[system_total_page_file_kb] [bigint] NOT NULL,
	[system_available_page_file_kb] [bigint] NOT NULL,
	[system_cache_kb] [bigint] NOT NULL,
	[system_kernel_paged_pool_kb] [bigint] NOT NULL,
	[system_kernel_nonpaged_pool_kb] [bigint] NOT NULL,
	[system_high_memory_signal_state] [bit] NOT NULL,
	[system_low_memory_signal_state] [bit] NOT NULL,
	[bpool_commit_target] [bigint] NOT NULL,
	[bpool_committed] [bigint] NOT NULL,
	[bpool_visible] [bigint] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_sql_process_and_system_memory] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[sql_process_and_system_memory]  WITH CHECK ADD  CONSTRAINT [FK_sql_process_and_system_memory_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[sql_process_and_system_memory] CHECK CONSTRAINT [FK_sql_process_and_system_memory_internal]
GO
ALTER TABLE [snapshots].[sql_process_and_system_memory]  WITH CHECK ADD  CONSTRAINT [CHK_sql_process_and_system_memory_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[sql_process_and_system_memory] CHECK CONSTRAINT [CHK_sql_process_and_system_memory_check_operator]
GO
