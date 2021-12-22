CREATE TABLE [dbo].[lkpLaborServiceDuration](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CodeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MenDuration] [int] NULL,
	[WomenDuration] [int] NULL
) ON [PRIMARY]
