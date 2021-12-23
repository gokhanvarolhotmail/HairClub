/* CreateDate: 02/25/2005 09:54:21.780 , ModifyDate: 06/21/2012 10:05:17.810 */
GO
CREATE TABLE [dbo].[oncd_opportunity](
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_date] [datetime] NULL,
	[close_date] [datetime] NULL,
	[expected_close_date] [datetime] NULL,
	[opportunity_amount] [decimal](15, 4) NULL,
	[budget_amount] [decimal](15, 4) NULL,
	[opportunity_method_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lost_to_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lost_reason_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[percent_to_close] [int] NULL,
	[percent_to_buy] [int] NULL,
	[opportunity_priority_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_opportunity] PRIMARY KEY CLUSTERED
(
	[opportunity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_i2] ON [dbo].[oncd_opportunity]
(
	[opportunity_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_i3] ON [dbo].[oncd_opportunity]
(
	[opportunity_method_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_i4] ON [dbo].[oncd_opportunity]
(
	[lost_to_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [company_opportunity_877] FOREIGN KEY([lost_to_company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [company_opportunity_877]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [lost_reason_opportunity_674] FOREIGN KEY([lost_reason_code])
REFERENCES [dbo].[onca_lost_reason] ([lost_reason_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [lost_reason_opportunity_674]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [method_opportunity_1138] FOREIGN KEY([opportunity_method_code])
REFERENCES [dbo].[onca_method] ([method_id])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [method_opportunity_1138]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [opportunity__opportunity_673] FOREIGN KEY([opportunity_status_code])
REFERENCES [dbo].[onca_opportunity_status] ([opportunity_status_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [opportunity__opportunity_673]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [opportunity__opportunity_675] FOREIGN KEY([opportunity_priority_code])
REFERENCES [dbo].[onca_opportunity_priority] ([opportunity_priority_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [opportunity__opportunity_675]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [opportunity__opportunity_676] FOREIGN KEY([opportunity_stage_code])
REFERENCES [dbo].[onca_opportunity_stage] ([opportunity_stage_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [opportunity__opportunity_676]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [user_opportunity_677] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [user_opportunity_677]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [user_opportunity_678] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [user_opportunity_678]
GO
ALTER TABLE [dbo].[oncd_opportunity]  WITH NOCHECK ADD  CONSTRAINT [user_opportunity_679] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity] CHECK CONSTRAINT [user_opportunity_679]
GO
