/* CreateDate: 12/30/2021 10:46:24.147 , ModifyDate: 12/30/2021 10:46:24.147 */
GO
CREATE TABLE [dbo].[BC2022](
	[DateKey] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] [datetime] NULL,
	[Year] [float] NULL,
	[Quarter] [float] NULL,
	[Month] [float] NULL,
	[MonthName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Week] [float] NULL,
	[Day] [float] NULL,
	[F9] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG1]
GO
