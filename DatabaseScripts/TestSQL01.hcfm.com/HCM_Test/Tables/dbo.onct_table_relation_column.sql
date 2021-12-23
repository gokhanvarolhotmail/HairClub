/* CreateDate: 01/18/2005 09:34:20.983 , ModifyDate: 06/18/2013 09:24:50.523 */
GO
CREATE TABLE [dbo].[onct_table_relation_column](
	[table_relation_column_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onct_table_relation_column] PRIMARY KEY CLUSTERED
(
	[table_relation_column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_table_relation_column_i2] ON [dbo].[onct_table_relation_column]
(
	[table_relation_member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_table_relation_column]  WITH CHECK ADD  CONSTRAINT [table_column_table_relati_344] FOREIGN KEY([table_name], [column_name])
REFERENCES [dbo].[onct_table_column] ([table_name], [column_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_table_relation_column] CHECK CONSTRAINT [table_column_table_relati_344]
GO
ALTER TABLE [dbo].[onct_table_relation_column]  WITH CHECK ADD  CONSTRAINT [table_relati_table_relati_343] FOREIGN KEY([table_relation_member_id])
REFERENCES [dbo].[onct_table_relation_member] ([table_relation_member_id])
GO
ALTER TABLE [dbo].[onct_table_relation_column] CHECK CONSTRAINT [table_relati_table_relati_343]
GO
