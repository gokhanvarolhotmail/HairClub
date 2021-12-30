/* CreateDate: 07/31/2014 11:56:58.703 , ModifyDate: 07/31/2014 11:56:58.703 */
GO
CREATE TABLE [dbo].[sysschedules](
	[RunDate] [datetime] NOT NULL,
	[schedule_id] [int] IDENTITY(1,1) NOT NULL,
	[schedule_uid] [uniqueidentifier] NOT NULL,
	[originating_server_id] [int] NOT NULL,
	[name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[owner_sid] [varbinary](85) NOT NULL,
	[enabled] [int] NOT NULL,
	[freq_type] [int] NOT NULL,
	[freq_interval] [int] NOT NULL,
	[freq_subday_type] [int] NOT NULL,
	[freq_subday_interval] [int] NOT NULL,
	[freq_relative_interval] [int] NOT NULL,
	[freq_recurrence_factor] [int] NOT NULL,
	[active_start_date] [int] NOT NULL,
	[active_end_date] [int] NOT NULL,
	[active_start_time] [int] NOT NULL,
	[active_end_time] [int] NOT NULL,
	[date_created] [datetime] NOT NULL,
	[date_modified] [datetime] NOT NULL,
	[version_number] [int] NOT NULL
) ON [PRIMARY]
GO
