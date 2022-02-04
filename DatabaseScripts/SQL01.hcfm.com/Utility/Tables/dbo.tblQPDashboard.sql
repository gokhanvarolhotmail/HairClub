/* CreateDate: 01/12/2022 10:49:53.627 , ModifyDate: 01/12/2022 10:49:53.627 */
GO
CREATE TABLE [dbo].[tblQPDashboard](
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[timestamp (UTC)] [datetimeoffset](7) NULL,
	[duration] [bigint] NULL,
	[cpu_time] [decimal](20, 0) NULL,
	[physical_reads] [decimal](20, 0) NULL,
	[logical_reads] [decimal](20, 0) NULL,
	[writes] [decimal](20, 0) NULL,
	[spills] [decimal](20, 0) NULL,
	[row_count] [decimal](20, 0) NULL,
	[last_row_count] [decimal](20, 0) NULL,
	[line_number] [int] NULL,
	[offset] [int] NULL,
	[offset_end] [int] NULL,
	[statement] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parameterized_plan_handle] [varbinary](max) NULL,
	[username] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_id] [int] NULL,
	[query_plan_hash] [decimal](20, 0) NULL,
	[query_hash] [decimal](20, 0) NULL,
	[plan_handle] [varbinary](max) NULL,
	[database_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_hostname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_app_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
