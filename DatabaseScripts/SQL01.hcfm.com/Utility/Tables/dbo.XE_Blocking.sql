/* CreateDate: 02/09/2017 16:32:24.010 , ModifyDate: 02/09/2017 16:32:24.010 */
GO
CREATE TABLE [dbo].[XE_Blocking](
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[source_database_id] [bigint] NULL,
	[object_id] [int] NULL,
	[object_type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[nest_level] [int] NULL,
	[line_number] [int] NULL,
	[offset] [int] NULL,
	[offset_end] [int] NULL,
	[object_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[statement] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[database_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_id] [int] NULL,
	[sql_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[attach_activity_id_xfer.guid] [uniqueidentifier] NULL,
	[attach_activity_id_xfer.seq] [bigint] NULL,
	[attach_activity_id.guid] [uniqueidentifier] NULL,
	[attach_activity_id.seq] [bigint] NULL,
	[batch_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
