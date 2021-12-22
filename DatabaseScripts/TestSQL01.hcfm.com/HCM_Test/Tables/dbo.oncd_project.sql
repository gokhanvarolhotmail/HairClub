/* CreateDate: 01/25/2010 11:09:09.553 , ModifyDate: 06/21/2012 10:05:09.873 */
GO
CREATE TABLE [dbo].[oncd_project](
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[rate_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project] PRIMARY KEY CLUSTERED
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project]  WITH CHECK ADD  CONSTRAINT [project_stat_project_975] FOREIGN KEY([project_status_code])
REFERENCES [dbo].[onca_project_status] ([project_status_code])
GO
ALTER TABLE [dbo].[oncd_project] CHECK CONSTRAINT [project_stat_project_975]
GO
ALTER TABLE [dbo].[oncd_project]  WITH CHECK ADD  CONSTRAINT [project_type_project_976] FOREIGN KEY([project_type_code])
REFERENCES [dbo].[onca_project_type] ([project_type_code])
GO
ALTER TABLE [dbo].[oncd_project] CHECK CONSTRAINT [project_type_project_976]
GO
ALTER TABLE [dbo].[oncd_project]  WITH CHECK ADD  CONSTRAINT [rate_project_977] FOREIGN KEY([rate_code])
REFERENCES [dbo].[onca_rate] ([rate_code])
GO
ALTER TABLE [dbo].[oncd_project] CHECK CONSTRAINT [rate_project_977]
GO
ALTER TABLE [dbo].[oncd_project]  WITH CHECK ADD  CONSTRAINT [user_project_946] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project] CHECK CONSTRAINT [user_project_946]
GO
ALTER TABLE [dbo].[oncd_project]  WITH CHECK ADD  CONSTRAINT [user_project_947] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project] CHECK CONSTRAINT [user_project_947]
GO
