/****** Object:  Table [dbo].[FactInteraction]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactInteraction]
(
	[FactDate] [datetime] NULL,
	[TaskId] [nvarchar](max) NULL,
	[TaskSubject] [nvarchar](max) NULL,
	[TaskStatusKey] [int] NULL,
	[TaskStatus] [nvarchar](max) NULL,
	[TaskPriority] [nvarchar](max) NULL,
	[IsHighPriority] [bit] NULL,
	[Description] [nvarchar](max) NULL,
	[ActivityCost] [decimal](18, 3) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](max) NULL,
	[CustomerId] [nvarchar](max) NULL,
	[AccountId] [nvarchar](max) NULL,
	[TaskTypeKey] [int] NULL,
	[TaskType] [nvarchar](max) NULL,
	[CampaignKey] [int] NULL,
	[TaskCampaignKey] [nvarchar](max) NULL,
	[ResultKey] [int] NULL,
	[TaskResult] [nvarchar](max) NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [nvarchar](max) NULL,
	[FunnelStepKey] [int] NULL,
	[ActionKey] [int] NULL,
	[TaskAction] [nvarchar](max) NULL,
	[ActivityTypeKey] [int] NULL,
	[ActivityType] [nvarchar](max) NULL,
	[ActivityDateKey] [int] NULL,
	[ActivityDate] [date] NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedDate] [date] NULL,
	[AppointmentDate] [date] NULL,
	[CallBackDate] [date] NULL,
	[DeviceType] [nvarchar](max) NULL,
	[ActivitySource] [nvarchar](max) NULL,
	[UniqueTaskId] [nvarchar](max) NULL,
	[PromotionCode] [nvarchar](max) NULL,
	[PromotionKey] [int] NULL,
	[DWH_LoadDate] [datetime2](7) NULL,
	[CreateUser] [varchar](100) NULL,
	[UpdateUser] [varchar](100) NULL,
	[Accommodation] [varchar](100) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
