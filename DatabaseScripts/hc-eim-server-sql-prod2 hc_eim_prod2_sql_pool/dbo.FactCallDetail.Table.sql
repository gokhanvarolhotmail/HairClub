/****** Object:  Table [dbo].[FactCallDetail]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCallDetail]
(
	[FactDateKey] [int] NULL,
	[FactTimeKey] [int] NULL,
	[FactDate] [datetime] NULL,
	[CallId] [varbinary](max) NULL,
	[CallMediaType] [varchar](200) NULL,
	[MediaKey] [int] NULL,
	[CallPkId] [varchar](50) NULL,
	[CallDate] [datetime] NULL,
	[CallIvrTime] [int] NULL,
	[CallQueueTime] [int] NULL,
	[CallPendingTime] [int] NULL,
	[CallTalkTime] [int] NULL,
	[CallHoldTime] [int] NULL,
	[CallHeld] [int] NULL,
	[CallMaxHold] [int] NULL,
	[CallAcwTime] [int] NULL,
	[CallDuration] [int] NULL,
	[ServiceName] [varchar](400) NULL,
	[ServiceKey] [int] NULL,
	[ScenarioName] [varchar](200) NULL,
	[ScenarioKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [varchar](50) NULL,
	[TaskId] [varchar](200) NULL,
	[IncommingSourceCode] [varchar](200) NULL,
	[SourceKey] [int] NULL,
	[CallType] [varchar](100) NULL,
	[CallTypeKey] [int] NULL,
	[AgentDisposition] [varchar](200) NULL,
	[AgentDispositionKey] [int] NULL,
	[AgentLogin] [varchar](100) NULL,
	[AgentKey] [int] NULL,
	[IsViableCall] [int] NULL,
	[IsProductiveCall] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
