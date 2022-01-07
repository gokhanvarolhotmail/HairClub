/****** Object:  Table [dbo].[CNCT_lkpLanguage]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[CNCT_lkpLanguage]
(
	[LanguageID] [int] NULL,
	[LanguageSortOrder] [int] NULL,
	[LanguageDescription] [varchar](8000) NULL,
	[LanguageDescriptionShort] [varchar](8000) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](8000) NULL,
	[OnContactLanguageCode] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Connect/Language/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
