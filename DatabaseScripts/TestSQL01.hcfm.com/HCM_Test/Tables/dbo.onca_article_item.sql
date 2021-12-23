/* CreateDate: 03/01/2006 09:36:47.363 , ModifyDate: 06/21/2012 10:01:08.690 */
GO
CREATE TABLE [dbo].[onca_article_item](
	[article_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[article_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[article_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [PK__onca_article_ite__05A4A1EB] PRIMARY KEY CLUSTERED
(
	[article_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_article_item_i1] ON [dbo].[onca_article_item]
(
	[article_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_article_item_i2] ON [dbo].[onca_article_item]
(
	[article_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_article_item]  WITH CHECK ADD  CONSTRAINT [article_article_item_424] FOREIGN KEY([article_id])
REFERENCES [dbo].[onca_article] ([article_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_article_item] CHECK CONSTRAINT [article_article_item_424]
GO
ALTER TABLE [dbo].[onca_article_item]  WITH CHECK ADD  CONSTRAINT [article_grou_article_item_423] FOREIGN KEY([article_group_id])
REFERENCES [dbo].[onca_article_group] ([article_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_article_item] CHECK CONSTRAINT [article_grou_article_item_423]
GO
