/* CreateDate: 01/03/2014 07:07:50.023 , ModifyDate: 01/03/2014 07:07:50.043 */
GO
CREATE TABLE [snapshots].[disk_usage](
	[dbsize] [bigint] NULL,
	[logsize] [bigint] NULL,
	[ftsize] [bigint] NULL,
	[reservedpages] [bigint] NULL,
	[usedpages] [bigint] NULL,
	[pages] [bigint] NULL,
	[database_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_disk_usage] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[disk_usage]  WITH CHECK ADD  CONSTRAINT [FK_disk_usage_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[disk_usage] CHECK CONSTRAINT [FK_disk_usage_snapshots_internal]
GO
ALTER TABLE [snapshots].[disk_usage]  WITH CHECK ADD  CONSTRAINT [CHK_disk_usage_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[disk_usage] CHECK CONSTRAINT [CHK_disk_usage_check_operator]
GO
