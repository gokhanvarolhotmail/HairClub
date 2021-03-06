/****** Object:  Table [dbo].[DimTimeOfDay_temp]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[DimTimeOfDay_temp]
(
	[TimeOfDayKey] [int] NULL,
	[Time] [varchar](8000) NULL,
	[Time24] [varchar](8000) NULL,
	[Time24HM] [varchar](8000) NULL,
	[Hour] [int] NULL,
	[HourC] [int] NULL,
	[HourName] [varchar](8000) NULL,
	[Minute] [int] NULL,
	[MinuteC] [int] NULL,
	[MinuteKey] [int] NULL,
	[MinuteName] [varchar](8000) NULL,
	[Second] [int] NULL,
	[Hour24] [int] NULL,
	[AM] [varchar](8000) NULL,
	[30MinuteInterval] [int] NULL,
	[DayPart] [varchar](8000) NULL,
	[TimeNumber] [int] NULL
)
WITH (DATA_SOURCE = [hc-eim-file-system-bi-dev_steimdatalakedev_dfs_core_windows_net],LOCATION = N'GenericFiles/DimTimeOfDay.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
