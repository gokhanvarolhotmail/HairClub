CREATE TABLE [dbo].[HairClubCMSIndexColumns](
	[ObjectId] [int] NOT NULL,
	[TableName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IndexId] [int] NULL,
	[IndexName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[KeyColumns] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IncludeColumns] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HeapColumns] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
