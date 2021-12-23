/* CreateDate: 01/25/2010 10:19:20.670 , ModifyDate: 10/23/2017 12:35:40.163 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [onca_zip_i2] ON [dbo].[onca_zip]
(
	[zip_code] ASC,
	[city] ASC,
	[country_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_zip]  WITH NOCHECK ADD  CONSTRAINT [country_zip_793] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[onca_zip] CHECK CONSTRAINT [country_zip_793]
GO
ALTER TABLE [dbo].[onca_zip]  WITH NOCHECK ADD  CONSTRAINT [county_zip_794] FOREIGN KEY([county_code])
REFERENCES [dbo].[onca_county] ([county_code])
GO
ALTER TABLE [dbo].[onca_zip] CHECK CONSTRAINT [county_zip_794]
GO
ALTER TABLE [dbo].[onca_zip]  WITH NOCHECK ADD  CONSTRAINT [state_zip_795] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[onca_zip] CHECK CONSTRAINT [state_zip_795]
GO
