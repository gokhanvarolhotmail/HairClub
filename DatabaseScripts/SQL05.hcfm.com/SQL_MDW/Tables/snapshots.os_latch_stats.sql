/* CreateDate: 01/03/2014 07:07:48.993 , ModifyDate: 01/03/2014 07:07:49.060 */
GO
CREATE TABLE [snapshots].[os_latch_stats](
	[latch_class] [nvarchar](45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[waiting_requests_count] [bigint] NOT NULL,
	[wait_time_ms] [bigint] NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_os_latch_stats] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[latch_class] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[os_latch_stats]  WITH CHECK ADD  CONSTRAINT [FK_os_latch_stats_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[os_latch_stats] CHECK CONSTRAINT [FK_os_latch_stats_snapshots_internal]
GO
ALTER TABLE [snapshots].[os_latch_stats]  WITH CHECK ADD  CONSTRAINT [CHK_os_latch_stats_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[os_latch_stats] CHECK CONSTRAINT [CHK_os_latch_stats_check_operator]
GO
