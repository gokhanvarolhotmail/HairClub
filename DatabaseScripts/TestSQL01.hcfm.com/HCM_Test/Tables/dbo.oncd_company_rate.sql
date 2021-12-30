/* CreateDate: 01/25/2010 11:09:09.880 , ModifyDate: 06/21/2012 10:10:43.633 */
GO
CREATE TABLE [dbo].[oncd_company_rate](
	[company_rate_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[rate_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_company_rate] PRIMARY KEY CLUSTERED
(
	[company_rate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_rate]  WITH CHECK ADD  CONSTRAINT [company_company_rate_957] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_company_rate] CHECK CONSTRAINT [company_company_rate_957]
GO
ALTER TABLE [dbo].[oncd_company_rate]  WITH CHECK ADD  CONSTRAINT [rate_company_rate_1077] FOREIGN KEY([rate_code])
REFERENCES [dbo].[onca_rate] ([rate_code])
GO
ALTER TABLE [dbo].[oncd_company_rate] CHECK CONSTRAINT [rate_company_rate_1077]
GO
ALTER TABLE [dbo].[oncd_company_rate]  WITH CHECK ADD  CONSTRAINT [user_company_rate_958] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_rate] CHECK CONSTRAINT [user_company_rate_958]
GO
ALTER TABLE [dbo].[oncd_company_rate]  WITH CHECK ADD  CONSTRAINT [user_company_rate_959] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_rate] CHECK CONSTRAINT [user_company_rate_959]
GO
ALTER TABLE [dbo].[oncd_company_rate]  WITH CHECK ADD  CONSTRAINT [user_company_rate_960] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_rate] CHECK CONSTRAINT [user_company_rate_960]
GO
