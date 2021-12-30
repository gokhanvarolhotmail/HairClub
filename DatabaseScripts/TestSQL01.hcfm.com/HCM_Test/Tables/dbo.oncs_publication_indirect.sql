/* CreateDate: 01/18/2005 09:34:19.107 , ModifyDate: 06/21/2012 10:04:45.427 */
GO
CREATE TABLE [dbo].[oncs_publication_indirect](
	[publication_indirect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[publication_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[indirect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NOT NULL,
	[sql_action_supported] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_publication_indirect] PRIMARY KEY CLUSTERED
(
	[publication_indirect_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_publication_indirect] ADD  CONSTRAINT [DF__oncs_publ__sql_a__39E294A9]  DEFAULT ('BOTH') FOR [sql_action_supported]
GO
ALTER TABLE [dbo].[oncs_publication_indirect]  WITH CHECK ADD  CONSTRAINT [publication__publication__310] FOREIGN KEY([indirect_id])
REFERENCES [dbo].[oncs_publication_node] ([publication_node_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_indirect] CHECK CONSTRAINT [publication__publication__310]
GO
ALTER TABLE [dbo].[oncs_publication_indirect]  WITH CHECK ADD  CONSTRAINT [publication__publication__311] FOREIGN KEY([publication_node_id])
REFERENCES [dbo].[oncs_publication_node] ([publication_node_id])
GO
ALTER TABLE [dbo].[oncs_publication_indirect] CHECK CONSTRAINT [publication__publication__311]
GO
