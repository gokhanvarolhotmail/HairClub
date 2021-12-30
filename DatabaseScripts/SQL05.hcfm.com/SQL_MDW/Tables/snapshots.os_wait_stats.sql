/* CreateDate: 01/03/2014 07:07:48.783 , ModifyDate: 01/03/2014 07:07:48.973 */
GO
CREATE TABLE [snapshots].[os_wait_stats](
	[wait_type] [nvarchar](45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[waiting_tasks_count] [bigint] NOT NULL,
	[wait_time_ms] [bigint] NOT NULL,
	[signal_wait_time_ms] [bigint] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_os_wait_stats] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[wait_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_os_wait_stats1] ON [snapshots].[os_wait_stats]
(
	[collection_time] DESC,
	[snapshot_id] ASC
)
INCLUDE([wait_type],[signal_wait_time_ms]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_os_wait_stats2] ON [snapshots].[os_wait_stats]
(
	[snapshot_id] ASC,
	[collection_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[os_wait_stats]  WITH CHECK ADD  CONSTRAINT [FK_os_wait_stats_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[os_wait_stats] CHECK CONSTRAINT [FK_os_wait_stats_snapshots_internal]
GO
ALTER TABLE [snapshots].[os_wait_stats]  WITH CHECK ADD  CONSTRAINT [CHK_os_wait_stats_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[os_wait_stats] CHECK CONSTRAINT [CHK_os_wait_stats_check_operator]
GO
