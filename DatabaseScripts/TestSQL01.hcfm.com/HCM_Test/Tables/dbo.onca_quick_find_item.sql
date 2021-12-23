/* CreateDate: 02/01/2005 14:59:47.403 , ModifyDate: 06/21/2012 10:00:47.143 */
GO
CREATE TABLE [dbo].[onca_quick_find_item](
	[quick_find_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[quick_find_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[quick_find_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_quick_find_item] PRIMARY KEY CLUSTERED
(
	[quick_find_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_quick_find_item]  WITH NOCHECK ADD  CONSTRAINT [quick_find_g_quick_find_i_362] FOREIGN KEY([quick_find_group_id])
REFERENCES [dbo].[onca_quick_find_group] ([quick_find_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_quick_find_item] CHECK CONSTRAINT [quick_find_g_quick_find_i_362]
GO
ALTER TABLE [dbo].[onca_quick_find_item]  WITH NOCHECK ADD  CONSTRAINT [quick_find_quick_find_i_363] FOREIGN KEY([quick_find_id])
REFERENCES [dbo].[onca_quick_find] ([quick_find_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_quick_find_item] CHECK CONSTRAINT [quick_find_quick_find_i_363]
GO
