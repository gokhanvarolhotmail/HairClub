/* CreateDate: 01/03/2014 07:07:46.873 , ModifyDate: 01/03/2014 07:07:47.030 */
GO
CREATE TABLE [snapshots].[performance_counter_values](
	[performance_counter_instance_id] [int] NOT NULL,
	[snapshot_id] [int] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[formatted_value] [float] NOT NULL,
	[raw_value_first] [bigint] NOT NULL,
	[raw_value_second] [bigint] NULL,
 CONSTRAINT [PK_performance_counter_values] PRIMARY KEY CLUSTERED
(
	[performance_counter_instance_id] ASC,
	[snapshot_id] ASC,
	[collection_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_performance_counter_values1] ON [snapshots].[performance_counter_values]
(
	[snapshot_id] ASC,
	[performance_counter_instance_id] ASC,
	[collection_time] ASC
)
INCLUDE([formatted_value]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[performance_counter_values]  WITH CHECK ADD  CONSTRAINT [FK_performance_counter_values_snapshot_id] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[performance_counter_values] CHECK CONSTRAINT [FK_performance_counter_values_snapshot_id]
GO
ALTER TABLE [snapshots].[performance_counter_values]  WITH CHECK ADD  CONSTRAINT [CHK_performance_counter_values_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[performance_counter_values] CHECK CONSTRAINT [CHK_performance_counter_values_check_operator]
GO
