/* CreateDate: 12/02/2014 11:25:21.417 , ModifyDate: 12/02/2014 11:34:26.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
