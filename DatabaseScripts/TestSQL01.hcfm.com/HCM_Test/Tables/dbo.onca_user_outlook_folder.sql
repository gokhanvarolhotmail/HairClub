/* CreateDate: 07/14/2005 14:21:08.307 , ModifyDate: 06/21/2012 10:00:47.803 */
GO
CREATE TABLE [dbo].[onca_user_outlook_folder](
	[user_outlook_folder_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[folder_name] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[folder_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[data_to_transfer] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[survivor_record] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_user_outlook_folder] PRIMARY KEY CLUSTERED
(
	[user_outlook_folder_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_outlook_folder]  WITH NOCHECK ADD  CONSTRAINT [user_user_outlook_401] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_outlook_folder] CHECK CONSTRAINT [user_user_outlook_401]
GO
