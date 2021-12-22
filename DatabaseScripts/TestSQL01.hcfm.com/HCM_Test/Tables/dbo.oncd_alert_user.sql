/* CreateDate: 06/01/2005 17:18:03.607 , ModifyDate: 06/21/2012 10:10:58.573 */
GO
CREATE TABLE [dbo].[oncd_alert_user](
	[alert_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[alert_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_alert_user] PRIMARY KEY CLUSTERED
(
	[alert_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_alert_user_i2] ON [dbo].[oncd_alert_user]
(
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_alert_user]  WITH CHECK ADD  CONSTRAINT [alert_alert_user_398] FOREIGN KEY([alert_id])
REFERENCES [dbo].[oncd_alert] ([alert_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_alert_user] CHECK CONSTRAINT [alert_alert_user_398]
GO
ALTER TABLE [dbo].[oncd_alert_user]  WITH CHECK ADD  CONSTRAINT [user_alert_user_498] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_alert_user] CHECK CONSTRAINT [user_alert_user_498]
GO
ALTER TABLE [dbo].[oncd_alert_user]  WITH CHECK ADD  CONSTRAINT [user_alert_user_499] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_alert_user] CHECK CONSTRAINT [user_alert_user_499]
GO
ALTER TABLE [dbo].[oncd_alert_user]  WITH CHECK ADD  CONSTRAINT [user_alert_user_500] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_alert_user] CHECK CONSTRAINT [user_alert_user_500]
GO
