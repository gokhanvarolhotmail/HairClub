/* CreateDate: 11/28/2017 17:14:58.267 , ModifyDate: 11/28/2017 17:14:58.267 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XEInfo](
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[source_database_id] [bigint] NULL,
	[object_id] [int] NULL,
	[object_type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[duration] [decimal](20, 0) NULL,
	[cpu_time] [decimal](20, 0) NULL,
	[physical_reads] [decimal](20, 0) NULL,
	[logical_reads] [decimal](20, 0) NULL,
	[writes] [decimal](20, 0) NULL,
	[row_count] [decimal](20, 0) NULL,
	[last_row_count] [decimal](20, 0) NULL,
	[nest_level] [int] NULL,
	[line_number] [int] NULL,
	[offset] [int] NULL,
	[offset_end] [int] NULL,
	[object_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[statement] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[event_sequence] [decimal](20, 0) NULL,
	[client_app_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[database_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[nt_username] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[server_instance_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[attach_activity_id_xfer.guid] [uniqueidentifier] NULL,
	[attach_activity_id_xfer.seq] [bigint] NULL,
	[attach_activity_id.guid] [uniqueidentifier] NULL,
	[attach_activity_id.seq] [bigint] NULL,
	[parameterized_plan_handle] [varbinary](max) NULL,
	[result] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[connection_reset_option] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[data_stream] [varbinary](max) NULL,
	[output_parameters] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
