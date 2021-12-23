/* CreateDate: 02/27/2006 15:15:42.643 , ModifyDate: 06/21/2012 10:01:04.430 */
GO
CREATE TABLE [dbo].[onca_dashboard_menu_item](
	[dashboard_menu_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dashboard_menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dashboard_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[include_separator] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_dashboard_menu_item] PRIMARY KEY CLUSTERED
(
	[dashboard_menu_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_dashboard_menu_item]  WITH CHECK ADD  CONSTRAINT [dashboard_dashboard_me_431] FOREIGN KEY([dashboard_id])
REFERENCES [dbo].[onca_dashboard] ([dashboard_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_dashboard_menu_item] CHECK CONSTRAINT [dashboard_dashboard_me_431]
GO
ALTER TABLE [dbo].[onca_dashboard_menu_item]  WITH CHECK ADD  CONSTRAINT [dashboard_me_dashboard_me_432] FOREIGN KEY([dashboard_menu_id])
REFERENCES [dbo].[onca_dashboard_menu] ([dashboard_menu_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_dashboard_menu_item] CHECK CONSTRAINT [dashboard_me_dashboard_me_432]
GO
