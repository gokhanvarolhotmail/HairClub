/* CreateDate: 01/18/2005 09:34:20.717 , ModifyDate: 06/21/2012 10:05:29.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_defect_user](
	[defect_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[job_function_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_defect_user] PRIMARY KEY CLUSTERED
(
	[defect_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_user_i2] ON [dbo].[oncd_defect_user]
(
	[defect_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_user_i3] ON [dbo].[oncd_defect_user]
(
	[user_code] ASC,
	[job_function_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_user_i4] ON [dbo].[oncd_defect_user]
(
	[job_function_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_defect_user]  WITH CHECK ADD  CONSTRAINT [defect_defect_user_338] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_defect_user] CHECK CONSTRAINT [defect_defect_user_338]
GO
ALTER TABLE [dbo].[oncd_defect_user]  WITH CHECK ADD  CONSTRAINT [job_function_defect_user_651] FOREIGN KEY([job_function_code])
REFERENCES [dbo].[onca_job_function] ([job_function_code])
GO
ALTER TABLE [dbo].[oncd_defect_user] CHECK CONSTRAINT [job_function_defect_user_651]
GO
ALTER TABLE [dbo].[oncd_defect_user]  WITH CHECK ADD  CONSTRAINT [user_defect_user_648] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_user] CHECK CONSTRAINT [user_defect_user_648]
GO
ALTER TABLE [dbo].[oncd_defect_user]  WITH CHECK ADD  CONSTRAINT [user_defect_user_649] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_user] CHECK CONSTRAINT [user_defect_user_649]
GO
ALTER TABLE [dbo].[oncd_defect_user]  WITH CHECK ADD  CONSTRAINT [user_defect_user_650] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_user] CHECK CONSTRAINT [user_defect_user_650]
GO
