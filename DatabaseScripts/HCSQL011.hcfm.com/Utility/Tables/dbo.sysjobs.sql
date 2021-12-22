/* CreateDate: 07/31/2014 11:52:06.793 , ModifyDate: 07/31/2014 11:52:06.793 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobs](
	[RunDate] [datetime] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[originating_server_id] [int] NOT NULL,
	[name] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[enabled] [tinyint] NOT NULL,
	[description] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_step_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[owner_sid] [varbinary](85) NOT NULL,
	[notify_level_eventlog] [int] NOT NULL,
	[notify_level_email] [int] NOT NULL,
	[notify_level_netsend] [int] NOT NULL,
	[notify_level_page] [int] NOT NULL,
	[notify_email_operator_id] [int] NOT NULL,
	[notify_netsend_operator_id] [int] NOT NULL,
	[notify_page_operator_id] [int] NOT NULL,
	[delete_level] [int] NOT NULL,
	[date_created] [datetime] NOT NULL,
	[date_modified] [datetime] NOT NULL,
	[version_number] [int] NOT NULL
) ON [PRIMARY]
GO
