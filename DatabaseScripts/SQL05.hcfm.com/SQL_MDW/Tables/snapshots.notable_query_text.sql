/* CreateDate: 01/03/2014 07:07:48.113 , ModifyDate: 01/03/2014 07:07:48.573 */
GO
CREATE TABLE [snapshots].[notable_query_text](
	[sql_handle] [varbinary](64) NOT NULL,
	[database_id] [smallint] NULL,
	[object_id] [int] NULL,
	[object_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_text] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_id] [int] NOT NULL,
 CONSTRAINT [PK_notable_query_text] PRIMARY KEY CLUSTERED
(
	[source_id] ASC,
	[sql_handle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [snapshots].[notable_query_text]  WITH CHECK ADD  CONSTRAINT [FK_notable_query_text_source_info_internal] FOREIGN KEY([source_id])
REFERENCES [core].[source_info_internal] ([source_id])
ON DELETE CASCADE
GO
ALTER TABLE [snapshots].[notable_query_text] CHECK CONSTRAINT [FK_notable_query_text_source_info_internal]
GO
