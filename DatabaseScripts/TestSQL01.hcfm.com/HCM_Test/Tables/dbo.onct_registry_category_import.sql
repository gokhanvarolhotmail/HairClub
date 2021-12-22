/* CreateDate: 01/25/2010 11:09:10.083 , ModifyDate: 06/21/2012 10:03:58.343 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_registry_category_import](
	[registry_category_import_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_category_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[import_namespace] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_onct_registry_category_import] PRIMARY KEY CLUSTERED
(
	[registry_category_import_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_registry_category_impo_i1] ON [dbo].[onct_registry_category_import]
(
	[registry_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [onct_registry_category_impo_i2] ON [dbo].[onct_registry_category_import]
(
	[registry_category_id] ASC,
	[import_namespace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_category_import]  WITH CHECK ADD  CONSTRAINT [registry_cat_registry_cat_1173] FOREIGN KEY([registry_category_id])
REFERENCES [dbo].[onct_registry_category] ([registry_category_id])
GO
ALTER TABLE [dbo].[onct_registry_category_import] CHECK CONSTRAINT [registry_cat_registry_cat_1173]
GO
