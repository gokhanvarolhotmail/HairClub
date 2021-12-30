/* CreateDate: 03/28/2008 19:14:19.563 , ModifyDate: 10/23/2017 12:35:40.110 */
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
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_company_zip_code_i2] ON [dbo].[cstd_company_zip_code]
(
	[company_id] ASC,
	[zip_from] ASC,
	[zip_to] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_company_zip_code_i3] ON [dbo].[cstd_company_zip_code]
(
	[type_code] ASC,
	[company_id] ASC,
	[zip_from] ASC,
	[zip_to] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
