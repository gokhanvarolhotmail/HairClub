/* CreateDate: 01/18/2005 09:34:10.297 , ModifyDate: 05/19/2014 08:48:36.090 */
GO
CREATE TABLE [dbo].[onca_group_query](
	[group_query_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[query_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_query] PRIMARY KEY CLUSTERED
(
	[group_query_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_query]  WITH NOCHECK ADD  CONSTRAINT [group_group_query_231] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_query] CHECK CONSTRAINT [group_group_query_231]
GO
ALTER TABLE [dbo].[onca_group_query]  WITH NOCHECK ADD  CONSTRAINT [query_group_group_query_246] FOREIGN KEY([query_group_id])
REFERENCES [dbo].[onca_query_group] ([query_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_query] CHECK CONSTRAINT [query_group_group_query_246]
GO
