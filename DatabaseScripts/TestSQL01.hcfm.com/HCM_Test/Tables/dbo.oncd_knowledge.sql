/* CreateDate: 01/18/2005 09:34:14.343 , ModifyDate: 06/21/2012 10:05:24.167 */
GO
CREATE TABLE [dbo].[oncd_knowledge](
	[knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[target_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[article_number] [int] NULL,
 CONSTRAINT [pk_oncd_knowledge] PRIMARY KEY CLUSTERED
(
	[knowledge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_knowledge_i3] ON [dbo].[oncd_knowledge]
(
	[target_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_knowlege_i2] ON [dbo].[oncd_knowledge]
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_knowledge]  WITH NOCHECK ADD  CONSTRAINT [entity_knowledge_876] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
GO
ALTER TABLE [dbo].[oncd_knowledge] CHECK CONSTRAINT [entity_knowledge_876]
GO
ALTER TABLE [dbo].[oncd_knowledge]  WITH NOCHECK ADD  CONSTRAINT [user_knowledge_667] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_knowledge] CHECK CONSTRAINT [user_knowledge_667]
GO
ALTER TABLE [dbo].[oncd_knowledge]  WITH NOCHECK ADD  CONSTRAINT [user_knowledge_668] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_knowledge] CHECK CONSTRAINT [user_knowledge_668]
GO
