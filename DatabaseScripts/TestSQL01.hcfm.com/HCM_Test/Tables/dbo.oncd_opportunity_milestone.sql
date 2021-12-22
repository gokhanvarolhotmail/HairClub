/* CreateDate: 01/18/2005 09:34:16.733 , ModifyDate: 06/21/2012 10:05:17.903 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_opportunity_milestone](
	[opportunity_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
 CONSTRAINT [pk_oncd_opportunity_milestone] PRIMARY KEY CLUSTERED
(
	[opportunity_milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_milestone_i2] ON [dbo].[oncd_opportunity_milestone]
(
	[opportunity_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_milestone_i3] ON [dbo].[oncd_opportunity_milestone]
(
	[milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_milestone_i4] ON [dbo].[oncd_opportunity_milestone]
(
	[milestone_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone]  WITH CHECK ADD  CONSTRAINT [milestone_opportunity__696] FOREIGN KEY([milestone_id])
REFERENCES [dbo].[onca_milestone] ([milestone_id])
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone] CHECK CONSTRAINT [milestone_opportunity__696]
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone]  WITH CHECK ADD  CONSTRAINT [milestone_st_opportunity__697] FOREIGN KEY([milestone_status_code])
REFERENCES [dbo].[onca_milestone_status] ([milestone_status_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone] CHECK CONSTRAINT [milestone_st_opportunity__697]
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone]  WITH CHECK ADD  CONSTRAINT [opportunity_opportunity__224] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone] CHECK CONSTRAINT [opportunity_opportunity__224]
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone]  WITH CHECK ADD  CONSTRAINT [user_opportunity__693] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone] CHECK CONSTRAINT [user_opportunity__693]
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone]  WITH CHECK ADD  CONSTRAINT [user_opportunity__694] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone] CHECK CONSTRAINT [user_opportunity__694]
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone]  WITH CHECK ADD  CONSTRAINT [user_opportunity__695] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_milestone] CHECK CONSTRAINT [user_opportunity__695]
GO
