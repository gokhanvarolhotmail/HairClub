/* CreateDate: 01/25/2010 11:09:09.863 , ModifyDate: 06/21/2012 10:03:58.317 */
GO
CREATE TABLE [dbo].[onct_registry_assembly](
	[registry_assembly_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_assembly_provider_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assembly_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
	[layer_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_registry_assembly] PRIMARY KEY CLUSTERED
(
	[registry_assembly_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_assembly]  WITH NOCHECK ADD  CONSTRAINT [layer_registry_ass_1177] FOREIGN KEY([layer_code])
REFERENCES [dbo].[onct_layer] ([layer_code])
GO
ALTER TABLE [dbo].[onct_registry_assembly] CHECK CONSTRAINT [layer_registry_ass_1177]
GO
ALTER TABLE [dbo].[onct_registry_assembly]  WITH NOCHECK ADD  CONSTRAINT [registry_ass_registry_ass_1109] FOREIGN KEY([registry_assembly_provider_id])
REFERENCES [dbo].[onct_registry_assembly_prov] ([registry_assembly_provider_id])
GO
ALTER TABLE [dbo].[onct_registry_assembly] CHECK CONSTRAINT [registry_ass_registry_ass_1109]
GO
