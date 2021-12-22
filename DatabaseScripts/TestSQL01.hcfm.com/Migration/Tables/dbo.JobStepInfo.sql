/* CreateDate: 05/13/2018 20:48:24.637 , ModifyDate: 05/13/2018 20:48:24.637 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobStepInfo](
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgentJob] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Command] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommandExecutionSuccessCode] [int] NULL,
	[DatabaseName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseUserName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ID] [int] NULL,
	[JobStepFlags] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastRunDate] [datetime2](7) NULL,
	[LastRunDuration] [int] NULL,
	[LastRunOutcome] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastRunRetries] [int] NULL,
	[OnFailAction] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnFailStep] [int] NULL,
	[OnSuccessAction] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnSuccessStep] [int] NULL,
	[OSRunPriority] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OutputFileName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProxyName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RetryAttempts] [int] NULL,
	[RetryInterval] [int] NULL,
	[Server] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SubSystem] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Urn] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Properties] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseEngineType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseEngineEdition] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExecutionManager] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserData] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
