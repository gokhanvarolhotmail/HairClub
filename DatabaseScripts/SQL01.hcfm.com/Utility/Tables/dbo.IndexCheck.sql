CREATE TABLE [dbo].[IndexCheck](
	[RunTime] [datetime] NOT NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchemaName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IndexName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectType] [nvarchar](60) COLLATE Latin1_General_CI_AS_KS_WS NULL,
	[IndexType] [nvarchar](60) COLLATE Latin1_General_CI_AS_KS_WS NULL,
	[PartitionNumber] [int] NULL,
	[PageCount] [bigint] NULL,
	[AvgFragmentationInPercent] [float] NULL
) ON [PRIMARY]
