CREATE TABLE [dbo].[ET_TestRun](
	[RunDate] [datetime] NULL,
	[Status] [bit] NULL,
	[Message] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [int] NULL,
	[ResultsLength] [int] NULL,
	[MoreResults] [bit] NULL,
	[RequestID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastRun] [datetime] NULL
) ON [PRIMARY]
