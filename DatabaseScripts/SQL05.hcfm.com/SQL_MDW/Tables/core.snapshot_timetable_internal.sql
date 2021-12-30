/* CreateDate: 01/03/2014 07:07:45.940 , ModifyDate: 01/03/2014 07:07:46.077 */
GO
CREATE TABLE [core].[snapshot_timetable_internal](
	[snapshot_time_id] [int] IDENTITY(1,1) NOT NULL,
	[snapshot_time] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_snapshots_timetable_internal] PRIMARY KEY CLUSTERED
(
	[snapshot_time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_snapshot_time] ON [core].[snapshot_timetable_internal]
(
	[snapshot_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
