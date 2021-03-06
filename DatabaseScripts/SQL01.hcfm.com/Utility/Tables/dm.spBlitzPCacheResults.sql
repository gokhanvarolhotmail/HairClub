/* CreateDate: 10/30/2014 11:35:48.740 , ModifyDate: 10/30/2014 11:35:48.740 */
GO
CREATE TABLE [dm].[spBlitzPCacheResults](
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Check Date] [datetime] NOT NULL,
	[AvgCPU] [bigint] NULL,
	[TotalCPU] [bigint] NOT NULL,
	[PercentCPU] [money] NULL,
	[AvgDuration] [bigint] NULL,
	[TotalDuration] [bigint] NOT NULL,
	[PercentDuration] [money] NULL,
	[AvgReads] [bigint] NULL,
	[TotalReads] [bigint] NOT NULL,
	[PercentReads] [money] NULL,
	[execution_count] [bigint] NOT NULL,
	[PercentExecutions] [money] NULL,
	[executions_per_minute] [money] NULL,
	[plan_creation_time] [datetime] NOT NULL,
	[last_execution_time] [datetime] NOT NULL,
	[text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[text_filtered] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[query_plan] [xml] NULL,
	[query_plan_filtered] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_handle] [varbinary](64) NOT NULL,
	[query_hash] [binary](8) NULL,
	[plan_handle] [varbinary](64) NOT NULL,
	[query_plan_hash] [binary](8) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
