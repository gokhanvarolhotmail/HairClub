/* CreateDate: 01/25/2010 11:09:10.053 , ModifyDate: 06/21/2012 10:04:13.643 */
GO
CREATE TABLE [dbo].[onct_object_layer](
	[object_layer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_entry_layer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onct_object_layer] PRIMARY KEY CLUSTERED
(
	[object_layer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_object_layer]  WITH NOCHECK ADD  CONSTRAINT [object_object_layer_1116] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onct_object_layer] CHECK CONSTRAINT [object_object_layer_1116]
GO
ALTER TABLE [dbo].[onct_object_layer]  WITH NOCHECK ADD  CONSTRAINT [registry_ent_object_layer_1117] FOREIGN KEY([registry_entry_layer_id])
REFERENCES [dbo].[onct_registry_entry_layer_data] ([registry_entry_layer_id])
GO
ALTER TABLE [dbo].[onct_object_layer] CHECK CONSTRAINT [registry_ent_object_layer_1117]
GO
