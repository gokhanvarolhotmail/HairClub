/* CreateDate: 04/08/2019 11:52:08.057 , ModifyDate: 03/04/2020 14:17:58.603 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbHRTurnover](
	[EmployeeFullName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterID] [int] NOT NULL,
	[DepartmentNumber] [int] NOT NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Area] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeeID] [float] NOT NULL,
	[EmployeeStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[VoluntaryInvoluntary] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeOriginalHire] [date] NOT NULL,
	[EmployeeCurrentHire] [date] NULL,
	[EmployeeTermination] [date] NULL,
	[OriginalTermReason] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportMonth] [int] NOT NULL,
	[ReportYear] [int] NOT NULL,
	[ReportDate] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbHRTurnover_ReportDate] ON [dbo].[dbHRTurnover]
(
	[ReportDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
