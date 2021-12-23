/* CreateDate: 01/18/2005 09:34:08.750 , ModifyDate: 06/21/2012 10:10:43.677 */
GO
CREATE TABLE [dbo].[oncd_company_url](
	[company_url_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[url_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[web_address] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_url] PRIMARY KEY CLUSTERED
(
	[company_url_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_url_i2] ON [dbo].[oncd_company_url]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_url_i4] ON [dbo].[oncd_company_url]
(
	[web_address] ASC,
	[url_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_url]  WITH NOCHECK ADD  CONSTRAINT [company_company_url_87] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_url] CHECK CONSTRAINT [company_company_url_87]
GO
ALTER TABLE [dbo].[oncd_company_url]  WITH NOCHECK ADD  CONSTRAINT [url_type_company_url_872] FOREIGN KEY([url_type_code])
REFERENCES [dbo].[onca_url_type] ([url_type_code])
GO
ALTER TABLE [dbo].[oncd_company_url] CHECK CONSTRAINT [url_type_company_url_872]
GO
ALTER TABLE [dbo].[oncd_company_url]  WITH NOCHECK ADD  CONSTRAINT [user_company_url_870] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_url] CHECK CONSTRAINT [user_company_url_870]
GO
ALTER TABLE [dbo].[oncd_company_url]  WITH NOCHECK ADD  CONSTRAINT [user_company_url_871] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_url] CHECK CONSTRAINT [user_company_url_871]
GO
