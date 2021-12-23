/* CreateDate: 10/04/2006 16:26:48.343 , ModifyDate: 05/19/2014 08:48:36.160 */
GO
CREATE TABLE [dbo].[csta_queue_user](
	[queue_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_queue_user] PRIMARY KEY NONCLUSTERED
(
	[queue_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_user]  WITH NOCHECK ADD  CONSTRAINT [csta_queue_csta_queue_user_726] FOREIGN KEY([queue_id])
REFERENCES [dbo].[csta_queue] ([queue_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_user] CHECK CONSTRAINT [csta_queue_csta_queue_user_726]
GO
ALTER TABLE [dbo].[csta_queue_user]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_queue_user_763] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_user] CHECK CONSTRAINT [onca_user_csta_queue_user_763]
GO
ALTER TABLE [dbo].[csta_queue_user]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_queue_user_764] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_user] CHECK CONSTRAINT [onca_user_csta_queue_user_764]
GO
ALTER TABLE [dbo].[csta_queue_user]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_queue_user_765] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_user] CHECK CONSTRAINT [onca_user_csta_queue_user_765]
GO
