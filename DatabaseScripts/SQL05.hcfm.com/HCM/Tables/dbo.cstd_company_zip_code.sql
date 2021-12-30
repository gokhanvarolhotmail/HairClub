/* CreateDate: 01/03/2018 16:31:36.407 , ModifyDate: 11/08/2018 11:05:00.390 */
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
 CONSTRAINT [PK_cstd_company_zip_code_1] PRIMARY KEY NONCLUSTERED
(
	[company_zip_code_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [pk_cstd_company_zip_code] ON [dbo].[cstd_company_zip_code]
(
	[company_zip_code_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_company_zip_code_i2] ON [dbo].[cstd_company_zip_code]
(
	[company_id] ASC,
	[zip_from] ASC,
	[zip_to] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_company_zip_code_i3] ON [dbo].[cstd_company_zip_code]
(
	[type_code] ASC,
	[company_id] ASC,
	[zip_from] ASC,
	[zip_to] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
