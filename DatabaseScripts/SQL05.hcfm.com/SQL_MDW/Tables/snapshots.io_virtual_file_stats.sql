/* CreateDate: 01/03/2014 07:07:50.097 , ModifyDate: 01/03/2014 07:07:50.193 */
GO
CREATE TABLE [snapshots].[io_virtual_file_stats](
	[database_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[database_id] [int] NOT NULL,
	[logical_file_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_id] [int] NOT NULL,
	[type_desc] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_disk] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[num_of_reads] [bigint] NULL,
	[num_of_bytes_read] [bigint] NULL,
	[io_stall_read_ms] [bigint] NULL,
	[num_of_writes] [bigint] NULL,
	[num_of_bytes_written] [bigint] NULL,
	[io_stall_write_ms] [bigint] NULL,
	[size_on_disk_bytes] [bigint] NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_io_virtual_file_stats] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[logical_disk] ASC,
	[database_name] ASC,
	[file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[io_virtual_file_stats]  WITH CHECK ADD  CONSTRAINT [FK_io_virtual_file_stats] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[io_virtual_file_stats] CHECK CONSTRAINT [FK_io_virtual_file_stats]
GO
ALTER TABLE [snapshots].[io_virtual_file_stats]  WITH CHECK ADD  CONSTRAINT [CHK_io_virtual_file_stats_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[io_virtual_file_stats] CHECK CONSTRAINT [CHK_io_virtual_file_stats_check_operator]
GO
