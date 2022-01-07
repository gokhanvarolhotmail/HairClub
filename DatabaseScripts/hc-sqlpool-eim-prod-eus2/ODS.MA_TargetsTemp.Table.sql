/****** Object:  Table [ODS].[MA_TargetsTemp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[MA_TargetsTemp]
(
	[Date] [varchar](8000) NULL,
	[Month] [varchar](8000) NULL,
	[BudgetType] [varchar](8000) NULL,
	[Agency] [varchar](8000) NULL,
	[Channel] [varchar](8000) NULL,
	[Medium] [varchar](8000) NULL,
	[Source] [varchar](8000) NULL,
	[Budget] [varchar](8000) NULL,
	[Location] [varchar](8000) NULL,
	[BudgetAmount] [varchar](8000) NULL,
	[Tareget_Leads] [varchar](8000) NULL,
	[CurrencyConversion] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'MarketingAgencies/ManualUpload/Targets/Hairclub Budget Template - May - 20210504.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
