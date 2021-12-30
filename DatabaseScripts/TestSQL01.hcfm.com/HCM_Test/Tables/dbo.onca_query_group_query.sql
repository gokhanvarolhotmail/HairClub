/* CreateDate: 01/18/2005 09:34:07.843 , ModifyDate: 05/19/2014 08:48:36.080 */
GO
CREATE TABLE [dbo].[onca_query_group_query](
	[query_group_query_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[query_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_query_group_query] PRIMARY KEY CLUSTERED
(
	[query_group_query_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_query_group_query]  WITH CHECK ADD  CONSTRAINT [object_query_group_288] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_query_group_query] CHECK CONSTRAINT [object_query_group_288]
GO
ALTER TABLE [dbo].[onca_query_group_query]  WITH CHECK ADD  CONSTRAINT [query_group_query_group__247] FOREIGN KEY([query_group_id])
REFERENCES [dbo].[onca_query_group] ([query_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_query_group_query] CHECK CONSTRAINT [query_group_query_group__247]
GO
