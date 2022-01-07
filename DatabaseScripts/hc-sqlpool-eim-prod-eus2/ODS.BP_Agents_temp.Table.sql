/****** Object:  Table [ODS].[BP_Agents_temp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[BP_Agents_temp]
(
	[login_id] [varchar](8000) NULL,
	[first_name] [varchar](8000) NULL,
	[last_name] [varchar](8000) NULL,
	[team_name] [varchar](8000) NULL,
	[agent_country] [varchar](8000) NULL,
	[agent_city] [varchar](8000) NULL,
	[rank] [varchar](8000) NULL,
	[start_time] [datetime2](7) NULL,
	[end_time] [datetime2](7) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Brightpattern/Agents/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
