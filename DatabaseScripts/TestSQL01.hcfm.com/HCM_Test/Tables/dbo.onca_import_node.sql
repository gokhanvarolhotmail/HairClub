/* CreateDate: 02/04/2005 13:09:23.950 , ModifyDate: 06/21/2012 10:00:56.703 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_import_node](
	[import_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[import_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[process_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[maintain_cross_reference] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cross_reference_table] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[insert_if_source_empty] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_import_node] PRIMARY KEY CLUSTERED
(
	[import_node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_import_node]  WITH CHECK ADD  CONSTRAINT [class_import_node_394] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
GO
ALTER TABLE [dbo].[onca_import_node] CHECK CONSTRAINT [class_import_node_394]
GO
ALTER TABLE [dbo].[onca_import_node]  WITH CHECK ADD  CONSTRAINT [import_import_node_369] FOREIGN KEY([import_code])
REFERENCES [dbo].[onca_import] ([import_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_import_node] CHECK CONSTRAINT [import_import_node_369]
GO
ALTER TABLE [dbo].[onca_import_node]  WITH CHECK ADD  CONSTRAINT [table_relati_import_node_1180] FOREIGN KEY([table_relation_member_id])
REFERENCES [dbo].[onct_table_relation_member] ([table_relation_member_id])
GO
ALTER TABLE [dbo].[onca_import_node] CHECK CONSTRAINT [table_relati_import_node_1180]
GO
