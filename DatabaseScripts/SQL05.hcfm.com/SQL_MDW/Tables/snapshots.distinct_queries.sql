/* CreateDate: 01/03/2014 07:07:48.433 , ModifyDate: 01/03/2014 07:07:48.580 */
GO
CREATE TABLE [snapshots].[distinct_queries](
	[distinct_query_hash] [bigint] NOT NULL,
	[distinct_sql_text] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_id] [int] NOT NULL,
 CONSTRAINT [PK_distinct_queries] PRIMARY KEY CLUSTERED
(
	[source_id] ASC,
	[distinct_query_hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[distinct_queries]  WITH CHECK ADD  CONSTRAINT [FK_distinct_queries_source_info_internal] FOREIGN KEY([source_id])
REFERENCES [core].[source_info_internal] ([source_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[distinct_queries] CHECK CONSTRAINT [FK_distinct_queries_source_info_internal]
GO
