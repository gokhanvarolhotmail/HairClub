/* CreateDate: 11/08/2012 13:31:46.923 , ModifyDate: 11/08/2012 13:31:47.030 */
GO
CREATE TABLE [dbo].[oncd_activity_contact](
	[activity_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_contact] PRIMARY KEY CLUSTERED
(
	[activity_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH NOCHECK ADD  CONSTRAINT [activity_activity_con_98] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [activity_activity_con_98]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH NOCHECK ADD  CONSTRAINT [contact_activity_con_104] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [contact_activity_con_104]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH NOCHECK ADD  CONSTRAINT [user_activity_con_455] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [user_activity_con_455]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH NOCHECK ADD  CONSTRAINT [user_activity_con_456] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [user_activity_con_456]
GO
