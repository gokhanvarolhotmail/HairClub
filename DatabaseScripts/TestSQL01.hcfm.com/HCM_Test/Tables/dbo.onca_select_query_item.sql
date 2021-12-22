/* CreateDate: 02/01/2005 14:59:47.637 , ModifyDate: 06/21/2012 10:00:47.323 */
GO
CREATE TABLE [dbo].[onca_select_query_item](
	[select_query_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[select_query_menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[select_query_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[include_separator] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_select_query_item] PRIMARY KEY CLUSTERED
(
	[select_query_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_select_query_item]  WITH CHECK ADD  CONSTRAINT [select_query_select_query_360] FOREIGN KEY([select_query_id])
REFERENCES [dbo].[onca_select_query] ([select_query_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_select_query_item] CHECK CONSTRAINT [select_query_select_query_360]
GO
ALTER TABLE [dbo].[onca_select_query_item]  WITH CHECK ADD  CONSTRAINT [select_query_select_query_361] FOREIGN KEY([select_query_menu_id])
REFERENCES [dbo].[onca_select_query_menu] ([select_query_menu_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_select_query_item] CHECK CONSTRAINT [select_query_select_query_361]
GO
