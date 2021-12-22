/* CreateDate: 01/25/2010 11:09:09.617 , ModifyDate: 06/21/2012 10:05:10.100 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_signoff](
	[project_signoff_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[external_signoff_id] [int] NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_signoff_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sent_date] [datetime] NULL,
	[received_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_signoff] PRIMARY KEY CLUSTERED
(
	[project_signoff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_signoff_i2] ON [dbo].[oncd_project_signoff]
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_signoff]  WITH CHECK ADD  CONSTRAINT [company_project_sign_1024] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff] CHECK CONSTRAINT [company_project_sign_1024]
GO
ALTER TABLE [dbo].[oncd_project_signoff]  WITH CHECK ADD  CONSTRAINT [contact_project_sign_1025] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff] CHECK CONSTRAINT [contact_project_sign_1025]
GO
ALTER TABLE [dbo].[oncd_project_signoff]  WITH CHECK ADD  CONSTRAINT [project_project_sign_950] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff] CHECK CONSTRAINT [project_project_sign_950]
GO
ALTER TABLE [dbo].[oncd_project_signoff]  WITH CHECK ADD  CONSTRAINT [user_project_sign_1026] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_signoff] CHECK CONSTRAINT [user_project_sign_1026]
GO
ALTER TABLE [dbo].[oncd_project_signoff]  WITH CHECK ADD  CONSTRAINT [user_project_sign_953] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_signoff] CHECK CONSTRAINT [user_project_sign_953]
GO
ALTER TABLE [dbo].[oncd_project_signoff]  WITH CHECK ADD  CONSTRAINT [user_project_sign_954] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_signoff] CHECK CONSTRAINT [user_project_sign_954]
GO
