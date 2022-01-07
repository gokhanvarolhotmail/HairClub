/****** Object:  Table [ODS].[DimTimeOfDay]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[DimTimeOfDay]
(
	[TimeOfDayKey] [int] NULL,
	[Time] [varchar](12) NULL,
	[Time24] [varchar](8) NULL,
	[Time24HM] [varchar](8) NULL,
	[Hour] [smallint] NULL,
	[HourC] [smallint] NULL,
	[HourName] [varchar](10) NULL,
	[Minute] [smallint] NULL,
	[MinuteC] [smallint] NULL,
	[MinuteKey] [smallint] NULL,
	[MinuteName] [varchar](20) NULL,
	[Second] [smallint] NULL,
	[Hour24] [smallint] NULL,
	[AM] [char](2) NULL,
	[30MinuteInterval] [int] NULL,
	[DayPart] [varchar](30) NULL,
	[TimeNumber] [int] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[TimeOfDayKey] ASC
	)
)
GO
