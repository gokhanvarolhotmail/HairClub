CREATE TABLE [dbo].[sysjobschedules](
	[RunDate] [datetime] NOT NULL,
	[schedule_id] [int] NULL,
	[job_id] [uniqueidentifier] NULL,
	[next_run_date] [int] NOT NULL,
	[next_run_time] [int] NOT NULL
) ON [PRIMARY]
