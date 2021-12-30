/* CreateDate: 01/03/2014 07:07:49.303 , ModifyDate: 01/03/2014 07:07:49.447 */
GO
CREATE TABLE [snapshots].[os_schedulers](
	[parent_node_id] [int] NOT NULL,
	[scheduler_id] [int] NOT NULL,
	[cpu_id] [int] NOT NULL,
	[status] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[is_idle] [bit] NOT NULL,
	[preemptive_switches_count] [int] NOT NULL,
	[context_switches_count] [int] NOT NULL,
	[yield_count] [int] NOT NULL,
	[current_tasks_count] [int] NOT NULL,
	[runnable_tasks_count] [int] NOT NULL,
	[work_queue_count] [bigint] NOT NULL,
	[pending_disk_io_count] [int] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_os_schedulers] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[scheduler_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[os_schedulers]  WITH CHECK ADD  CONSTRAINT [FK_os_schedulers_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[os_schedulers] CHECK CONSTRAINT [FK_os_schedulers_snapshots_internal]
GO
ALTER TABLE [snapshots].[os_schedulers]  WITH CHECK ADD  CONSTRAINT [CHK_os_schedulers_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[os_schedulers] CHECK CONSTRAINT [CHK_os_schedulers_check_operator]
GO
