/* CreateDate: 01/18/2005 09:34:08.763 , ModifyDate: 06/21/2012 10:10:43.697 */
GO
CREATE TABLE [dbo].[oncd_company_user](
	[company_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[job_function_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_user] PRIMARY KEY CLUSTERED
(
	[company_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_user_i2] ON [dbo].[oncd_company_user]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_user_i3] ON [dbo].[oncd_company_user]
(
	[user_code] ASC,
	[job_function_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_user_i4] ON [dbo].[oncd_company_user]
(
	[job_function_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_user]  WITH CHECK ADD  CONSTRAINT [company_company_user_83] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_user] CHECK CONSTRAINT [company_company_user_83]
GO
ALTER TABLE [dbo].[oncd_company_user]  WITH CHECK ADD  CONSTRAINT [job_function_company_user_560] FOREIGN KEY([job_function_code])
REFERENCES [dbo].[onca_job_function] ([job_function_code])
GO
ALTER TABLE [dbo].[oncd_company_user] CHECK CONSTRAINT [job_function_company_user_560]
GO
ALTER TABLE [dbo].[oncd_company_user]  WITH CHECK ADD  CONSTRAINT [user_company_user_557] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_user] CHECK CONSTRAINT [user_company_user_557]
GO
ALTER TABLE [dbo].[oncd_company_user]  WITH CHECK ADD  CONSTRAINT [user_company_user_558] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_user] CHECK CONSTRAINT [user_company_user_558]
GO
ALTER TABLE [dbo].[oncd_company_user]  WITH CHECK ADD  CONSTRAINT [user_company_user_559] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_user] CHECK CONSTRAINT [user_company_user_559]
GO
