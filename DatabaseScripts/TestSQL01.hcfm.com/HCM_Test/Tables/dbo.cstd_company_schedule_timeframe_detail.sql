/* CreateDate: 10/04/2006 16:26:48.407 , ModifyDate: 08/11/2014 00:56:19.167 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_company_schedule_timeframe_detail](
	[company_schedule_timeframe_detail_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_schedule_timeframe_daily_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[appointment_time] [datetime] NOT NULL,
	[appointment_number] [int] NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_schedule_timeframe_detail] PRIMARY KEY NONCLUSTERED
(
	[company_schedule_timeframe_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_company_schedule_timeframe_detail_i2] ON [dbo].[cstd_company_schedule_timeframe_detail]
(
	[company_schedule_timeframe_daily_id] ASC,
	[appointment_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [cstd_company_schedule_timeframe_detail_i3] ON [dbo].[cstd_company_schedule_timeframe_detail]
(
	[company_schedule_timeframe_daily_id] ASC,
	[appointment_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_detail]  WITH CHECK ADD  CONSTRAINT [cstd_company_schedule_timeframe_daily_cstd_company_schedule_timeframe_detail_729] FOREIGN KEY([company_schedule_timeframe_daily_id])
REFERENCES [dbo].[cstd_company_schedule_timeframe_daily] ([company_schedule_timeframe_daily_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_detail] CHECK CONSTRAINT [cstd_company_schedule_timeframe_daily_cstd_company_schedule_timeframe_detail_729]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_detail]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_timeframe_detail_755] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_detail] CHECK CONSTRAINT [onca_user_cstd_company_schedule_timeframe_detail_755]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_detail]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_timeframe_detail_756] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe_detail] CHECK CONSTRAINT [onca_user_cstd_company_schedule_timeframe_detail_756]
GO
