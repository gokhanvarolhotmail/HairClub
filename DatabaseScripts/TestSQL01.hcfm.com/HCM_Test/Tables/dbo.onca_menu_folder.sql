/* CreateDate: 01/18/2005 09:34:10.577 , ModifyDate: 10/15/2013 00:47:09.050 */
GO
CREATE TABLE [dbo].[onca_menu_folder](
	[folder_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_folder_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_menu_folder] PRIMARY KEY CLUSTERED
(
	[folder_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_menu_folder]  WITH CHECK ADD  CONSTRAINT [menu_folder_menu_folder_257] FOREIGN KEY([parent_folder_id])
REFERENCES [dbo].[onca_menu_folder] ([folder_id])
GO
ALTER TABLE [dbo].[onca_menu_folder] CHECK CONSTRAINT [menu_folder_menu_folder_257]
GO
ALTER TABLE [dbo].[onca_menu_folder]  WITH CHECK ADD  CONSTRAINT [menu_menu_folder_256] FOREIGN KEY([menu_id])
REFERENCES [dbo].[onca_menu] ([menu_id])
GO
ALTER TABLE [dbo].[onca_menu_folder] CHECK CONSTRAINT [menu_menu_folder_256]
GO
