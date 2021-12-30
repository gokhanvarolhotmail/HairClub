/* CreateDate: 01/25/2010 11:09:10.100 , ModifyDate: 06/21/2012 10:03:58.403 */
GO
CREATE TABLE [dbo].[onct_registry_entry_layer_type](
	[registry_entry_layer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_assembly_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_onct_registry_entry_layer_type] PRIMARY KEY CLUSTERED
(
	[registry_entry_layer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_type]  WITH CHECK ADD  CONSTRAINT [registry_ass_registry_ent_1097] FOREIGN KEY([registry_assembly_id])
REFERENCES [dbo].[onct_registry_assembly] ([registry_assembly_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_type] CHECK CONSTRAINT [registry_ass_registry_ent_1097]
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_type]  WITH CHECK ADD  CONSTRAINT [registry_ent_registry_ent_1095] FOREIGN KEY([registry_entry_layer_id])
REFERENCES [dbo].[onct_registry_entry_layer] ([registry_entry_layer_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_type] CHECK CONSTRAINT [registry_ent_registry_ent_1095]
GO
