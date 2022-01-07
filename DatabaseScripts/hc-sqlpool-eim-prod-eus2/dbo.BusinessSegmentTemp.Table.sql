/****** Object:  Table [dbo].[BusinessSegmentTemp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[BusinessSegmentTemp]
(
	[BusinessSegmentID] [int] NULL,
	[BusinessSegmentSortOrder] [int] NULL,
	[BusinessSegmentDescription] [varchar](8000) NULL,
	[BusinessSegmentDescriptionShort] [varchar](8000) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Connect/BusinessSegment/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
