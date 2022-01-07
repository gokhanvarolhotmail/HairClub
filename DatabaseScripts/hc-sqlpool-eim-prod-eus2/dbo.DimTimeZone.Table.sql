/****** Object:  Table [dbo].[DimTimeZone]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimTimeZone]
(
	[TimeZoneKey] [int] IDENTITY(1,1) NOT NULL,
	[TimeZoneID] [int] NULL,
	[TimeZoneSortOrder] [int] NULL,
	[TimeZoneDescription] [varchar](8000) NULL,
	[TimeZoneDescriptionShort] [varchar](8000) NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[TimeZoneKey] ASC
	)
)
GO
