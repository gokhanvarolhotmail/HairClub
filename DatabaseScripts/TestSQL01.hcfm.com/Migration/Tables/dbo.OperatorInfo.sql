/* CreateDate: 05/13/2018 20:47:42.210 , ModifyDate: 05/13/2018 20:47:42.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperatorInfo](
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RelatedJobs] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastEmail] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsEnabled] [bit] NULL,
	[Parent] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CategoryName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enabled] [bit] NULL,
	[ID] [int] NULL,
	[LastEmailDate] [datetime2](7) NULL,
	[LastNetSendDate] [datetime2](7) NULL,
	[LastPagerDate] [datetime2](7) NULL,
	[NetSendAddress] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PagerAddress] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PagerDays] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaturdayPagerEndTime] [bigint] NULL,
	[SaturdayPagerStartTime] [bigint] NULL,
	[SundayPagerEndTime] [bigint] NULL,
	[SundayPagerStartTime] [bigint] NULL,
	[WeekdayPagerEndTime] [bigint] NULL,
	[WeekdayPagerStartTime] [bigint] NULL,
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
