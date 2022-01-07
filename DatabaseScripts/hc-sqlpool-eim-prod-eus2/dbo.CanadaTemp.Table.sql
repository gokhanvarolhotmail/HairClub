/****** Object:  Table [dbo].[CanadaTemp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[CanadaTemp]
(
	[Column-0] [varchar](8000) NULL,
	[Place] [varchar](8000) NULL,
	[Code] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[Admin1] [varchar](8000) NULL,
	[Admin2] [varchar](8000) NULL,
	[Admin3] [varchar](8000) NULL,
	[Long] [varchar](8000) NULL,
	[Lat] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Local/Dimension/Canada.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
