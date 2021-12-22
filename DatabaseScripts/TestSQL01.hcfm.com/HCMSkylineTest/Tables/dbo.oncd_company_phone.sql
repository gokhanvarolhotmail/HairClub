/* CreateDate: 11/08/2012 13:36:46.750 , ModifyDate: 11/08/2012 13:36:46.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_company_phone](
	[company_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_phone] PRIMARY KEY CLUSTERED
(
	[company_phone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_phone]  WITH CHECK ADD  CONSTRAINT [company_company_phon_93] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_phone] CHECK CONSTRAINT [company_company_phon_93]
GO
ALTER TABLE [dbo].[oncd_company_phone]  WITH CHECK ADD  CONSTRAINT [phone_type_company_phon_540] FOREIGN KEY([phone_type_code])
REFERENCES [dbo].[onca_phone_type] ([phone_type_code])
GO
ALTER TABLE [dbo].[oncd_company_phone] CHECK CONSTRAINT [phone_type_company_phon_540]
GO
ALTER TABLE [dbo].[oncd_company_phone]  WITH CHECK ADD  CONSTRAINT [user_company_phon_538] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_phone] CHECK CONSTRAINT [user_company_phon_538]
GO
ALTER TABLE [dbo].[oncd_company_phone]  WITH CHECK ADD  CONSTRAINT [user_company_phon_539] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_phone] CHECK CONSTRAINT [user_company_phon_539]
GO
