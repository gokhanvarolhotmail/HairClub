/* CreateDate: 01/25/2010 11:09:09.710 , ModifyDate: 06/21/2012 10:01:00.393 */
GO
CREATE TABLE [dbo].[onca_entity_filter](
	[entity_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_filter_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_entity_filter] PRIMARY KEY CLUSTERED
(
	[entity_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_entity_filter]  WITH NOCHECK ADD  CONSTRAINT [entity_filte_entity_filte_1156] FOREIGN KEY([entity_filter_set_id])
REFERENCES [dbo].[onca_entity_filter_set] ([entity_filter_set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_entity_filter] CHECK CONSTRAINT [entity_filte_entity_filte_1156]
GO
ALTER TABLE [dbo].[onca_entity_filter]  WITH NOCHECK ADD  CONSTRAINT [registry_ent_entity_filte_1154] FOREIGN KEY([registry_entry_id])
REFERENCES [dbo].[onct_registry_entry] ([registry_entry_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_entity_filter] CHECK CONSTRAINT [registry_ent_entity_filte_1154]
GO
ALTER TABLE [dbo].[onca_entity_filter]  WITH NOCHECK ADD  CONSTRAINT [table_entity_filte_1155] FOREIGN KEY([table_name])
REFERENCES [dbo].[onct_table] ([table_name])
GO
ALTER TABLE [dbo].[onca_entity_filter] CHECK CONSTRAINT [table_entity_filte_1155]
GO
