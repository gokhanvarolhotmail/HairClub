/* CreateDate: 11/08/2012 13:40:20.743 , ModifyDate: 07/07/2015 13:14:12.477 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_contact_email](
	[contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_valid_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_email] PRIMARY KEY CLUSTERED
(
	[contact_email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [contact_contact_emai_76] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [contact_contact_emai_76]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [email_type_contact_emai_592] FOREIGN KEY([email_type_code])
REFERENCES [dbo].[onca_email_type] ([email_type_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [email_type_contact_emai_592]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [user_contact_emai_590] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [user_contact_emai_590]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [user_contact_emai_591] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [user_contact_emai_591]
GO
