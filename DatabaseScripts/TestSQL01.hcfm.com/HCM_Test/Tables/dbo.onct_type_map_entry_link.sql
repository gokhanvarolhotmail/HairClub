/* CreateDate: 03/01/2006 08:13:59.587 , ModifyDate: 01/25/2010 11:08:55.717 */
GO
CREATE TABLE [dbo].[onct_type_map_entry_link](
	[type_map_entry_link_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_map_entry_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[customization_layer_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assembly_qualified_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
