/* CreateDate: 01/03/2014 07:07:53.277 , ModifyDate: 01/03/2014 07:07:53.423 */
GO
CREATE TABLE [snapshots].[sysutility_ucp_batch_manifests_internal](
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[batch_time] [datetimeoffset](7) NOT NULL,
	[parameter_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parameter_value] [sql_variant] NULL,
	[collection_time] [datetimeoffset](7) NULL,
	[snapshot_id] [int] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_sysutility_ucp_batch_manifests_internal] ON [snapshots].[sysutility_ucp_batch_manifests_internal]
(
	[snapshot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[sysutility_ucp_batch_manifests_internal]  WITH CHECK ADD  CONSTRAINT [FK_sysutility_ucp_batch_manifests_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[sysutility_ucp_batch_manifests_internal] CHECK CONSTRAINT [FK_sysutility_ucp_batch_manifests_internal]
GO
ALTER TABLE [snapshots].[sysutility_ucp_batch_manifests_internal]  WITH CHECK ADD  CONSTRAINT [CHK_check_operator_E4F8A95D-2C44-48B6-85BA-E78E47C7ACCE] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[sysutility_ucp_batch_manifests_internal] CHECK CONSTRAINT [CHK_check_operator_E4F8A95D-2C44-48B6-85BA-E78E47C7ACCE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'LIVE' , @level0type=N'SCHEMA',@level0name=N'snapshots', @level1type=N'TABLE',@level1name=N'sysutility_ucp_batch_manifests_internal'
GO
