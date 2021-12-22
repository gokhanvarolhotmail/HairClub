/* CreateDate: 01/18/2005 09:34:17.483 , ModifyDate: 06/21/2012 10:00:47.803 */
GO
CREATE TABLE [dbo].[onca_user_outlook](
	[user_outlook_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[item_id] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[update_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_appointment_folder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_task_folder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_contact_folder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_user_outlook] PRIMARY KEY CLUSTERED
(
	[user_outlook_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_outlook]  WITH CHECK ADD  CONSTRAINT [user_user_outlook_299] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_outlook] CHECK CONSTRAINT [user_user_outlook_299]
GO
