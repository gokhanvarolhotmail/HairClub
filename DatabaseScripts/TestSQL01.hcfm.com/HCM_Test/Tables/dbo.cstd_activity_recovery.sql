/* CreateDate: 10/04/2006 16:26:48.517 , ModifyDate: 08/11/2014 00:56:17.630 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_activity_recovery](
	[activity_recovery_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[appointment_date] [datetime] NULL,
	[appointment_time] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[arrive_on_time_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sign_in_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[associate_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[courteous_and_professional_notes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[best_options] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price_plan_offering] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[options] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[comments] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[scheduled_day_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_activity_recovery] PRIMARY KEY NONCLUSTERED
(
	[activity_recovery_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_activity_recovery] ADD  CONSTRAINT [DF__cstd_acti__arriv__45DE573A]  DEFAULT (' ') FOR [arrive_on_time_flag]
GO
ALTER TABLE [dbo].[cstd_activity_recovery] ADD  CONSTRAINT [DF__cstd_acti__sign___46D27B73]  DEFAULT (' ') FOR [sign_in_flag]
GO
ALTER TABLE [dbo].[cstd_activity_recovery] ADD  CONSTRAINT [DF__cstd_acti__sched__44EA3301]  DEFAULT (' ') FOR [scheduled_day_flag]
GO
ALTER TABLE [dbo].[cstd_activity_recovery]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_activity_recovery_737] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_activity_recovery] CHECK CONSTRAINT [onca_user_cstd_activity_recovery_737]
GO
ALTER TABLE [dbo].[cstd_activity_recovery]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_activity_recovery_738] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_activity_recovery] CHECK CONSTRAINT [onca_user_cstd_activity_recovery_738]
GO
ALTER TABLE [dbo].[cstd_activity_recovery]  WITH CHECK ADD  CONSTRAINT [oncd_activity_cstd_activity_recovery_781] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_activity_recovery] CHECK CONSTRAINT [oncd_activity_cstd_activity_recovery_781]
GO
ALTER TABLE [dbo].[cstd_activity_recovery]  WITH CHECK ADD  CONSTRAINT [oncd_company_cstd_activity_recovery_780] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_activity_recovery] CHECK CONSTRAINT [oncd_company_cstd_activity_recovery_780]
GO
