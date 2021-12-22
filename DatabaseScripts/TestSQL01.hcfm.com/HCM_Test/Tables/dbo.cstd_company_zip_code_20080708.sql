/* CreateDate: 07/08/2008 09:36:02.860 , ModifyDate: 01/25/2010 10:47:45.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_company_zip_code_20080708](
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
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_zip_code_20080708] ADD  CONSTRAINT [DF__cstd_comp__adi_f__russxx]  DEFAULT (' ') FOR [adi_flag]
GO
