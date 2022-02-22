/****** Object:  Table [dbo].[DimAgentDisposition]    Script Date: 2/22/2022 9:20:32 AM ******/
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
