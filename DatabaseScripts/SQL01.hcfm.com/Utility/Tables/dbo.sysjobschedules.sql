/* CreateDate: 07/31/2014 11:52:06.873 , ModifyDate: 07/31/2014 11:52:06.873 */
GO
CREATE TABLE [dbo].[sysjobschedules](
	[RunDate] [datetime] NOT NULL,
	[schedule_id] [int] NULL,
	[job_id] [uniqueidentifier] NULL,
	[next_run_date] [int] NOT NULL,
	[next_run_time] [int] NOT NULL
) ON [PRIMARY]
GO
