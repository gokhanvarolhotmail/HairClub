/* CreateDate: 09/19/2014 23:48:46.537 , ModifyDate: 09/19/2014 23:48:46.537 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tempdb_contention_two](
	[Run Date] [datetime] NOT NULL,
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_id] [smallint] NULL,
	[wait_type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wait_duration_ms] [bigint] NULL,
	[blocking_session_id] [smallint] NULL,
	[resource_Description] [nvarchar](3072) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[file_id] [int] NULL,
	[page_id] [int] NULL,
	[page_level] [int] NULL,
	[allocation_unit_id] [bigint] NULL,
	[page_type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[row_count] [int] NULL,
	[free_space_in_bytes] [int] NULL,
	[is_modified] [bit] NULL,
	[numa_node] [int] NULL,
	[read_microsec] [bigint] NULL
) ON [PRIMARY]
GO
