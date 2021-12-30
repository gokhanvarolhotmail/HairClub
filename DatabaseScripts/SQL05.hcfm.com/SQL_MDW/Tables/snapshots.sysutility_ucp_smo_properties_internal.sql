/* CreateDate: 01/03/2014 07:07:53.483 , ModifyDate: 01/03/2014 07:07:53.530 */
GO
CREATE TABLE [snapshots].[sysutility_ucp_smo_properties_internal](
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_type] [int] NULL,
	[urn] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_value] [sql_variant] NULL,
	[batch_time] [datetimeoffset](7) NULL,
	[collection_time] [datetimeoffset](7) NULL,
	[snapshot_id] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE CLUSTERED INDEX [CI_sysutility_ucp_smo_properties_internal] ON [snapshots].[sysutility_ucp_smo_properties_internal]
(
	[server_instance_name] ASC,
	[batch_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_sysutility_ucp_smo_properties_internal] ON [snapshots].[sysutility_ucp_smo_properties_internal]
(
	[snapshot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[sysutility_ucp_smo_properties_internal]  WITH CHECK ADD  CONSTRAINT [FK_sysutility_ucp_smo_properties_internal_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[sysutility_ucp_smo_properties_internal] CHECK CONSTRAINT [FK_sysutility_ucp_smo_properties_internal_snapshots_internal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'LIVE' , @level0type=N'SCHEMA',@level0name=N'snapshots', @level1type=N'TABLE',@level1name=N'sysutility_ucp_smo_properties_internal'
GO
