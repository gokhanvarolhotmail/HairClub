/* CreateDate: 01/03/2014 07:07:50.050 , ModifyDate: 01/03/2014 07:07:50.090 */
GO
CREATE TABLE [snapshots].[log_usage](
	[database_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[log_size_mb] [float] NULL,
	[log_space_used] [float] NULL,
	[status] [int] NULL,
	[collection_time] [datetimeoffset](7) NOT NULL,
	[snapshot_id] [int] NOT NULL,
 CONSTRAINT [PK_log_usage] PRIMARY KEY CLUSTERED
(
	[snapshot_id] ASC,
	[collection_time] ASC,
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[log_usage]  WITH CHECK ADD  CONSTRAINT [FK_log_usage_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[log_usage] CHECK CONSTRAINT [FK_log_usage_snapshots_internal]
GO
ALTER TABLE [snapshots].[log_usage]  WITH CHECK ADD  CONSTRAINT [CHK_log_usage_check_operator] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[log_usage] CHECK CONSTRAINT [CHK_log_usage_check_operator]
GO
