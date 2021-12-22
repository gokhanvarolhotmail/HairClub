CREATE TABLE [dbo].[lkpStylistPoints](
	[RowID] [int] NOT NULL,
	[ProgramType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Program] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Points] [numeric](6, 2) NULL,
	[MembershipKey] [int] NULL
) ON [PRIMARY]
