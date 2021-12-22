/* CreateDate: 07/13/2005 16:58:17.940 , ModifyDate: 06/21/2012 10:04:45.547 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_publication_table](
	[publication_table_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[publication_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_alias] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_publication_table] PRIMARY KEY CLUSTERED
(
	[publication_table_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_publication_table]  WITH CHECK ADD  CONSTRAINT [publication__publication__353] FOREIGN KEY([parent_node_id])
REFERENCES [dbo].[oncs_publication_table] ([publication_table_id])
GO
ALTER TABLE [dbo].[oncs_publication_table] CHECK CONSTRAINT [publication__publication__353]
GO
ALTER TABLE [dbo].[oncs_publication_table]  WITH CHECK ADD  CONSTRAINT [publication_publication__307] FOREIGN KEY([publication_id])
REFERENCES [dbo].[oncs_publication] ([publication_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_table] CHECK CONSTRAINT [publication_publication__307]
GO
ALTER TABLE [dbo].[oncs_publication_table]  WITH CHECK ADD  CONSTRAINT [table_publication__352] FOREIGN KEY([table_name])
REFERENCES [dbo].[onct_table] ([table_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_table] CHECK CONSTRAINT [table_publication__352]
GO
ALTER TABLE [dbo].[oncs_publication_table]  WITH CHECK ADD  CONSTRAINT [table_relati_publication__356] FOREIGN KEY([table_relation_member_id])
REFERENCES [dbo].[onct_table_relation_member] ([table_relation_member_id])
GO
ALTER TABLE [dbo].[oncs_publication_table] CHECK CONSTRAINT [table_relati_publication__356]
GO
