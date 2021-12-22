/* CreateDate: 07/28/2014 13:01:16.623 , ModifyDate: 07/28/2014 13:01:16.623 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MissingIndexes](
	[RunTime] [datetime] NOT NULL,
	[index_group_handle] [int] NOT NULL,
	[index_handle] [int] NOT NULL,
	[improvement_measure] [decimal](28, 1) NULL,
	[create_index_statement] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[group_handle] [int] NOT NULL,
	[unique_compiles] [bigint] NOT NULL,
	[user_seeks] [bigint] NOT NULL,
	[user_scans] [bigint] NOT NULL,
	[last_user_seek] [datetime] NULL,
	[last_user_scan] [datetime] NULL,
	[avg_total_user_cost] [float] NULL,
	[avg_user_impact] [float] NULL,
	[system_seeks] [bigint] NOT NULL,
	[system_scans] [bigint] NOT NULL,
	[last_system_seek] [datetime] NULL,
	[last_system_scan] [datetime] NULL,
	[avg_total_system_cost] [float] NULL,
	[avg_system_impact] [float] NULL,
	[database_id] [smallint] NOT NULL,
	[object_id] [int] NOT NULL
) ON [PRIMARY]
GO
