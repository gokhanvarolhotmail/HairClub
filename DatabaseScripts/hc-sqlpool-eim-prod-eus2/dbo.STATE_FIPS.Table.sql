/****** Object:  Table [dbo].[STATE_FIPS]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[STATE_FIPS]
(
	[Name] [varchar](8000) NULL,
	[FIPS State Numeric Code] [bigint] NULL,
	[Official USPS Code] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Local/Dimension/STATE_FIPS.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
