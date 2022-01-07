/****** Object:  Table [dbo].[DimAgents]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAgents]
(
	[login_id] [varchar](255) NULL,
	[first_name] [varchar](255) NULL,
	[last_name] [varchar](255) NULL,
	[team_name] [varchar](255) NULL,
	[agent_country] [varchar](255) NULL,
	[agent_city] [varchar](255) NULL,
	[rank] [varchar](255) NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[login_id] ASC
	)
)
GO
