/* CreateDate: 01/21/2017 19:58:40.820 , ModifyDate: 01/21/2017 19:58:40.820 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImagesWithSizeZero](
	[stream_id] [uniqueidentifier] NOT NULL,
	[file_stream] [varbinary](max) NULL,
	[name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[path_locator] [hierarchyid] NOT NULL,
	[parent_path_locator] [hierarchyid] NULL,
	[file_type] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cached_file_size] [bigint] NULL,
	[creation_time] [datetimeoffset](7) NOT NULL,
	[last_write_time] [datetimeoffset](7) NOT NULL,
	[last_access_time] [datetimeoffset](7) NULL,
	[is_directory] [bit] NOT NULL,
	[is_offline] [bit] NOT NULL,
	[is_hidden] [bit] NOT NULL,
	[is_readonly] [bit] NOT NULL,
	[is_archive] [bit] NOT NULL,
	[is_system] [bit] NOT NULL,
	[is_temporary] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
