/* CreateDate: 01/25/2010 11:09:09.693 , ModifyDate: 06/21/2012 10:05:10.153 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_signoff_attach](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_signoff_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[storage_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_signoff_attachment] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach]  WITH CHECK ADD  CONSTRAINT [project_project_sign_1079] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach] CHECK CONSTRAINT [project_project_sign_1079]
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach]  WITH CHECK ADD  CONSTRAINT [project_sign_project_sign_773] FOREIGN KEY([project_signoff_id])
REFERENCES [dbo].[oncd_project_signoff] ([project_signoff_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach] CHECK CONSTRAINT [project_sign_project_sign_773]
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach]  WITH CHECK ADD  CONSTRAINT [user_project_sign_1027] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach] CHECK CONSTRAINT [user_project_sign_1027]
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach]  WITH CHECK ADD  CONSTRAINT [user_project_sign_1028] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_signoff_attach] CHECK CONSTRAINT [user_project_sign_1028]
GO
