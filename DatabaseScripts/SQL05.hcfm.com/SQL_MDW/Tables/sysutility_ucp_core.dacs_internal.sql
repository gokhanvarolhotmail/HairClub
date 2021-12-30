/* CreateDate: 01/03/2014 07:07:53.760 , ModifyDate: 01/03/2014 07:07:53.760 */
GO
CREATE TABLE [sysutility_ucp_core].[dacs_internal](
	[dac_id] [int] IDENTITY(1,1) NOT NULL,
	[server_instance_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dac_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[urn] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[powershell_path] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[physical_server_name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dac_deploy_date] [datetime] NULL,
	[dac_description] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dac_percent_total_cpu_utilization] [real] NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_dacs_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[server_instance_name] ASC,
	[dac_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'dacs_internal'
GO
