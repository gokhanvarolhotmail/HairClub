/****** Object:  Table [ODS].[DimDayLightSavings]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[DimDayLightSavings]
(
	[DaylightSavingsID] [int] NULL,
	[Year] [int] NULL,
	[DSTStartDate] [datetime] NULL,
	[DSTEndDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](100) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [varchar](100) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
