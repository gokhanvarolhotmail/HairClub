/****** Object:  Table [dbo].[MA_OTTSpend]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[MA_OTTSpend]
(
	[Date] [varchar](8000) NULL,
	[Advertiser] [varchar](8000) NULL,
	[AdvertiserCurrencyCode] [varchar](8000) NULL,
	[Campaign] [varchar](8000) NULL,
	[AdGroup] [varchar](8000) NULL,
	[Creative] [varchar](8000) NULL,
	[Impressions] [varchar](8000) NULL,
	[CNSpend] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'MarketingAgencies/ManualUpload/3222021/Hair Club Spend 03.22.21.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
