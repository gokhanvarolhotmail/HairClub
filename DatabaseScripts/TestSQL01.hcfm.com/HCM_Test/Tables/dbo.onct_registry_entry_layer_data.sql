/* CreateDate: 01/25/2010 11:09:09.723 , ModifyDate: 06/21/2012 10:03:58.390 */
GO
CREATE TABLE [dbo].[onct_registry_entry_layer_data](
	[registry_entry_layer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_serializer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_onct_registry_entry_layer_data] PRIMARY KEY CLUSTERED
(
	[registry_entry_layer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_data]  WITH CHECK ADD  CONSTRAINT [registry_ent_registry_ent_1096] FOREIGN KEY([registry_entry_layer_id])
REFERENCES [dbo].[onct_registry_entry_layer] ([registry_entry_layer_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_data] CHECK CONSTRAINT [registry_ent_registry_ent_1096]
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_data]  WITH CHECK ADD  CONSTRAINT [registry_ser_registry_ent_1113] FOREIGN KEY([registry_serializer_id])
REFERENCES [dbo].[onct_registry_serializer] ([registry_serializer_id])
GO
ALTER TABLE [dbo].[onct_registry_entry_layer_data] CHECK CONSTRAINT [registry_ser_registry_ent_1113]
GO
