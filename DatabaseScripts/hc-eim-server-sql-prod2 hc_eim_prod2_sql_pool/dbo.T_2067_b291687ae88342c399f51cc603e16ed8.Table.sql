/****** Object:  Table [dbo].[T_2067_b291687ae88342c399f51cc603e16ed8]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2067_b291687ae88342c399f51cc603e16ed8]
(
	[FactDateKey] [int] NULL,
	[FactTimeKey] [int] NULL,
	[FactDate] [datetime2](7) NULL,
	[CallId] [varbinary](max) NULL,
	[CallMediaType] [nvarchar](max) NULL,
	[MediaKey] [int] NULL,
	[CallPkId] [nvarchar](max) NULL,
	[CallDate] [datetime2](7) NULL,
	[CallIvrTime] [int] NULL,
	[CallQueueTime] [int] NULL,
	[CallPendingTime] [int] NULL,
	[CallTalkTime] [int] NULL,
	[CallHoldTime] [int] NULL,
	[CallHeld] [int] NULL,
	[CallMaxHold] [int] NULL,
	[CallAcwTime] [int] NULL,
	[CallDuration] [int] NULL,
	[ServiceName] [nvarchar](max) NULL,
	[ServiceKey] [int] NULL,
	[ScenarioName] [nvarchar](max) NULL,
	[ScenarioKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](max) NULL,
	[TaskId] [nvarchar](max) NULL,
	[IncommingSourceCode] [nvarchar](max) NULL,
	[SourceKey] [int] NULL,
	[CallType] [nvarchar](max) NULL,
	[CallTypeKey] [int] NULL,
	[AgentDisposition] [nvarchar](max) NULL,
	[AgentDispositionKey] [int] NULL,
	[AgentLogin] [nvarchar](max) NULL,
	[AgentKey] [int] NULL,
	[IsViableCall] [int] NULL,
	[IsProductiveCall] [int] NULL,
	[rc9561193f360461aba8791b99dfa298a] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
