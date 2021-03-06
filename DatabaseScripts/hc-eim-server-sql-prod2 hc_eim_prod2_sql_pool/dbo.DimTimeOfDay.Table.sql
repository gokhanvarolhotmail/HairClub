/****** Object:  Table [dbo].[DimTimeOfDay]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimTimeOfDay]
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
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
