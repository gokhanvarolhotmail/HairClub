/* CreateDate: 11/17/2016 23:22:48.680 , ModifyDate: 11/17/2016 23:32:07.017 */
GO
CREATE TABLE [dbo].[XE_ReportProcs](
	[name] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[source_database_id] [bigint] NULL,
	[object_id] [int] NULL,
	[duration] [decimal](20, 0) NULL,
	[row_count] [decimal](20, 0) NULL,
	[line_number] [int] NULL,
	[offset] [int] NULL,
	[offset_end] [int] NULL,
	[object_type] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_name] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[statement] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_app_name] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_hostname] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[database_name] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_system] [bit] NULL,
	[nt_username] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[plan_handle] [varbinary](max) NULL,
	[query_hash] [decimal](20, 0) NULL,
	[query_plan_hash] [decimal](20, 0) NULL,
	[server_principal_name] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[session_server_principal_name] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[attach_activity_id_xfer.guid] [uniqueidentifier] NULL,
	[attach_activity_id_xfer.seq] [bigint] NULL,
	[attach_activity_id.guid] [uniqueidentifier] NULL,
	[attach_activity_id.seq] [bigint] NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_XE_ReportProcs] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [NC_XE_ReportProcs_object_name] ON [dbo].[XE_ReportProcs]
(
	[object_name] ASC,
	[timestamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_XE_ReportProcs_Timestamp] ON [dbo].[XE_ReportProcs]
(
	[timestamp] ASC
)
INCLUDE([name],[object_name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
