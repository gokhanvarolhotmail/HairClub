/* CreateDate: 02/04/2005 13:09:23.967 , ModifyDate: 06/21/2012 10:00:56.153 */
GO
CREATE TABLE [dbo].[onca_import_column](
	[import_column_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[import_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[column_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_import_column] PRIMARY KEY CLUSTERED
(
	[import_column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_import_column]  WITH CHECK ADD  CONSTRAINT [import_node_import_colum_370] FOREIGN KEY([import_node_id])
REFERENCES [dbo].[onca_import_node] ([import_node_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_import_column] CHECK CONSTRAINT [import_node_import_colum_370]
GO
