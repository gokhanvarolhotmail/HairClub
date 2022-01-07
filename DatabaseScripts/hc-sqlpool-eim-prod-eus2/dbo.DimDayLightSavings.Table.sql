/****** Object:  Table [dbo].[DimDayLightSavings]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDayLightSavings]
(
	[DaylightSavingsKey] [int] IDENTITY(1,1) NOT NULL,
	[DaylightSavingsID] [int] NULL,
	[Year] [int] NULL,
	[DSTStartDate] [datetime] NULL,
	[DSTEndDate] [datetime] NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[DaylightSavingsKey] ASC
	)
)
GO
