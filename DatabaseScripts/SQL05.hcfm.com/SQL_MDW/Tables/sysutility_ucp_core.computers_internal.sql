/* CreateDate: 01/03/2014 07:07:53.800 , ModifyDate: 01/03/2014 07:07:53.800 */
GO
CREATE TABLE [sysutility_ucp_core].[computers_internal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[virtual_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[is_clustered_server] [int] NULL,
	[num_processors] [int] NULL,
	[cpu_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_caption] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_family] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_architecture] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cpu_max_clock_speed] [decimal](10, 0) NULL,
	[cpu_clock_speed] [decimal](10, 0) NULL,
	[l2_cache_size] [decimal](10, 0) NULL,
	[l3_cache_size] [decimal](10, 0) NULL,
	[percent_total_cpu_utilization] [real] NULL,
	[urn] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[powershell_path] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_computers_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[physical_server_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'computers_internal'
GO
