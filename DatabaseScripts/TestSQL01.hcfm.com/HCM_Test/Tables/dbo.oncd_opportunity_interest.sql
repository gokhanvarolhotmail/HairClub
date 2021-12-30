/* CreateDate: 01/18/2005 09:34:09.547 , ModifyDate: 06/21/2012 10:05:17.903 */
GO
CREATE TABLE [dbo].[oncd_opportunity_interest](
	[opportunity_interest_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[interest_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[interest_sub_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[interest_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_opportunity_interest] PRIMARY KEY CLUSTERED
(
	[opportunity_interest_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_interest_i2] ON [dbo].[oncd_opportunity_interest]
(
	[opportunity_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_interest_i5] ON [dbo].[oncd_opportunity_interest]
(
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_interest_i6] ON [dbo].[oncd_opportunity_interest]
(
	[interest_code] ASC,
	[interest_sub_code] ASC,
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_interest_i7] ON [dbo].[oncd_opportunity_interest]
(
	[interest_sub_code] ASC,
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity_interest]  WITH CHECK ADD  CONSTRAINT [interest_opportunity__689] FOREIGN KEY([interest_code])
REFERENCES [dbo].[onca_interest] ([interest_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_interest] CHECK CONSTRAINT [interest_opportunity__689]
GO
ALTER TABLE [dbo].[oncd_opportunity_interest]  WITH CHECK ADD  CONSTRAINT [interest_sta_opportunity__690] FOREIGN KEY([interest_status_code])
REFERENCES [dbo].[onca_interest_status] ([interest_status_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_interest] CHECK CONSTRAINT [interest_sta_opportunity__690]
GO
ALTER TABLE [dbo].[oncd_opportunity_interest]  WITH CHECK ADD  CONSTRAINT [interest_sub_opportunity__949] FOREIGN KEY([interest_sub_code])
REFERENCES [dbo].[onca_interest_subgroup] ([interest_sub_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_interest] CHECK CONSTRAINT [interest_sub_opportunity__949]
GO
ALTER TABLE [dbo].[oncd_opportunity_interest]  WITH CHECK ADD  CONSTRAINT [opportunity_opportunity__154] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_interest] CHECK CONSTRAINT [opportunity_opportunity__154]
GO
ALTER TABLE [dbo].[oncd_opportunity_interest]  WITH CHECK ADD  CONSTRAINT [user_opportunity__691] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_interest] CHECK CONSTRAINT [user_opportunity__691]
GO
ALTER TABLE [dbo].[oncd_opportunity_interest]  WITH CHECK ADD  CONSTRAINT [user_opportunity__692] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_interest] CHECK CONSTRAINT [user_opportunity__692]
GO
