/* CreateDate: 07/28/2014 12:59:47.130 , ModifyDate: 07/28/2014 12:59:47.130 */
GO
CREATE TABLE [dbo].[IndexUsage](
	[RunTime] [datetime] NOT NULL,
	[database_id] [smallint] NOT NULL,
	[object_id] [int] NOT NULL,
	[index_id] [int] NOT NULL,
	[user_seeks] [bigint] NOT NULL,
	[user_scans] [bigint] NOT NULL,
	[user_lookups] [bigint] NOT NULL,
	[user_updates] [bigint] NOT NULL,
	[last_user_seek] [datetime] NULL,
	[last_user_scan] [datetime] NULL,
	[last_user_lookup] [datetime] NULL,
	[last_user_update] [datetime] NULL,
	[system_seeks] [bigint] NOT NULL,
	[system_scans] [bigint] NOT NULL,
	[system_lookups] [bigint] NOT NULL,
	[system_updates] [bigint] NOT NULL,
	[last_system_seek] [datetime] NULL,
	[last_system_scan] [datetime] NULL,
	[last_system_lookup] [datetime] NULL,
	[last_system_update] [datetime] NULL
) ON [PRIMARY]
GO
