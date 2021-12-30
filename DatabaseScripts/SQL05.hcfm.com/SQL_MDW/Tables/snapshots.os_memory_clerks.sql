/* CreateDate: 01/03/2014 07:07:49.870 , ModifyDate: 01/03/2014 07:07:49.917 */
GO
CREATE TABLE [snapshots].[os_memory_clerks](
	[type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[memory_node_id] [smallint] NULL,
	[single_pages_kb] [bigint] NULL,
	[multi_pages_kb] [bigint] NULL,
	[virtual_memory_reserved_kb] [bigint] NULL,
	[virtual_memory_committed_kb] [bigint] NULL,
	[awe_allocated_kb] [bigint] NULL,
	[shared_memory_reserved_kb] [bigint] NULL,
	[shared_memory_committed_kb] [bigint] NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIDX_os_memory_clerks] ON [snapshots].[os_memory_clerks]
(
	[snapshot_id] ASC,
	[collection_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[os_memory_clerks]  WITH CHECK ADD  CONSTRAINT [FK_os_memory_clerks_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[os_memory_clerks] CHECK CONSTRAINT [FK_os_memory_clerks_snapshots_internal]
GO
ALTER TABLE [snapshots].[os_memory_clerks]  WITH CHECK ADD  CONSTRAINT [CHK_os_memory_clerks_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[os_memory_clerks] CHECK CONSTRAINT [CHK_os_memory_clerks_check_operator]
GO
