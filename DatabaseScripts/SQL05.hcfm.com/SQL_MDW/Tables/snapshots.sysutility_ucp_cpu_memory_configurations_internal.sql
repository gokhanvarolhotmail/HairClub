/* CreateDate: 01/03/2014 07:07:53.560 , ModifyDate: 01/03/2014 07:07:53.590 */
GO
CREATE TABLE [snapshots].[sysutility_ucp_cpu_memory_configurations_internal](
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[is_clustered_server] [smallint] NULL,
	[virtual_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[num_processors] [int] NULL,
	[server_processor_usage] [real] NULL,
	[instance_processor_usage] [real] NULL,
	[cpu_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_caption] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_family] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_architecture] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_max_clock_speed] [decimal](10, 0) NULL,
	[cpu_clock_speed] [decimal](10, 0) NULL,
	[l2_cache_size] [decimal](10, 0) NULL,
	[l3_cache_size] [decimal](10, 0) NULL,
	[batch_time] [datetimeoffset](7) NOT NULL,
	[collection_time] [datetimeoffset](7) NULL,
	[snapshot_id] [int] NULL,
 CONSTRAINT [PK_sysutility_cpu_memory_related_info_internal_clustered] PRIMARY KEY CLUSTERED
(
	[server_instance_name] ASC,
	[batch_time] ASC,
	[physical_server_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_sysutility_ucp_cpu_memory_configurations_internal] ON [snapshots].[sysutility_ucp_cpu_memory_configurations_internal]
(
	[snapshot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[sysutility_ucp_cpu_memory_configurations_internal]  WITH CHECK ADD  CONSTRAINT [FK_sysutility_cpu_memory_related_info_snapshots_internal_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[sysutility_ucp_cpu_memory_configurations_internal] CHECK CONSTRAINT [FK_sysutility_cpu_memory_related_info_snapshots_internal_snapshots_internal]
GO
ALTER TABLE [snapshots].[sysutility_ucp_cpu_memory_configurations_internal]  WITH CHECK ADD  CONSTRAINT [CHK_check_operator_9DAA9ACC-F1E1-44F8-8B74-D081734E5F39] CHECK  (([core].[fn_check_operator]([snapshot_id])=(1)))
GO
ALTER TABLE [snapshots].[sysutility_ucp_cpu_memory_configurations_internal] CHECK CONSTRAINT [CHK_check_operator_9DAA9ACC-F1E1-44F8-8B74-D081734E5F39]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'LIVE' , @level0type=N'SCHEMA',@level0name=N'snapshots', @level1type=N'TABLE',@level1name=N'sysutility_ucp_cpu_memory_configurations_internal'
GO
