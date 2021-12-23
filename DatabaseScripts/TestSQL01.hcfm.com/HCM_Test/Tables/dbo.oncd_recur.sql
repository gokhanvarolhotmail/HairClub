/* CreateDate: 01/18/2005 09:34:14.577 , ModifyDate: 06/21/2012 10:04:53.413 */
GO
CREATE TABLE [dbo].[oncd_recur](
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pattern] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pattern_frequency] [int] NULL,
	[skip_weekend_days] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[day_of_week] [int] NULL,
	[monthly_pattern] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[day_of_month] [int] NULL,
	[week_of_month] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yearly_pattern] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[month_of_year] [int] NULL,
	[start_time] [datetime] NULL,
	[duration] [int] NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notify_when_completed] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time_from] [datetime] NULL,
	[confirmed_time_to] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_recur] PRIMARY KEY CLUSTERED
(
	[recur_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i2] ON [dbo].[oncd_recur]
(
	[opportunity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i3] ON [dbo].[oncd_recur]
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i4] ON [dbo].[oncd_recur]
(
	[start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i5] ON [dbo].[oncd_recur]
(
	[end_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i6] ON [dbo].[oncd_recur]
(
	[active] ASC,
	[start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i7] ON [dbo].[oncd_recur]
(
	[campaign_code] ASC,
	[source_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_i8] ON [dbo].[oncd_recur]
(
	[source_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_recur] ADD  CONSTRAINT [DF__oncd_recu__resul__498EEC8D]  DEFAULT (' ') FOR [result_code]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [action_recur_468] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [action_recur_468]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [address_type_recur_472] FOREIGN KEY([batch_address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [address_type_recur_472]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [batch_status_recur_471] FOREIGN KEY([batch_status_code])
REFERENCES [dbo].[onca_batch_status] ([batch_status_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [batch_status_recur_471]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [campaign_recur_474] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [campaign_recur_474]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [incident_recur_215] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [incident_recur_215]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [opportunity_recur_216] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [opportunity_recur_216]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [project_recur_473] FOREIGN KEY([project_code])
REFERENCES [dbo].[onca_project] ([project_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [project_recur_473]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [project_recur_796] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [project_recur_796]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [result_recur_469] FOREIGN KEY([result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [result_recur_469]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [result_recur_470] FOREIGN KEY([batch_result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [result_recur_470]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [source_recur_475] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [source_recur_475]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [user_recur_476] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [user_recur_476]
GO
ALTER TABLE [dbo].[oncd_recur]  WITH NOCHECK ADD  CONSTRAINT [user_recur_477] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur] CHECK CONSTRAINT [user_recur_477]
GO
