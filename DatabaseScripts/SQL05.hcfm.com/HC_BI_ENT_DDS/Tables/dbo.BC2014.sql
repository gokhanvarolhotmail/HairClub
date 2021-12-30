/* CreateDate: 01/06/2014 11:44:39.817 , ModifyDate: 01/06/2014 11:44:39.817 */
GO
CREATE TABLE [dbo].[BC2014](
	[DateKey] [int] NULL,
	[Date] [datetime] NULL,
	[Year] [int] NULL,
	[Quarter] [int] NULL,
	[Month] [int] NULL,
	[MonthName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Week] [int] NULL,
	[Day] [int] NULL
) ON [FG1]
GO
