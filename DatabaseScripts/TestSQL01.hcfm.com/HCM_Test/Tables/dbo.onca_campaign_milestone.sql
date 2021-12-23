/* CreateDate: 01/25/2010 11:09:09.897 , ModifyDate: 06/21/2012 10:01:08.723 */
GO
CREATE TABLE [dbo].[onca_campaign_milestone](
	[campaign_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[milestone_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[target_date] [datetime] NULL,
	[completion_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_campaign_milestone] PRIMARY KEY CLUSTERED
(
	[campaign_milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_milestone_i2] ON [dbo].[onca_campaign_milestone]
(
	[campaign_code] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_milestone_i3] ON [dbo].[onca_campaign_milestone]
(
	[milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_campaign_milestone_i4] ON [dbo].[onca_campaign_milestone]
(
	[milestone_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_campaign_milestone]  WITH NOCHECK ADD  CONSTRAINT [campaign_campaign_mil_1132] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[onca_campaign_milestone] CHECK CONSTRAINT [campaign_campaign_mil_1132]
GO
ALTER TABLE [dbo].[onca_campaign_milestone]  WITH NOCHECK ADD  CONSTRAINT [milestone_campaign_mil_1137] FOREIGN KEY([milestone_id])
REFERENCES [dbo].[onca_milestone] ([milestone_id])
GO
ALTER TABLE [dbo].[onca_campaign_milestone] CHECK CONSTRAINT [milestone_campaign_mil_1137]
GO
ALTER TABLE [dbo].[onca_campaign_milestone]  WITH NOCHECK ADD  CONSTRAINT [milestone_st_campaign_mil_1136] FOREIGN KEY([milestone_status_code])
REFERENCES [dbo].[onca_milestone_status] ([milestone_status_code])
GO
ALTER TABLE [dbo].[onca_campaign_milestone] CHECK CONSTRAINT [milestone_st_campaign_mil_1136]
GO
ALTER TABLE [dbo].[onca_campaign_milestone]  WITH NOCHECK ADD  CONSTRAINT [user_campaign_mil_1135] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onca_campaign_milestone] CHECK CONSTRAINT [user_campaign_mil_1135]
GO
