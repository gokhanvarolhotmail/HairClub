/* CreateDate: 09/04/2007 11:53:42.123 , ModifyDate: 09/04/2007 11:53:42.127 */
GO
CREATE TABLE [dbo].[csta_import_value_map_old](
	[admin_table_name] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[non_standard_value] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[standard_value] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
