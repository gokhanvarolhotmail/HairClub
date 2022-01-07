/****** Object:  Table [ODS].[FeeTemp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[FeeTemp]
(
	[DataStream] [varchar](8000) NULL,
	[Month] [varchar](8000) NULL,
	[Fee] [varchar](8000) NULL,
	[InitialDate] [varchar](8000) NULL,
	[FinalDate] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'MarketingAgencies/ManualUpload/MarketingFeeRates/Hairclub Data Stream Fee Rates.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
