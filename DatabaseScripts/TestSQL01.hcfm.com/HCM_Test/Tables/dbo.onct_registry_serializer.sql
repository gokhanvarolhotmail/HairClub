/* CreateDate: 01/25/2010 11:09:09.723 , ModifyDate: 06/21/2012 10:03:58.417 */
GO
CREATE TABLE [dbo].[onct_registry_serializer](
	[registry_serializer_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[registry_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_onct_registry_serializer] PRIMARY KEY CLUSTERED
(
	[registry_serializer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_registry_serializer]  WITH NOCHECK ADD  CONSTRAINT [registry_ent_registry_ser_1112] FOREIGN KEY([registry_entry_id])
REFERENCES [dbo].[onct_registry_entry] ([registry_entry_id])
GO
ALTER TABLE [dbo].[onct_registry_serializer] CHECK CONSTRAINT [registry_ent_registry_ser_1112]
GO
