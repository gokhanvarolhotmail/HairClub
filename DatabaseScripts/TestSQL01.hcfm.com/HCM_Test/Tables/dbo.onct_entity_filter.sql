/* CreateDate: 01/18/2005 09:34:20.997 , ModifyDate: 06/21/2012 10:04:17.167 */
GO
CREATE TABLE [dbo].[onct_entity_filter](
	[entity_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[expression_prefix] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[relational_operator] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[expression_suffix] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_operator] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onct_entity_filter] PRIMARY KEY CLUSTERED
(
	[entity_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_filter_i2] ON [dbo].[onct_entity_filter]
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_entity_filter]  WITH NOCHECK ADD  CONSTRAINT [entity_entity_filte_347] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_entity_filter] CHECK CONSTRAINT [entity_entity_filte_347]
GO
ALTER TABLE [dbo].[onct_entity_filter]  WITH NOCHECK ADD  CONSTRAINT [table_column_entity_filte_348] FOREIGN KEY([table_name], [column_name])
REFERENCES [dbo].[onct_table_column] ([table_name], [column_name])
GO
ALTER TABLE [dbo].[onct_entity_filter] CHECK CONSTRAINT [table_column_entity_filte_348]
GO
