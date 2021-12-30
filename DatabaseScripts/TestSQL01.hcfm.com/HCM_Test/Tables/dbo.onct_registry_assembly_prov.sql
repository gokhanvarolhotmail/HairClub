/* CreateDate: 01/25/2010 11:09:09.990 , ModifyDate: 06/21/2012 10:03:58.320 */
GO
CREATE TABLE [dbo].[onct_registry_assembly_prov](
	[registry_assembly_provider_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_onct_registry_assembly_prov] PRIMARY KEY CLUSTERED
(
	[registry_assembly_provider_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_assembly_prov]  WITH CHECK ADD  CONSTRAINT [registry_ent_registry_ass_1108] FOREIGN KEY([registry_entry_id])
REFERENCES [dbo].[onct_registry_entry] ([registry_entry_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_registry_assembly_prov] CHECK CONSTRAINT [registry_ent_registry_ass_1108]
GO
