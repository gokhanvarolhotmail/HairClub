/* CreateDate: 05/13/2018 21:17:28.850 , ModifyDate: 05/13/2018 21:17:28.850 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackupDeviceInfo](
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BackupDeviceType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhysicalLocation] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkipTapeLabel] [bit] NULL,
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
