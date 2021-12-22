/* CreateDate: 01/18/2005 09:34:14.217 , ModifyDate: 06/18/2013 09:24:50.773 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_entity_tree_node](
	[entity_tree_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_tree_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parent_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onct_entity_tree_node] PRIMARY KEY CLUSTERED
(
	[entity_tree_node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_tree_node_i2] ON [dbo].[onct_entity_tree_node]
(
	[entity_tree_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_tree_node_i3] ON [dbo].[onct_entity_tree_node]
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_tree_node_i4] ON [dbo].[onct_entity_tree_node]
(
	[table_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_tree_node_i5] ON [dbo].[onct_entity_tree_node]
(
	[parent_node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_entity_tree_node]  WITH CHECK ADD  CONSTRAINT [entity_entity_tree__340] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_entity_tree_node] CHECK CONSTRAINT [entity_entity_tree__340]
GO
ALTER TABLE [dbo].[onct_entity_tree_node]  WITH CHECK ADD  CONSTRAINT [entity_tree__entity_tree__195] FOREIGN KEY([parent_node_id])
REFERENCES [dbo].[onct_entity_tree_node] ([entity_tree_node_id])
GO
ALTER TABLE [dbo].[onct_entity_tree_node] CHECK CONSTRAINT [entity_tree__entity_tree__195]
GO
ALTER TABLE [dbo].[onct_entity_tree_node]  WITH CHECK ADD  CONSTRAINT [entity_tree_entity_tree__194] FOREIGN KEY([entity_tree_id])
REFERENCES [dbo].[onct_entity_tree] ([entity_tree_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_entity_tree_node] CHECK CONSTRAINT [entity_tree_entity_tree__194]
GO
ALTER TABLE [dbo].[onct_entity_tree_node]  WITH CHECK ADD  CONSTRAINT [table_relati_entity_tree__349] FOREIGN KEY([table_relation_id])
REFERENCES [dbo].[onct_table_relation] ([table_relation_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_entity_tree_node] CHECK CONSTRAINT [table_relati_entity_tree__349]
GO
