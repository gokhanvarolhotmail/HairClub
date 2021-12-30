/* CreateDate: 03/02/2017 12:10:03.073 , ModifyDate: 03/02/2017 12:10:03.073 */
GO
CREATE TABLE [dbo].[tempdb_space_by_session](
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
