/* CreateDate: 02/03/2020 15:17:47.667 , ModifyDate: 02/03/2020 15:17:47.667 */
GO
CREATE TABLE [dbo].[BC2020](
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
