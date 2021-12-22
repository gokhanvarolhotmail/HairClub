/* CreateDate: 07/31/2014 11:52:06.900 , ModifyDate: 07/31/2014 11:52:06.900 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobservers](
	[RunDate] [datetime] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[server_id] [int] NOT NULL,
	[last_run_outcome] [tinyint] NOT NULL,
	[last_outcome_message] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_run_date] [int] NOT NULL,
	[last_run_time] [int] NOT NULL,
	[last_run_duration] [int] NOT NULL
) ON [PRIMARY]
GO
