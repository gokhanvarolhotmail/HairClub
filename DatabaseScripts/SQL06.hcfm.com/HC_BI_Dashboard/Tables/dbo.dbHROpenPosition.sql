CREATE TABLE [dbo].[dbHROpenPosition](
	[Position] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[JobStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Assigned] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PositionCount] [int] NULL,
	[Priorities] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Area] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportDate] [datetime] NULL,
	[ReportWeek] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbHROpenPosition_ReportDate] ON [dbo].[dbHROpenPosition]
(
	[ReportDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
