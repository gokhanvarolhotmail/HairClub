/* CreateDate: 01/03/2014 07:07:48.493 , ModifyDate: 01/03/2014 07:07:48.600 */
GO
CREATE TABLE [snapshots].[distinct_query_to_handle](
	[distinct_query_hash] [bigint] NOT NULL,
	[sql_handle] [varbinary](64) NOT NULL,
	[source_id] [int] NOT NULL,
 CONSTRAINT [PK_distinct_query_to_handle] PRIMARY KEY CLUSTERED
(
	[source_id] ASC,
	[distinct_query_hash] ASC,
	[sql_handle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [snapshots].[distinct_query_to_handle]  WITH CHECK ADD  CONSTRAINT [FK_distinct_query_to_handle_distinct_queries] FOREIGN KEY([source_id], [distinct_query_hash])
REFERENCES [snapshots].[distinct_queries] ([source_id], [distinct_query_hash])
GO
ALTER TABLE [snapshots].[distinct_query_to_handle] CHECK CONSTRAINT [FK_distinct_query_to_handle_distinct_queries]
GO
ALTER TABLE [snapshots].[distinct_query_to_handle]  WITH CHECK ADD  CONSTRAINT [FK_distinct_query_to_handle_notable_query_text] FOREIGN KEY([source_id], [sql_handle])
REFERENCES [snapshots].[notable_query_text] ([source_id], [sql_handle])
GO
ALTER TABLE [snapshots].[distinct_query_to_handle] CHECK CONSTRAINT [FK_distinct_query_to_handle_notable_query_text]
GO
ALTER TABLE [snapshots].[distinct_query_to_handle]  WITH CHECK ADD  CONSTRAINT [FK_distinct_query_to_handle_source_info_internal] FOREIGN KEY([source_id])
REFERENCES [core].[source_info_internal] ([source_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[distinct_query_to_handle] CHECK CONSTRAINT [FK_distinct_query_to_handle_source_info_internal]
GO
