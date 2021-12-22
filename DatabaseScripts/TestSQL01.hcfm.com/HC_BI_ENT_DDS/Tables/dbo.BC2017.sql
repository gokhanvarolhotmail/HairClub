/* CreateDate: 11/29/2016 11:20:29.940 , ModifyDate: 11/29/2016 11:20:49.273 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BC2017](
	[DateKey] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] [datetime] NULL,
	[Year] [float] NULL,
	[Quarter] [float] NULL,
	[Month] [float] NULL,
	[MonthName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Week] [float] NULL,
	[Day] [float] NULL
) ON [FG1]
GO
