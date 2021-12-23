/* CreateDate: 06/01/2005 13:05:20.513 , ModifyDate: 06/21/2012 10:21:48.807 */
GO
CREATE TABLE [dbo].[oncd_activity_comment](
	[activity_comment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[creation_time] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subject] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_comment] PRIMARY KEY CLUSTERED
(
	[activity_comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_comment_i2] ON [dbo].[oncd_activity_comment]
(
	[activity_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_comment]  WITH CHECK ADD  CONSTRAINT [activity_activity_com_101] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_comment] CHECK CONSTRAINT [activity_activity_com_101]
GO
ALTER TABLE [dbo].[oncd_activity_comment]  WITH CHECK ADD  CONSTRAINT [user_activity_com_451] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_comment] CHECK CONSTRAINT [user_activity_com_451]
GO
ALTER TABLE [dbo].[oncd_activity_comment]  WITH CHECK ADD  CONSTRAINT [user_activity_com_452] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_comment] CHECK CONSTRAINT [user_activity_com_452]
GO
