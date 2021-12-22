/* CreateDate: 01/18/2005 09:34:09.327 , ModifyDate: 06/21/2012 10:05:17.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_opportunity_user](
	[opportunity_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[job_function_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_opportunity_user] PRIMARY KEY CLUSTERED
(
	[opportunity_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_user_i2] ON [dbo].[oncd_opportunity_user]
(
	[opportunity_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_user_i3] ON [dbo].[oncd_opportunity_user]
(
	[user_code] ASC,
	[job_function_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_user_i4] ON [dbo].[oncd_opportunity_user]
(
	[job_function_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity_user]  WITH CHECK ADD  CONSTRAINT [job_function_opportunity__705] FOREIGN KEY([job_function_code])
REFERENCES [dbo].[onca_job_function] ([job_function_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_user] CHECK CONSTRAINT [job_function_opportunity__705]
GO
ALTER TABLE [dbo].[oncd_opportunity_user]  WITH CHECK ADD  CONSTRAINT [opportunity_opportunity__156] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_user] CHECK CONSTRAINT [opportunity_opportunity__156]
GO
ALTER TABLE [dbo].[oncd_opportunity_user]  WITH CHECK ADD  CONSTRAINT [user_opportunity__702] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_user] CHECK CONSTRAINT [user_opportunity__702]
GO
ALTER TABLE [dbo].[oncd_opportunity_user]  WITH CHECK ADD  CONSTRAINT [user_opportunity__703] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_user] CHECK CONSTRAINT [user_opportunity__703]
GO
ALTER TABLE [dbo].[oncd_opportunity_user]  WITH CHECK ADD  CONSTRAINT [user_opportunity__704] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_user] CHECK CONSTRAINT [user_opportunity__704]
GO
