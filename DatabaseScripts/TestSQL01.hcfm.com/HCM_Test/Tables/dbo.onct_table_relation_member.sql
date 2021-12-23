/* CreateDate: 01/18/2005 09:34:20.950 , ModifyDate: 06/18/2013 09:24:50.813 */
GO
CREATE TABLE [dbo].[onct_table_relation_member](
	[table_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[can_navigate_to_member] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[relation_member_role_code] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[collection_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[should_collection_rank_items] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_table_relation_member] PRIMARY KEY CLUSTERED
(
	[table_relation_member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_table_relation_member_i2] ON [dbo].[onct_table_relation_member]
(
	[table_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_table_relation_member_i3] ON [dbo].[onct_table_relation_member]
(
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_table_relation_member]  WITH NOCHECK ADD  CONSTRAINT [table_relati_table_relati_342] FOREIGN KEY([table_relation_id])
REFERENCES [dbo].[onct_table_relation] ([table_relation_id])
GO
ALTER TABLE [dbo].[onct_table_relation_member] CHECK CONSTRAINT [table_relati_table_relati_342]
GO
ALTER TABLE [dbo].[onct_table_relation_member]  WITH NOCHECK ADD  CONSTRAINT [table_table_relati_341] FOREIGN KEY([table_name])
REFERENCES [dbo].[onct_table] ([table_name])
GO
ALTER TABLE [dbo].[onct_table_relation_member] CHECK CONSTRAINT [table_table_relati_341]
GO
