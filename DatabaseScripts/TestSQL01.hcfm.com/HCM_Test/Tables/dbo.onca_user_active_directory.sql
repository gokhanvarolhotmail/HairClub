/* CreateDate: 01/25/2010 11:09:10.100 , ModifyDate: 06/21/2012 10:00:47.753 */
GO
CREATE TABLE [dbo].[onca_user_active_directory](
	[user_active_directory_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_sid] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_user_active_directory] PRIMARY KEY CLUSTERED
(
	[user_active_directory_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_active_directory]  WITH CHECK ADD  CONSTRAINT [user_user_active__1171] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_active_directory] CHECK CONSTRAINT [user_user_active__1171]
GO
