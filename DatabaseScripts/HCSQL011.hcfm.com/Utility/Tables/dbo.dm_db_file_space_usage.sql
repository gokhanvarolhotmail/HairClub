/* CreateDate: 09/19/2014 23:48:57.330 , ModifyDate: 09/19/2014 23:48:57.330 */
GO
CREATE TABLE [dbo].[dm_db_file_space_usage](
	[Run Date] [datetime] NOT NULL,
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[file_id] [smallint] NULL,
	[filegroup_id] [smallint] NULL,
	[total_page_count] [bigint] NULL,
	[allocated_extent_page_count] [bigint] NULL,
	[unallocated_extent_page_count] [bigint] NULL,
	[version_store_reserved_page_count] [bigint] NULL,
	[user_object_reserved_page_count] [bigint] NULL,
	[internal_object_reserved_page_count] [bigint] NULL,
	[mixed_extent_page_count] [bigint] NULL
) ON [PRIMARY]
GO
