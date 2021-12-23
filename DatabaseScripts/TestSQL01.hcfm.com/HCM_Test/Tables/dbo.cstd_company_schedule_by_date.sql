/* CreateDate: 10/04/2006 16:26:48.343 , ModifyDate: 08/11/2014 00:56:18.383 */
GO
CREATE TABLE [dbo].[cstd_company_schedule_by_date](
	[company_schedule_by_date_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[schedule_date] [datetime] NOT NULL,
	[first_appointment] [datetime] NULL,
	[last_appointment] [datetime] NULL,
	[half_hour_appointments] [int] NULL,
	[hour_appointments] [int] NULL,
	[status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_schedule_by_date] PRIMARY KEY NONCLUSTERED
(
	[company_schedule_by_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [cstd_company_schedule_by_date_i2] ON [dbo].[cstd_company_schedule_by_date]
(
	[schedule_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_by_date_757] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date] CHECK CONSTRAINT [onca_user_cstd_company_schedule_by_date_757]
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_by_date_758] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date] CHECK CONSTRAINT [onca_user_cstd_company_schedule_by_date_758]
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [oncd_company_cstd_company_schedule_by_date_802] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date] CHECK CONSTRAINT [oncd_company_cstd_company_schedule_by_date_802]
GO
