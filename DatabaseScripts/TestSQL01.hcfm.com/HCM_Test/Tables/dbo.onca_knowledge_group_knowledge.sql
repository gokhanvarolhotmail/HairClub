/* CreateDate: 01/18/2005 09:34:20.467 , ModifyDate: 06/21/2012 10:00:56.767 */
GO
CREATE TABLE [dbo].[onca_knowledge_group_knowledge](
	[knowledge_group_knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[knowledge_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_knowledge_group_knowledge] PRIMARY KEY CLUSTERED
(
	[knowledge_group_knowledge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_knowledge_group_knowledge]  WITH NOCHECK ADD  CONSTRAINT [knowledge_gr_knowledge_gr_334] FOREIGN KEY([knowledge_group_id])
REFERENCES [dbo].[onca_knowledge_group] ([knowledge_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_knowledge_group_knowledge] CHECK CONSTRAINT [knowledge_gr_knowledge_gr_334]
GO
ALTER TABLE [dbo].[onca_knowledge_group_knowledge]  WITH NOCHECK ADD  CONSTRAINT [knowledge_knowledge_gr_1186] FOREIGN KEY([knowledge_id])
REFERENCES [dbo].[oncd_knowledge] ([knowledge_id])
GO
ALTER TABLE [dbo].[onca_knowledge_group_knowledge] CHECK CONSTRAINT [knowledge_knowledge_gr_1186]
GO
