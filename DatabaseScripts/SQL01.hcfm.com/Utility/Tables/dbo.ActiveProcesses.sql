CREATE TABLE [dbo].[ActiveProcesses](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Run Date] [datetime] NULL,
	[session_id] [smallint] NOT NULL,
	[host_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[status] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Individual Query] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent Query] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[program_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_time] [datetime] NOT NULL,
	[query_plan] [xml] NULL,
	[wait_type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[total_elapsed_time] [int] NOT NULL,
	[cpu_time] [int] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[blocking_session_id] [smallint] NULL,
	[open_transaction_count] [int] NOT NULL,
	[last_wait_type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[percent_complete] [real] NOT NULL,
 CONSTRAINT [PK_ActiveProcesses] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_ActiveProcesses_RunDate] ON [dbo].[ActiveProcesses]
(
	[Run Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
