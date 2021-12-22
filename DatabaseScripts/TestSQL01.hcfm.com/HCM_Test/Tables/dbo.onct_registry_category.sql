/* CreateDate: 01/25/2010 11:09:09.820 , ModifyDate: 06/21/2012 10:03:58.337 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_registry_category](
	[registry_category_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[category_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[relative_namespace] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_project_template_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[base_type_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[generator_registry_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_onct_registry_category] PRIMARY KEY CLUSTERED
(
	[registry_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_registry_category_i1] ON [dbo].[onct_registry_category]
(
	[generator_registry_entry_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_registry_category_i2] ON [dbo].[onct_registry_category]
(
	[registry_project_template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_category]  WITH CHECK ADD  CONSTRAINT [registry_ent_registry_cat_1178] FOREIGN KEY([generator_registry_entry_id])
REFERENCES [dbo].[onct_registry_entry] ([registry_entry_id])
GO
ALTER TABLE [dbo].[onct_registry_category] CHECK CONSTRAINT [registry_ent_registry_cat_1178]
GO
ALTER TABLE [dbo].[onct_registry_category]  WITH CHECK ADD  CONSTRAINT [registry_pro_registry_cat_1174] FOREIGN KEY([registry_project_template_id])
REFERENCES [dbo].[onct_registry_project_template] ([registry_project_template_id])
GO
ALTER TABLE [dbo].[onct_registry_category] CHECK CONSTRAINT [registry_pro_registry_cat_1174]
GO
