/* CreateDate: 11/08/2012 13:32:14.957 , ModifyDate: 11/08/2012 13:32:15.060 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_activity_user](
	[activity_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_user] PRIMARY KEY CLUSTERED
(
	[activity_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [activity_activity_use_103] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [activity_activity_use_103]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [user_activity_use_493] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [user_activity_use_493]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [user_activity_use_494] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [user_activity_use_494]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [user_activity_use_495] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [user_activity_use_495]
GO
