/* CreateDate: 01/03/2014 07:07:48.280 , ModifyDate: 01/03/2014 07:07:48.423 */
GO
CREATE TABLE [snapshots].[notable_query_plan](
	[sql_handle] [varbinary](64) NOT NULL,
	[plan_handle] [varbinary](64) NOT NULL,
	[statement_start_offset] [int] NOT NULL,
	[statement_end_offset] [int] NOT NULL,
	[plan_generation_num] [bigint] NOT NULL,
	[creation_time] [datetimeoffset](7) NOT NULL,
	[database_id] [smallint] NULL,
	[object_id] [int] NULL,
	[object_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[query_plan] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_id] [int] NOT NULL,
 CONSTRAINT [PK_notable_query_plan] PRIMARY KEY CLUSTERED
(
	[source_id] ASC,
	[sql_handle] ASC,
	[plan_handle] ASC,
	[statement_start_offset] ASC,
	[statement_end_offset] ASC,
	[creation_time] ASC,
	[plan_generation_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_notable_query_plan_plan_handle] ON [snapshots].[notable_query_plan]
(
	[source_id] ASC,
	[plan_handle] ASC,
	[statement_start_offset] ASC,
	[statement_end_offset] ASC,
	[creation_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[notable_query_plan]  WITH CHECK ADD  CONSTRAINT [FK_notable_query_plan_source_info_internal] FOREIGN KEY([source_id])
REFERENCES [core].[source_info_internal] ([source_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[notable_query_plan] CHECK CONSTRAINT [FK_notable_query_plan_source_info_internal]
GO
