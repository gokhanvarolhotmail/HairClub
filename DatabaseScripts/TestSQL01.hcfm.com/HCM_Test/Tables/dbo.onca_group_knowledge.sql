/* CreateDate: 01/18/2005 09:34:14.623 , ModifyDate: 06/21/2012 10:01:00.510 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_group_knowledge](
	[group_knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[knowledge_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_knowledge] PRIMARY KEY CLUSTERED
(
	[group_knowledge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_knowledge]  WITH CHECK ADD  CONSTRAINT [group_group_knowle_230] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_knowledge] CHECK CONSTRAINT [group_group_knowle_230]
GO
ALTER TABLE [dbo].[onca_group_knowledge]  WITH CHECK ADD  CONSTRAINT [knowledge_gr_group_knowle_235] FOREIGN KEY([knowledge_group_id])
REFERENCES [dbo].[onca_knowledge_group] ([knowledge_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_knowledge] CHECK CONSTRAINT [knowledge_gr_group_knowle_235]
GO
