CREATE TABLE [dbo].[ContestReportGroup](
	[ContestReportGroupSSID] [int] IDENTITY(1,1) NOT NULL,
	[ContestSSID] [int] NOT NULL,
	[GroupDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GroupImage] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ContestReportGroup] PRIMARY KEY CLUSTERED
(
	[ContestReportGroupSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
