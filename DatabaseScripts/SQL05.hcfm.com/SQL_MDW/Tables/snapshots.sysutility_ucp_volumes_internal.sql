/* CreateDate: 01/03/2014 07:07:53.657 , ModifyDate: 01/03/2014 07:07:53.683 */
GO
CREATE TABLE [snapshots].[sysutility_ucp_volumes_internal](
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[virtual_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[volume_device_id] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[volume_name] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[total_space_available] [real] NULL,
	[free_space] [real] NULL,
	[batch_time] [datetimeoffset](7) NOT NULL,
	[collection_time] [datetimeoffset](7) NULL,
	[snapshot_id] [int] NULL,
 CONSTRAINT [PK_sysutility_volumes_info_internal] PRIMARY KEY CLUSTERED
(
	[server_instance_name] ASC,
	[batch_time] ASC,
	[volume_device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_sysutility_ucp_volumes_internal] ON [snapshots].[sysutility_ucp_volumes_internal]
(
	[snapshot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[sysutility_ucp_volumes_internal]  WITH CHECK ADD  CONSTRAINT [FK_volumes_info_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[sysutility_ucp_volumes_internal] CHECK CONSTRAINT [FK_volumes_info_snapshots_internal]
GO
ALTER TABLE [snapshots].[sysutility_ucp_volumes_internal]  WITH CHECK ADD  CONSTRAINT [CHK_check_operator_D79F8519-D243-4176-8291-6F3BA8EF776D] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[sysutility_ucp_volumes_internal] CHECK CONSTRAINT [CHK_check_operator_D79F8519-D243-4176-8291-6F3BA8EF776D]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'LIVE' , @level0type=N'SCHEMA',@level0name=N'snapshots', @level1type=N'TABLE',@level1name=N'sysutility_ucp_volumes_internal'
GO
