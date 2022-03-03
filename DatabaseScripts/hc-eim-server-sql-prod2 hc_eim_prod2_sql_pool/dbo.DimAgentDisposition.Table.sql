/****** Object:  Table [dbo].[DimAgentDisposition]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAgentDisposition]
(
	[AgentDispositionKey] [int] IDENTITY(1,1) NOT NULL,
	[AgentDispositionName] [varchar](255) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[AgentDispositionKey] ASC
	)
)
GO
