/* CreateDate: 09/19/2014 23:48:57.467 , ModifyDate: 09/19/2014 23:48:57.467 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tempdb_space_by_task](
	[Run Date] [datetime] NOT NULL,
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_id] [smallint] NOT NULL,
	[connection_id] [uniqueidentifier] NULL,
	[login_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[host_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_objects_alloc_page_count] [bigint] NULL,
	[user_objects_dealloc_page_count] [bigint] NULL,
	[internal_objects_alloc_page_count] [bigint] NULL,
	[internal_objects_dealloc_page_count] [bigint] NULL,
	[last_read] [datetime] NULL,
	[last_write] [datetime] NULL,
	[program_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
