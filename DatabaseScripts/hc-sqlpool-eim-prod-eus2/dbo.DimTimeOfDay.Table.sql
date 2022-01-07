/****** Object:  Table [dbo].[DimTimeOfDay]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimTimeOfDay]
(
	[TimeOfDayKey] [int] NULL,
	[Time] [varchar](12) NULL,
	[Time24] [varchar](8) NULL,
	[Hour] [smallint] NULL,
	[HourName] [varchar](10) NULL,
	[Minute] [smallint] NULL,
	[MinuteKey] [smallint] NULL,
	[MinuteName] [varchar](20) NULL,
	[Second] [smallint] NULL,
	[Hour24] [smallint] NULL,
	[AM] [char](2) NULL,
	[Time24HM] [varchar](20) NULL,
	[HourC] [smallint] NULL,
	[MinuteC] [smallint] NULL,
	[30MinuteInterval] [smallint] NULL,
	[DayPart] [varchar](20) NULL,
	[TimeNumber] [int] NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[SourceSystem] [varchar](50) NULL
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
