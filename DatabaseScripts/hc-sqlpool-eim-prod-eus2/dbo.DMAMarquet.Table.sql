/****** Object:  Table [dbo].[DMAMarquet]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[DMAMarquet]
(
	[DMACode] [bigint] NULL,
	[Description] [varchar](8000) NULL,
	[DMAMarketRegion] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Local/Dimension/DimDMAMarket.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
