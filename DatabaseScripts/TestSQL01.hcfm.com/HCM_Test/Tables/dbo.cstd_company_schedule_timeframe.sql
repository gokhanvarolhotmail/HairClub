/* CreateDate: 10/04/2006 16:26:48.533 , ModifyDate: 06/21/2012 10:11:17.373 */
GO
CREATE TABLE [dbo].[cstd_company_schedule_timeframe](
	[company_schedule_timeframe_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_schedule_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_schedule_timeframe] PRIMARY KEY NONCLUSTERED
(
	[company_schedule_timeframe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [cstd_company_schedule_timeframe_i2] ON [dbo].[cstd_company_schedule_timeframe]
(
	[start_date] ASC,
	[end_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe] ADD  CONSTRAINT [DF__cstd_comp__activ__542C7691]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe]  WITH CHECK ADD  CONSTRAINT [cstd_company_schedule_cstd_company_schedule_timeframe_727] FOREIGN KEY([company_schedule_id])
REFERENCES [dbo].[cstd_company_schedule] ([company_schedule_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe] CHECK CONSTRAINT [cstd_company_schedule_cstd_company_schedule_timeframe_727]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_timeframe_751] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe] CHECK CONSTRAINT [onca_user_cstd_company_schedule_timeframe_751]
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_timeframe_752] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_timeframe] CHECK CONSTRAINT [onca_user_cstd_company_schedule_timeframe_752]
GO
