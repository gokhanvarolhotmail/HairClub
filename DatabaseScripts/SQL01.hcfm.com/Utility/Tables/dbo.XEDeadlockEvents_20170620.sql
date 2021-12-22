CREATE TABLE [dbo].[XEDeadlockEvents_20170620](
	[name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [datetimeoffset](7) NULL,
	[xml_report] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_app_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_hostname] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_id] [int] NULL,
	[database_name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[attach_activity_id_xfer.guid] [uniqueidentifier] NULL,
	[attach_activity_id_xfer.seq] [bigint] NULL,
	[attach_activity_id.guid] [uniqueidentifier] NULL,
	[attach_activity_id.seq] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
