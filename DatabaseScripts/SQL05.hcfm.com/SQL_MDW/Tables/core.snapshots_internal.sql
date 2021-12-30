/* CreateDate: 01/03/2014 07:07:46.030 , ModifyDate: 03/22/2017 21:30:21.560 */
GO
CREATE TABLE [core].[snapshots_internal](
	[snapshot_id] [int] IDENTITY(1,1) NOT NULL,
	[snapshot_time_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[log_id] [bigint] NOT NULL,
 CONSTRAINT [PK_snapshots_internal] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_snapshot_time_id] ON [core].[snapshots_internal]
(
	[snapshot_time_id] ASC,
	[source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [core].[snapshots_internal]  WITH CHECK ADD  CONSTRAINT [FK_snapshots_snapshots_timetable] FOREIGN KEY([snapshot_time_id])
REFERENCES [core].[snapshot_timetable_internal] ([snapshot_time_id])
GO
ALTER TABLE [core].[snapshots_internal] CHECK CONSTRAINT [FK_snapshots_snapshots_timetable]
GO
ALTER TABLE [core].[snapshots_internal]  WITH CHECK ADD  CONSTRAINT [FK_snapshots_source_info] FOREIGN KEY([source_id])
REFERENCES [core].[source_info_internal] ([source_id])
GO
ALTER TABLE [core].[snapshots_internal] CHECK CONSTRAINT [FK_snapshots_source_info]
GO
