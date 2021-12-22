/* CreateDate: 10/04/2006 16:26:48.487 , ModifyDate: 06/21/2012 10:11:11.913 */
GO
CREATE TABLE [dbo].[cstd_company_language](
	[company_language_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[language_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_language] PRIMARY KEY NONCLUSTERED
(
	[company_language_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_language] ADD  CONSTRAINT [DF__cstd_comp__prima__4E739D3B]  DEFAULT (' ') FOR [primary_flag]
GO
ALTER TABLE [dbo].[cstd_company_language]  WITH CHECK ADD  CONSTRAINT [csta_contact_language_cstd_company_language_746] FOREIGN KEY([language_code])
REFERENCES [dbo].[csta_contact_language] ([language_code])
GO
ALTER TABLE [dbo].[cstd_company_language] CHECK CONSTRAINT [csta_contact_language_cstd_company_language_746]
GO
ALTER TABLE [dbo].[cstd_company_language]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_language_747] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_language] CHECK CONSTRAINT [onca_user_cstd_company_language_747]
GO
ALTER TABLE [dbo].[cstd_company_language]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_language_748] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_language] CHECK CONSTRAINT [onca_user_cstd_company_language_748]
GO
ALTER TABLE [dbo].[cstd_company_language]  WITH CHECK ADD  CONSTRAINT [oncd_company_cstd_company_language_745] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_language] CHECK CONSTRAINT [oncd_company_cstd_company_language_745]
GO
