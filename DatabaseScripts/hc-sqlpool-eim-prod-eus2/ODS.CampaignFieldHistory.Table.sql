/****** Object:  Table [ODS].[CampaignFieldHistory]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[CampaignFieldHistory]
(
	[Id] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](8000) NULL,
	[CreatedById] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[Field] [varchar](8000) NULL,
	[OldValue] [varchar](8000) NULL,
	[NewValue] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Test_files/CampaignFieldHistory.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
