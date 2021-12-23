/* CreateDate: 03/01/2006 09:36:47.333 , ModifyDate: 06/21/2012 10:01:00.453 */
GO
CREATE TABLE [dbo].[onca_group_article](
	[group_article_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[article_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK__onca_group_artic__01D41107] PRIMARY KEY CLUSTERED
(
	[group_article_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_group_article_i1] ON [dbo].[onca_group_article]
(
	[article_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_group_article_i2] ON [dbo].[onca_group_article]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_article]  WITH NOCHECK ADD  CONSTRAINT [article_grou_group_articl_419] FOREIGN KEY([article_group_id])
REFERENCES [dbo].[onca_article_group] ([article_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_article] CHECK CONSTRAINT [article_grou_group_articl_419]
GO
ALTER TABLE [dbo].[onca_group_article]  WITH NOCHECK ADD  CONSTRAINT [group_group_articl_417] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_article] CHECK CONSTRAINT [group_group_articl_417]
GO
