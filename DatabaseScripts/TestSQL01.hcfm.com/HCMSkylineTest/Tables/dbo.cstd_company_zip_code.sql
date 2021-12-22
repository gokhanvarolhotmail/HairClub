/* CreateDate: 11/08/2012 11:22:31.397 , ModifyDate: 11/08/2012 11:22:31.487 */
GO
CREATE TABLE [dbo].[cstd_company_zip_code](
	[company_zip_code_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[zip_from] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[zip_to] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dma_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[adi_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[county] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_zip_code] PRIMARY KEY CLUSTERED
(
	[company_zip_code_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_zip_code] ADD  CONSTRAINT [DF__cstd_comp__adi_f__russ]  DEFAULT (' ') FOR [adi_flag]
GO
ALTER TABLE [dbo].[cstd_company_zip_code]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_zip_code_778] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_zip_code] CHECK CONSTRAINT [onca_user_cstd_company_zip_code_778]
GO
ALTER TABLE [dbo].[cstd_company_zip_code]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_zip_code_779] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_zip_code] CHECK CONSTRAINT [onca_user_cstd_company_zip_code_779]
GO
ALTER TABLE [dbo].[cstd_company_zip_code]  WITH CHECK ADD  CONSTRAINT [oncd_company_cstd_company_zip_code_777] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_zip_code] CHECK CONSTRAINT [oncd_company_cstd_company_zip_code_777]
GO
