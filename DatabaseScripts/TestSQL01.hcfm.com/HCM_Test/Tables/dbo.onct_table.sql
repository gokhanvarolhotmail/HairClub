/* CreateDate: 01/18/2005 09:34:14.327 , ModifyDate: 06/18/2013 09:24:50.827 */
GO
CREATE TABLE [dbo].[onct_table](
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[class_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[layer_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_table] PRIMARY KEY CLUSTERED
(
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_table]  WITH NOCHECK ADD  CONSTRAINT [layer_table_1123] FOREIGN KEY([layer_code])
REFERENCES [dbo].[onct_layer] ([layer_code])
GO
ALTER TABLE [dbo].[onct_table] CHECK CONSTRAINT [layer_table_1123]
GO
