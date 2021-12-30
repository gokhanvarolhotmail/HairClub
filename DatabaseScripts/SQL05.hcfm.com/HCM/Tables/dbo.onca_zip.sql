/* CreateDate: 01/03/2018 16:31:35.453 , ModifyDate: 11/08/2018 11:05:01.120 */
GO
CREATE TABLE [dbo].[onca_zip](
	[zip_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[zip_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[latitude] [decimal](15, 4) NULL,
	[longitude] [decimal](15, 4) NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[finance_code] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_line] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[facility_code] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msa_code] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pmsa_code] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dma] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_city_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_zip] PRIMARY KEY CLUSTERED
(
	[zip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_onca_zip_zip_code] ON [dbo].[onca_zip]
(
	[zip_code] ASC,
	[city] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
