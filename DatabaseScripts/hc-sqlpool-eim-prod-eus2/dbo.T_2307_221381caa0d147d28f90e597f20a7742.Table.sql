/****** Object:  Table [dbo].[T_2307_221381caa0d147d28f90e597f20a7742]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2307_221381caa0d147d28f90e597f20a7742]
(
	[FactDate] [datetime2](7) NULL,
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
	[CreateUser] [nvarchar](max) NULL,
	[Accommodation] [nvarchar](max) NULL,
	[UpdateUser] [nvarchar](max) NULL,
	[rac998d48389e479b86caeec083cd09b0] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
