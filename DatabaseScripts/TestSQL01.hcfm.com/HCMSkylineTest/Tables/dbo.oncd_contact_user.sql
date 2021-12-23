/* CreateDate: 11/08/2012 13:48:44.163 , ModifyDate: 11/08/2012 13:48:44.303 */
GO
CREATE TABLE [dbo].[oncd_contact_user](
	[contact_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[job_function_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_user] PRIMARY KEY CLUSTERED
(
	[contact_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_user_75] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [contact_contact_user_75]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [job_function_contact_user_626] FOREIGN KEY([job_function_code])
REFERENCES [dbo].[onca_job_function] ([job_function_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [job_function_contact_user_626]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [user_contact_user_623] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [user_contact_user_623]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [user_contact_user_624] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [user_contact_user_624]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [user_contact_user_625] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [user_contact_user_625]
GO
