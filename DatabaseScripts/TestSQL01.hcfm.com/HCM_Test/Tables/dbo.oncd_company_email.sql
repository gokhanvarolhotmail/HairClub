/* CreateDate: 01/18/2005 09:34:08.547 , ModifyDate: 06/21/2012 10:10:48.370 */
GO
CREATE TABLE [dbo].[oncd_company_email](
	[company_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
 CONSTRAINT [pk_oncd_company_email] PRIMARY KEY CLUSTERED
(
	[company_email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_email_i2] ON [dbo].[oncd_company_email]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_email_i3] ON [dbo].[oncd_company_email]
(
	[email] ASC,
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_email]  WITH NOCHECK ADD  CONSTRAINT [company_company_emai_90] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_email] CHECK CONSTRAINT [company_company_emai_90]
GO
ALTER TABLE [dbo].[oncd_company_email]  WITH NOCHECK ADD  CONSTRAINT [email_type_company_emai_522] FOREIGN KEY([email_type_code])
REFERENCES [dbo].[onca_email_type] ([email_type_code])
GO
ALTER TABLE [dbo].[oncd_company_email] CHECK CONSTRAINT [email_type_company_emai_522]
GO
ALTER TABLE [dbo].[oncd_company_email]  WITH NOCHECK ADD  CONSTRAINT [user_company_emai_523] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_email] CHECK CONSTRAINT [user_company_emai_523]
GO
ALTER TABLE [dbo].[oncd_company_email]  WITH NOCHECK ADD  CONSTRAINT [user_company_emai_524] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_email] CHECK CONSTRAINT [user_company_emai_524]
GO
