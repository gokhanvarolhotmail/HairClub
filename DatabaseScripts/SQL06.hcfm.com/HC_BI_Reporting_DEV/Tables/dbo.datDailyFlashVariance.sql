CREATE TABLE [dbo].[datDailyFlashVariance](
	[ReportDate] [datetime] NULL,
	[ReportPeriod] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Metric] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Actual] [decimal](18, 4) NULL,
	[Target] [decimal](18, 4) NULL,
	[Variance] [decimal](18, 4) NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
