/* CreateDate: 01/13/2022 07:54:48.667 , ModifyDate: 01/13/2022 07:54:48.667 */
GO
CREATE TABLE [dbo].[BC2023](
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
