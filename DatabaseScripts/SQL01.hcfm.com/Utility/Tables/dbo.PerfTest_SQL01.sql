/* CreateDate: 08/02/2018 09:11:28.157 , ModifyDate: 08/02/2018 11:31:46.520 */
GO
CREATE TABLE [dbo].[PerfTest_SQL01](
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[timestamp (UTC)] [datetimeoffset](7) NULL,
	[duration] [decimal](20, 0) NULL,
	[cpu_time] [decimal](20, 0) NULL,
	[physical_reads] [decimal](20, 0) NULL,
	[logical_reads] [decimal](20, 0) NULL,
	[writes] [decimal](20, 0) NULL,
	[row_count] [decimal](20, 0) NULL,
	[last_row_count] [decimal](20, 0) NULL,
	[line_number] [int] NULL,
	[offset] [int] NULL,
	[offset_end] [int] NULL,
	[statement] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parameterized_plan_handle] [varbinary](max) NULL,
	[client_app_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_connection_id] [uniqueidentifier] NULL,
	[client_hostname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[database_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[request_id] [bigint] NULL,
	[server_principal_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_id] [int] NULL,
	[session_server_principal_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[transaction_id] [bigint] NULL,
	[transaction_sequence] [decimal](20, 0) NULL,
	[result] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[connection_reset_option] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[data_stream] [varbinary](max) NULL,
	[output_parameters] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_database_id] [bigint] NULL,
	[object_id] [int] NULL,
	[object_type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[nest_level] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
