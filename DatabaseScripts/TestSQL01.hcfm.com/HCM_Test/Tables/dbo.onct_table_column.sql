/* CreateDate: 01/18/2005 09:34:14.327 , ModifyDate: 06/18/2013 09:24:50.610 */
GO
CREATE TABLE [dbo].[onct_table_column](
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[layer_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_type_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[orm_type_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_table_column] PRIMARY KEY CLUSTERED
(
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_table_column_i2] ON [dbo].[onct_table_column]
(
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [onct_table_column_i3] ON [dbo].[onct_table_column]
(
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_table_column]  WITH CHECK ADD  CONSTRAINT [layer_table_column_1124] FOREIGN KEY([layer_code])
REFERENCES [dbo].[onct_layer] ([layer_code])
GO
ALTER TABLE [dbo].[onct_table_column] CHECK CONSTRAINT [layer_table_column_1124]
GO
ALTER TABLE [dbo].[onct_table_column]  WITH CHECK ADD  CONSTRAINT [table_table_column_293] FOREIGN KEY([table_name])
REFERENCES [dbo].[onct_table] ([table_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_table_column] CHECK CONSTRAINT [table_table_column_293]
GO
