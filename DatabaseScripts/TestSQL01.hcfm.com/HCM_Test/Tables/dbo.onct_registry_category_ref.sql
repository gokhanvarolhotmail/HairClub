/* CreateDate: 01/25/2010 11:09:10.100 , ModifyDate: 06/21/2012 10:03:58.347 */
GO
CREATE TABLE [dbo].[onct_registry_category_ref](
	[registry_category_reference_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_category_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reference_type] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reference_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_onct_registry_category_reference] PRIMARY KEY CLUSTERED
(
	[registry_category_reference_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_registry_category_ref_i1] ON [dbo].[onct_registry_category_ref]
(
	[registry_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [onct_registry_category_ref_i2] ON [dbo].[onct_registry_category_ref]
(
	[registry_category_id] ASC,
	[reference_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_category_ref]  WITH NOCHECK ADD  CONSTRAINT [registry_cat_registry_cat_1172] FOREIGN KEY([registry_category_id])
REFERENCES [dbo].[onct_registry_category] ([registry_category_id])
GO
ALTER TABLE [dbo].[onct_registry_category_ref] CHECK CONSTRAINT [registry_cat_registry_cat_1172]
GO
