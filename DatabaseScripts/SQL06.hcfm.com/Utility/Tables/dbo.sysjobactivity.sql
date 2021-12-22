/* CreateDate: 07/31/2014 11:56:58.280 , ModifyDate: 07/31/2014 11:56:58.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobactivity](
	[RunDate] [datetime] NOT NULL,
	[session_id] [int] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[run_requested_date] [datetime] NULL,
	[run_requested_source] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[queued_date] [datetime] NULL,
	[start_execution_date] [datetime] NULL,
	[last_executed_step_id] [int] NULL,
	[last_executed_step_date] [datetime] NULL,
	[stop_execution_date] [datetime] NULL,
	[job_history_id] [int] NULL,
	[next_scheduled_run_date] [datetime] NULL
) ON [PRIMARY]
GO
