/* CreateDate: 06/01/2005 17:18:03.607 , ModifyDate: 06/21/2012 10:10:58.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_alert](
	[alert_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[expiration_date] [datetime] NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[target_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_alert] PRIMARY KEY CLUSTERED
(
	[alert_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_alert]  WITH CHECK ADD  CONSTRAINT [entity_alert_869] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
GO
ALTER TABLE [dbo].[oncd_alert] CHECK CONSTRAINT [entity_alert_869]
GO
ALTER TABLE [dbo].[oncd_alert]  WITH CHECK ADD  CONSTRAINT [user_alert_496] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_alert] CHECK CONSTRAINT [user_alert_496]
GO
ALTER TABLE [dbo].[oncd_alert]  WITH CHECK ADD  CONSTRAINT [user_alert_497] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_alert] CHECK CONSTRAINT [user_alert_497]
GO
