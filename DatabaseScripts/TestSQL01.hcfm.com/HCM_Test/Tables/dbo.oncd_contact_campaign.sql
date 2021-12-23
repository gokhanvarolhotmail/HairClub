/* CreateDate: 01/18/2005 09:34:13.983 , ModifyDate: 06/21/2012 10:05:40.220 */
GO
CREATE TABLE [dbo].[oncd_contact_campaign](
	[contact_campaign_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_campaign] PRIMARY KEY CLUSTERED
(
	[contact_campaign_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_campaign_i2] ON [dbo].[oncd_contact_campaign]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_campaign_i3] ON [dbo].[oncd_contact_campaign]
(
	[campaign_code] ASC,
	[stage_code] ASC,
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_campaign_i4] ON [dbo].[oncd_contact_campaign]
(
	[stage_code] ASC,
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_campaign_i5] ON [dbo].[oncd_contact_campaign]
(
	[campaign_code] ASC,
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_campaign_i6] ON [dbo].[oncd_contact_campaign]
(
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_campaign]  WITH NOCHECK ADD  CONSTRAINT [campaign_contact_camp_583] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[oncd_contact_campaign] CHECK CONSTRAINT [campaign_contact_camp_583]
GO
ALTER TABLE [dbo].[oncd_contact_campaign]  WITH NOCHECK ADD  CONSTRAINT [campaign_sta_contact_camp_584] FOREIGN KEY([campaign_status_code])
REFERENCES [dbo].[onca_campaign_status] ([campaign_status_code])
GO
ALTER TABLE [dbo].[oncd_contact_campaign] CHECK CONSTRAINT [campaign_sta_contact_camp_584]
GO
ALTER TABLE [dbo].[oncd_contact_campaign]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_camp_170] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_campaign] CHECK CONSTRAINT [contact_contact_camp_170]
GO
ALTER TABLE [dbo].[oncd_contact_campaign]  WITH NOCHECK ADD  CONSTRAINT [user_contact_camp_576] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_campaign] CHECK CONSTRAINT [user_contact_camp_576]
GO
ALTER TABLE [dbo].[oncd_contact_campaign]  WITH NOCHECK ADD  CONSTRAINT [user_contact_camp_577] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_campaign] CHECK CONSTRAINT [user_contact_camp_577]
GO
