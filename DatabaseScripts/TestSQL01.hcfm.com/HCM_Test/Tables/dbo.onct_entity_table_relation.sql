/* CreateDate: 01/18/2005 09:34:20.890 , ModifyDate: 06/18/2013 09:24:50.813 */
GO
CREATE TABLE [dbo].[onct_entity_table_relation](
	[entity_table_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onct_entity_table_relation] PRIMARY KEY CLUSTERED
(
	[entity_table_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_table_relation_i2] ON [dbo].[onct_entity_table_relation]
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_table_relation_i3] ON [dbo].[onct_entity_table_relation]
(
	[table_relation_member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_entity_table_relation]  WITH NOCHECK ADD  CONSTRAINT [entity_entity_table_346] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_entity_table_relation] CHECK CONSTRAINT [entity_entity_table_346]
GO
ALTER TABLE [dbo].[onct_entity_table_relation]  WITH NOCHECK ADD  CONSTRAINT [table_relati_entity_table_345] FOREIGN KEY([table_relation_member_id])
REFERENCES [dbo].[onct_table_relation_member] ([table_relation_member_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_entity_table_relation] CHECK CONSTRAINT [table_relati_entity_table_345]
GO
