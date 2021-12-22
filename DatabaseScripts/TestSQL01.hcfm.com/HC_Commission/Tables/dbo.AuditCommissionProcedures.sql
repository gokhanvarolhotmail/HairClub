/* CreateDate: 11/02/2012 15:53:30.957 , ModifyDate: 11/02/2012 15:53:31.070 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditCommissionProcedures](
	[AuditKey] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [date] NOT NULL,
	[ProcedureName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StartTime] [time](7) NULL,
	[EndTime] [time](7) NULL
) ON [PRIMARY]
GO
