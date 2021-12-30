/* CreateDate: 01/03/2014 07:07:54.150 , ModifyDate: 01/03/2014 07:07:54.150 */
GO
CREATE TABLE [sysutility_ucp_core].[cpu_utilization_internal](
	[processing_time] [datetimeoffset](7) NOT NULL,
	[aggregation_type] [sysutility_ucp_core].[AggregationType] NOT NULL,
	[object_type] [sysutility_ucp_core].[ObjectType] NOT NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[database_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[percent_total_cpu_utilization] [real] NULL,
 CONSTRAINT [pk_cpu_utilization_internal] PRIMARY KEY CLUSTERED
(
	[aggregation_type] ASC,
	[processing_time] ASC,
	[object_type] ASC,
	[physical_server_name] ASC,
	[server_instance_name] ASC,
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [sysutility_ucp_core].[cpu_utilization_internal] ADD  DEFAULT (N'') FOR [physical_server_name]
GO
ALTER TABLE [sysutility_ucp_core].[cpu_utilization_internal] ADD  DEFAULT (N'') FOR [server_instance_name]
GO
ALTER TABLE [sysutility_ucp_core].[cpu_utilization_internal] ADD  DEFAULT (N'') FOR [database_name]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'MEASURE' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'cpu_utilization_internal'
GO
