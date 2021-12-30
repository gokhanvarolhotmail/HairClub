/* CreateDate: 12/13/2006 11:22:30.113 , ModifyDate: 06/21/2012 10:00:00.373 */
GO
CREATE TABLE [dbo].[csta_import_value_map](
	[admin_table_name] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[non_standard_value] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[standard_value] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_import_value_map] PRIMARY KEY NONCLUSTERED
(
	[admin_table_name] ASC,
	[non_standard_value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
