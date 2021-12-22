/* CreateDate: 01/18/2005 09:34:14.530 , ModifyDate: 06/21/2012 10:05:24.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_knowledge_keyword](
	[knowledge_keyword_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[generated_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[keyword] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_knowledge_keyword] PRIMARY KEY CLUSTERED
(
	[knowledge_keyword_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_knowledge_keyword_i2] ON [dbo].[oncd_knowledge_keyword]
(
	[knowledge_id] ASC,
	[generated_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_knowledge_keyword_i3] ON [dbo].[oncd_knowledge_keyword]
(
	[keyword] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_knowledge_keyword]  WITH CHECK ADD  CONSTRAINT [knowledge_knowledge_ke_204] FOREIGN KEY([knowledge_id])
REFERENCES [dbo].[oncd_knowledge] ([knowledge_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_knowledge_keyword] CHECK CONSTRAINT [knowledge_knowledge_ke_204]
GO
