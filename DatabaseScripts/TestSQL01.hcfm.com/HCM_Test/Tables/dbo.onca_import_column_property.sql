/* CreateDate: 02/04/2005 13:09:24.000 , ModifyDate: 06/21/2012 10:00:56.670 */
GO
CREATE TABLE [dbo].[onca_import_column_property](
	[import_column_property_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[import_column_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[property_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_import_column_property] PRIMARY KEY CLUSTERED
(
	[import_column_property_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_import_column_property]  WITH NOCHECK ADD  CONSTRAINT [import_colum_import_colum_371] FOREIGN KEY([import_column_id])
REFERENCES [dbo].[onca_import_column] ([import_column_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_import_column_property] CHECK CONSTRAINT [import_colum_import_colum_371]
GO
