/* CreateDate: 01/25/2010 11:09:09.600 , ModifyDate: 06/21/2012 10:03:58.367 */
GO
CREATE TABLE [dbo].[onct_registry_entry](
	[registry_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_alias] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[base_type_name] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_entry_group_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
	[registry_category_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[registry_project_template_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_registry_entry] PRIMARY KEY CLUSTERED
(
	[registry_entry_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ__onct_registry_en__7775B2CE] ON [dbo].[onct_registry_entry]
(
	[type_alias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_entry]  WITH CHECK ADD  CONSTRAINT [registry_cat_registry_ent_1175] FOREIGN KEY([registry_category_id])
REFERENCES [dbo].[onct_registry_category] ([registry_category_id])
GO
ALTER TABLE [dbo].[onct_registry_entry] CHECK CONSTRAINT [registry_cat_registry_ent_1175]
GO
ALTER TABLE [dbo].[onct_registry_entry]  WITH CHECK ADD  CONSTRAINT [registry_ent_registry_ent_1145] FOREIGN KEY([registry_entry_group_code])
REFERENCES [dbo].[onct_registry_entry_group] ([registry_entry_group_code])
GO
ALTER TABLE [dbo].[onct_registry_entry] CHECK CONSTRAINT [registry_ent_registry_ent_1145]
GO
ALTER TABLE [dbo].[onct_registry_entry]  WITH CHECK ADD  CONSTRAINT [registry_pro_registry_ent_1176] FOREIGN KEY([registry_project_template_id])
REFERENCES [dbo].[onct_registry_project_template] ([registry_project_template_id])
GO
ALTER TABLE [dbo].[onct_registry_entry] CHECK CONSTRAINT [registry_pro_registry_ent_1176]
GO
