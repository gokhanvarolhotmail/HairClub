/* CreateDate: 10/04/2006 16:26:48.360 , ModifyDate: 06/21/2012 10:11:14.427 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_company_schedule](
	[company_schedule_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_appointment] [datetime] NOT NULL,
	[last_appointment] [datetime] NOT NULL,
	[interval] [int] NOT NULL,
	[half_hour_appointment] [int] NULL,
	[hour_appointment] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_cstd_company_schedule] PRIMARY KEY NONCLUSTERED
(
	[company_schedule_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ__cstd_company_sch__515009E6] ON [dbo].[cstd_company_schedule]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_schedule]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_749] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule] CHECK CONSTRAINT [onca_user_cstd_company_schedule_749]
GO
ALTER TABLE [dbo].[cstd_company_schedule]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_schedule_750] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_schedule] CHECK CONSTRAINT [onca_user_cstd_company_schedule_750]
GO
ALTER TABLE [dbo].[cstd_company_schedule]  WITH CHECK ADD  CONSTRAINT [oncd_company_cstd_company_schedule_801] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_schedule] CHECK CONSTRAINT [oncd_company_cstd_company_schedule_801]
GO
