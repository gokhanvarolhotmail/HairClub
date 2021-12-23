/* CreateDate: 01/25/2010 11:09:10.067 , ModifyDate: 06/21/2012 10:03:58.317 */
GO
CREATE TABLE [dbo].[onct_registry_assembly_module](
	[registry_assembly_module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_assembly_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[module_image] [image] NULL,
	[storage_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_registry_assembly_module] PRIMARY KEY CLUSTERED
(
	[registry_assembly_module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_assembly_module]  WITH NOCHECK ADD  CONSTRAINT [registry_ass_registry_ass_1121] FOREIGN KEY([registry_assembly_id])
REFERENCES [dbo].[onct_registry_assembly] ([registry_assembly_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_assembly_module] CHECK CONSTRAINT [registry_ass_registry_ass_1121]
GO
