CREATE TABLE [dbo].[HairSystemInventoryHeader_ARCHIVE](
	[InventoryID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[ScanMonth] [int] NULL,
	[ScanYear] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScanCompleted] [bit] NULL,
	[CompleteDate] [datetime] NULL,
	[CompleteUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
