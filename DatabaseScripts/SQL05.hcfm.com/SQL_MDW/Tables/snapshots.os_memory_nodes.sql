/* CreateDate: 01/03/2014 07:07:49.470 , ModifyDate: 01/03/2014 07:07:49.510 */
GO
CREATE TABLE [snapshots].[os_memory_nodes](
	[memory_node_id] [smallint] NOT NULL,
	[virtual_address_space_reserved_kb] [bigint] NOT NULL,
	[virtual_address_space_committed_kb] [bigint] NOT NULL,
	[locked_page_allocations_kb] [bigint] NOT NULL,
	[single_pages_kb] [bigint] NOT NULL,
	[multi_pages_kb] [bigint] NOT NULL,
	[shared_memory_reserved_kb] [bigint] NOT NULL,
	[shared_memory_committed_kb] [bigint] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_os_memory_nodes] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[memory_node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[os_memory_nodes]  WITH CHECK ADD  CONSTRAINT [FK_os_memory_nodes_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[os_memory_nodes] CHECK CONSTRAINT [FK_os_memory_nodes_snapshots_internal]
GO
ALTER TABLE [snapshots].[os_memory_nodes]  WITH CHECK ADD  CONSTRAINT [CHK_os_memory_nodes_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[os_memory_nodes] CHECK CONSTRAINT [CHK_os_memory_nodes_check_operator]
GO
