/* CreateDate: 11/02/2006 10:01:08.253 , ModifyDate: 06/21/2012 10:11:17.603 */
GO
CREATE TABLE [dbo].[cstd_company_schedule_timeframe_daily](
	[company_schedule_timeframe_daily_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_schedule_timeframe_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[day_of_week] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_appointment] [datetime] NOT NULL,
	[last_appointment] [datetime] NOT NULL,
	[half_hour_appointment] [int] NULL,
	[hour_appointment] [int] NULL,
	[status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_schedule_timeframe_daily] PRIMARY KEY NONCLUSTERED
(
	[company_schedule_timeframe_daily_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_company_schedule_timeframe_daily_i2] ON [dbo].[cstd_company_schedule_timeframe_daily]
(
	[company_schedule_timeframe_id] ASC,
	[day_of_week] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_company_schedule_timeframe_id ] ON [dbo].[cstd_company_schedule_timeframe_daily]
(
	[company_schedule_timeframe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_company_schedule_timeframe_Compay_Schedule_timeframe_daily_id] ON [dbo].[cstd_company_schedule_timeframe_daily]
(
	[company_schedule_timeframe_daily_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cstd_company_schedule_timeframe_daily_creation_date] ON [dbo].[cstd_company_schedule_timeframe_daily]
(
	[creation_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_company_schedule_timeframe_daily_Day_of_Week] ON [dbo].[cstd_company_schedule_timeframe_daily]
(
	[day_of_week] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_daily]  WITH NOCHECK ADD  CONSTRAINT [cstd_company_schedule_timeframe_cstd_company_schedule_timeframe_daily_728] FOREIGN KEY([company_schedule_timeframe_id])
REFERENCES [dbo].[cstd_company_schedule_timeframe] ([company_schedule_timeframe_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_daily] CHECK CONSTRAINT [cstd_company_schedule_timeframe_cstd_company_schedule_timeframe_daily_728]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_daily]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_timeframe_daily_753] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_daily] CHECK CONSTRAINT [onca_user_cstd_company_schedule_timeframe_daily_753]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_daily]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_timeframe_daily_754] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_daily] CHECK CONSTRAINT [onca_user_cstd_company_schedule_timeframe_daily_754]
GO
