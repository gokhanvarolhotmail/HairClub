/* CreateDate: 02/09/2007 10:46:30.783 , ModifyDate: 08/11/2014 00:56:18.813 */
GO
CREATE TABLE [dbo].[cstd_company_schedule_by_date_detail](
	[company_schedule_by_date_detail_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_schedule_by_date_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[appointment_time] [datetime] NOT NULL,
	[appointment_number] [int] NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_schedule_by_date_detail] PRIMARY KEY NONCLUSTERED
(
	[company_schedule_by_date_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [cstd_company_schedule_by_date_detail_i3] ON [dbo].[cstd_company_schedule_by_date_detail]
(
	[company_schedule_by_date_id] ASC,
	[appointment_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date_detail]  WITH NOCHECK ADD  CONSTRAINT [cstd_company_schedule_by_date_cstd_company_schedule_by_date_detail_818] FOREIGN KEY([company_schedule_by_date_id])
REFERENCES [dbo].[cstd_company_schedule_by_date] ([company_schedule_by_date_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date_detail] CHECK CONSTRAINT [cstd_company_schedule_by_date_cstd_company_schedule_by_date_detail_818]
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date_detail]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_by_date_detail_819] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date_detail] CHECK CONSTRAINT [onca_user_cstd_company_schedule_by_date_detail_819]
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date_detail]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_by_date_detail_820] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule_by_date_detail] CHECK CONSTRAINT [onca_user_cstd_company_schedule_by_date_detail_820]
GO
