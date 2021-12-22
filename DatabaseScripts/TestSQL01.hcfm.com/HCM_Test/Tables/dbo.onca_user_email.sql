/* CreateDate: 01/18/2005 09:34:08.047 , ModifyDate: 06/21/2012 10:00:47.793 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_user_email](
	[user_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_user_email] PRIMARY KEY CLUSTERED
(
	[user_email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_email]  WITH CHECK ADD  CONSTRAINT [email_type_user_email_865] FOREIGN KEY([email_type_code])
REFERENCES [dbo].[onca_email_type] ([email_type_code])
GO
ALTER TABLE [dbo].[onca_user_email] CHECK CONSTRAINT [email_type_user_email_865]
GO
ALTER TABLE [dbo].[onca_user_email]  WITH CHECK ADD  CONSTRAINT [user_user_email_135] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_email] CHECK CONSTRAINT [user_user_email_135]
GO
