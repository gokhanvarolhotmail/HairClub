/* CreateDate: 01/03/2014 07:07:53.430 , ModifyDate: 01/03/2014 07:07:53.467 */
GO
CREATE TABLE [snapshots].[sysutility_ucp_dac_collected_execution_statistics_internal](
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dac_db] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dac_deploy_date] [datetime] NULL,
	[dac_description] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dac_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[interval_start_time] [datetimeoffset](7) NULL,
	[interval_end_time] [datetimeoffset](7) NULL,
	[interval_cpu_time_ms] [bigint] NULL,
	[interval_cpu_pct] [real] NULL,
	[lifetime_cpu_time_ms] [bigint] NULL,
	[batch_time] [datetimeoffset](7) NOT NULL,
	[collection_time] [datetimeoffset](7) NULL,
	[snapshot_id] [int] NULL,
 CONSTRAINT [PK_sysutility_ucp_dac_collected_execution_statistics_internal] PRIMARY KEY CLUSTERED
(
	[server_instance_name] ASC,
	[batch_time] ASC,
	[dac_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_sysutility_ucp_dac_collected_execution_statistics_internal] ON [snapshots].[sysutility_ucp_dac_collected_execution_statistics_internal]
(
	[snapshot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[sysutility_ucp_dac_collected_execution_statistics_internal]  WITH CHECK ADD  CONSTRAINT [fk_dac_collected_execution_statistics_internal_snapshots_internal] FOREIGN KEY([snapshot_id])
REFERENCES [core].[snapshots_internal] ([snapshot_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[sysutility_ucp_dac_collected_execution_statistics_internal] CHECK CONSTRAINT [fk_dac_collected_execution_statistics_internal_snapshots_internal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'LIVE' , @level0type=N'SCHEMA',@level0name=N'snapshots', @level1type=N'TABLE',@level1name=N'sysutility_ucp_dac_collected_execution_statistics_internal'
GO
