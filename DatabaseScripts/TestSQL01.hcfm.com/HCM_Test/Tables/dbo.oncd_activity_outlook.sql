/* CreateDate: 01/18/2005 09:34:17.560 , ModifyDate: 06/21/2012 10:22:00.527 */
GO
CREATE TABLE [dbo].[oncd_activity_outlook](
	[activity_outlook_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[item_id] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_task_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_outlook] PRIMARY KEY CLUSTERED
(
	[activity_outlook_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_outlook_i2] ON [dbo].[oncd_activity_outlook]
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_outlook_i3] ON [dbo].[oncd_activity_outlook]
(
	[item_id] ASC,
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_outlook]  WITH NOCHECK ADD  CONSTRAINT [activity_activity_out_298] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_outlook] CHECK CONSTRAINT [activity_activity_out_298]
GO
ALTER TABLE [dbo].[oncd_activity_outlook]  WITH NOCHECK ADD  CONSTRAINT [user_activity_out_465] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_outlook] CHECK CONSTRAINT [user_activity_out_465]
GO
ALTER TABLE [dbo].[oncd_activity_outlook]  WITH NOCHECK ADD  CONSTRAINT [user_activity_out_466] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_outlook] CHECK CONSTRAINT [user_activity_out_466]
GO
ALTER TABLE [dbo].[oncd_activity_outlook]  WITH NOCHECK ADD  CONSTRAINT [user_activity_out_467] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_outlook] CHECK CONSTRAINT [user_activity_out_467]
GO
