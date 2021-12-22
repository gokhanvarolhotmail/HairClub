/* CreateDate: 01/25/2010 11:09:09.617 , ModifyDate: 06/21/2012 10:03:58.387 */
GO
CREATE TABLE [dbo].[onct_registry_entry_layer](
	[registry_entry_layer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[layer_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_onct_registry_entry_layer] PRIMARY KEY CLUSTERED
(
	[registry_entry_layer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_entry_layer]  WITH CHECK ADD  CONSTRAINT [layer_registry_ent_1114] FOREIGN KEY([layer_code])
REFERENCES [dbo].[onct_layer] ([layer_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_entry_layer] CHECK CONSTRAINT [layer_registry_ent_1114]
GO
ALTER TABLE [dbo].[onct_registry_entry_layer]  WITH CHECK ADD  CONSTRAINT [registry_ent_registry_ent_1094] FOREIGN KEY([registry_entry_id])
REFERENCES [dbo].[onct_registry_entry] ([registry_entry_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_entry_layer] CHECK CONSTRAINT [registry_ent_registry_ent_1094]
GO
