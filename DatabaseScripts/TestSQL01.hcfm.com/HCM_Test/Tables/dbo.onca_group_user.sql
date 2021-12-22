/* CreateDate: 01/18/2005 09:34:10.360 , ModifyDate: 07/21/2014 01:22:28.873 */
GO
CREATE TABLE [dbo].[onca_group_user](
	[group_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_user] PRIMARY KEY CLUSTERED
(
	[group_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_user]  WITH CHECK ADD  CONSTRAINT [group_group_user_229] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_user] CHECK CONSTRAINT [group_group_user_229]
GO
ALTER TABLE [dbo].[onca_group_user]  WITH CHECK ADD  CONSTRAINT [user_group_user_228] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_user] CHECK CONSTRAINT [user_group_user_228]
GO
