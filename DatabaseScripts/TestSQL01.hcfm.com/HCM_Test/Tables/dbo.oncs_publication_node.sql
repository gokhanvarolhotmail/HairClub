/* CreateDate: 07/13/2005 16:58:17.850 , ModifyDate: 06/21/2012 10:04:45.503 */
GO
CREATE TABLE [dbo].[oncs_publication_node](
	[publication_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[publication_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_alias] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_publication_node] PRIMARY KEY CLUSTERED
(
	[publication_node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_publication_node]  WITH CHECK ADD  CONSTRAINT [publication__publication__355] FOREIGN KEY([parent_node_id])
REFERENCES [dbo].[oncs_publication_node] ([publication_node_id])
GO
ALTER TABLE [dbo].[oncs_publication_node] CHECK CONSTRAINT [publication__publication__355]
GO
ALTER TABLE [dbo].[oncs_publication_node]  WITH CHECK ADD  CONSTRAINT [publication_publication__309] FOREIGN KEY([publication_id])
REFERENCES [dbo].[oncs_publication] ([publication_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_node] CHECK CONSTRAINT [publication_publication__309]
GO
ALTER TABLE [dbo].[oncs_publication_node]  WITH CHECK ADD  CONSTRAINT [table_publication__358] FOREIGN KEY([table_name])
REFERENCES [dbo].[onct_table] ([table_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_node] CHECK CONSTRAINT [table_publication__358]
GO
ALTER TABLE [dbo].[oncs_publication_node]  WITH CHECK ADD  CONSTRAINT [table_relati_publication__357] FOREIGN KEY([table_relation_member_id])
REFERENCES [dbo].[onct_table_relation_member] ([table_relation_member_id])
GO
ALTER TABLE [dbo].[oncs_publication_node] CHECK CONSTRAINT [table_relati_publication__357]
GO
