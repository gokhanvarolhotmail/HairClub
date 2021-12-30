/* CreateDate: 01/03/2014 07:07:47.130 , ModifyDate: 01/03/2014 07:07:47.700 */
GO
CREATE TABLE [snapshots].[trace_info](
	[trace_info_id] [int] IDENTITY(1,1) NOT NULL,
	[source_id] [int] NOT NULL,
	[collection_item_id] [int] NOT NULL,
	[last_snapshot_id] [int] NULL,
	[start_time] [datetime] NULL,
	[last_event_sequence] [bigint] NULL,
	[is_running] [bit] NULL,
	[event_count] [bigint] NULL,
	[dropped_event_count] [int] NULL,
 CONSTRAINT [PK_trace_info] PRIMARY KEY CLUSTERED
(
	[trace_info_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[trace_info]  WITH CHECK ADD  CONSTRAINT [FK_trace_info_last_snapshot_id] FOREIGN KEY([last_snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[trace_info] CHECK CONSTRAINT [FK_trace_info_last_snapshot_id]
GO
ALTER TABLE [snapshots].[trace_info]  WITH CHECK ADD  CONSTRAINT [FK_trace_info_source_id] FOREIGN KEY([source_id])
REFERENCES [core].[source_info_internal] ([source_id])
GO
ALTER TABLE [snapshots].[trace_info] CHECK CONSTRAINT [FK_trace_info_source_id]
GO
