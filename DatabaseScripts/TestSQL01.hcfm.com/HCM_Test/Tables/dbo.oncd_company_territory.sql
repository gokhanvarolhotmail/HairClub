/* CreateDate: 01/18/2005 09:34:08.717 , ModifyDate: 06/21/2012 10:10:43.660 */
GO
CREATE TABLE [dbo].[oncd_company_territory](
	[company_territory_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[territory_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_territory] PRIMARY KEY CLUSTERED
(
	[company_territory_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_territory_i2] ON [dbo].[oncd_company_territory]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_territory_i3] ON [dbo].[oncd_company_territory]
(
	[territory_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_territory]  WITH CHECK ADD  CONSTRAINT [company_company_terr_89] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_territory] CHECK CONSTRAINT [company_company_terr_89]
GO
ALTER TABLE [dbo].[oncd_company_territory]  WITH CHECK ADD  CONSTRAINT [territory_company_terr_556] FOREIGN KEY([territory_code])
REFERENCES [dbo].[onca_territory] ([territory_code])
GO
ALTER TABLE [dbo].[oncd_company_territory] CHECK CONSTRAINT [territory_company_terr_556]
GO
ALTER TABLE [dbo].[oncd_company_territory]  WITH CHECK ADD  CONSTRAINT [user_company_terr_554] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_territory] CHECK CONSTRAINT [user_company_terr_554]
GO
ALTER TABLE [dbo].[oncd_company_territory]  WITH CHECK ADD  CONSTRAINT [user_company_terr_555] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_territory] CHECK CONSTRAINT [user_company_terr_555]
GO
