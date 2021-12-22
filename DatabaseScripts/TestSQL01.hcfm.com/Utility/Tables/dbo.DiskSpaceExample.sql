/* CreateDate: 05/10/2018 17:32:11.550 , ModifyDate: 05/10/2018 17:32:11.550 */
GO
CREATE TABLE [dbo].[DiskSpaceExample](
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Database] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileGroup] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhysicalName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UsedSpaceMB] [float] NULL,
	[FreeSpaceMB] [float] NULL,
	[FileSizeMB] [float] NULL,
	[PercentUsed] [float] NULL,
	[AutoGrowth] [float] NULL,
	[AutoGrowType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SpaceUntilMaxSizeMB] [float] NULL,
	[AutoGrowthPossibleMB] [float] NULL,
	[UnusableSpaceMB] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
