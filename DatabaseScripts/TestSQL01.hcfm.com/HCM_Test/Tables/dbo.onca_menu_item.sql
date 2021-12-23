/* CreateDate: 01/18/2005 09:34:10.593 , ModifyDate: 07/21/2014 01:22:37.760 */
GO
CREATE TABLE [dbo].[onca_menu_item](
	[menu_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[folder_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[item_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[icon_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_menu_item] PRIMARY KEY CLUSTERED
(
	[menu_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_menu_item]  WITH NOCHECK ADD  CONSTRAINT [menu_folder_menu_item_258] FOREIGN KEY([folder_id])
REFERENCES [dbo].[onca_menu_folder] ([folder_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_menu_item] CHECK CONSTRAINT [menu_folder_menu_item_258]
GO
ALTER TABLE [dbo].[onca_menu_item]  WITH NOCHECK ADD  CONSTRAINT [menu_menu_item_259] FOREIGN KEY([menu_id])
REFERENCES [dbo].[onca_menu] ([menu_id])
GO
ALTER TABLE [dbo].[onca_menu_item] CHECK CONSTRAINT [menu_menu_item_259]
GO
ALTER TABLE [dbo].[onca_menu_item]  WITH NOCHECK ADD  CONSTRAINT [object_menu_item_1181] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onca_menu_item] CHECK CONSTRAINT [object_menu_item_1181]
GO
ALTER TABLE [dbo].[onca_menu_item]  WITH NOCHECK ADD  CONSTRAINT [user_menu_item_843] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onca_menu_item] CHECK CONSTRAINT [user_menu_item_843]
GO
