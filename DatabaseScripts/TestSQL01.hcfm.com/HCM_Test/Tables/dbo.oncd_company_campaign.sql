/* CreateDate: 01/18/2005 09:34:08.530 , ModifyDate: 06/21/2012 10:10:48.370 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_company_campaign](
	[company_campaign_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_campaign] PRIMARY KEY CLUSTERED
(
	[company_campaign_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_campaign_i2] ON [dbo].[oncd_company_campaign]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_campaign_i3] ON [dbo].[oncd_company_campaign]
(
	[campaign_code] ASC,
	[stage_code] ASC,
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_campaign_i4] ON [dbo].[oncd_company_campaign]
(
	[campaign_code] ASC,
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_campaign_i5] ON [dbo].[oncd_company_campaign]
(
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_campaign]  WITH CHECK ADD  CONSTRAINT [campaign_company_camp_521] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[oncd_company_campaign] CHECK CONSTRAINT [campaign_company_camp_521]
GO
ALTER TABLE [dbo].[oncd_company_campaign]  WITH CHECK ADD  CONSTRAINT [campaign_sta_company_camp_578] FOREIGN KEY([campaign_status_code])
REFERENCES [dbo].[onca_campaign_status] ([campaign_status_code])
GO
ALTER TABLE [dbo].[oncd_company_campaign] CHECK CONSTRAINT [campaign_sta_company_camp_578]
GO
ALTER TABLE [dbo].[oncd_company_campaign]  WITH CHECK ADD  CONSTRAINT [company_company_camp_80] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_campaign] CHECK CONSTRAINT [company_company_camp_80]
GO
ALTER TABLE [dbo].[oncd_company_campaign]  WITH CHECK ADD  CONSTRAINT [user_company_camp_581] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_campaign] CHECK CONSTRAINT [user_company_camp_581]
GO
ALTER TABLE [dbo].[oncd_company_campaign]  WITH CHECK ADD  CONSTRAINT [user_company_camp_582] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_campaign] CHECK CONSTRAINT [user_company_camp_582]
GO
