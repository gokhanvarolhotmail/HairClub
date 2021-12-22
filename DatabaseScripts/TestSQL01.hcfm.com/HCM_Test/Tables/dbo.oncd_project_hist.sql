/* CreateDate: 01/25/2010 11:09:10.037 , ModifyDate: 06/21/2012 10:05:10.063 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_hist](
	[project_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[rate_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_hist] PRIMARY KEY CLUSTERED
(
	[project_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_hist]  WITH CHECK ADD  CONSTRAINT [project_project_hist_1008] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_project_hist] CHECK CONSTRAINT [project_project_hist_1008]
GO
ALTER TABLE [dbo].[oncd_project_hist]  WITH CHECK ADD  CONSTRAINT [project_revi_project_hist_764] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_hist] CHECK CONSTRAINT [project_revi_project_hist_764]
GO
ALTER TABLE [dbo].[oncd_project_hist]  WITH CHECK ADD  CONSTRAINT [project_stat_project_hist_1009] FOREIGN KEY([project_status_code])
REFERENCES [dbo].[onca_project_status] ([project_status_code])
GO
ALTER TABLE [dbo].[oncd_project_hist] CHECK CONSTRAINT [project_stat_project_hist_1009]
GO
ALTER TABLE [dbo].[oncd_project_hist]  WITH CHECK ADD  CONSTRAINT [rate_project_hist_1010] FOREIGN KEY([rate_code])
REFERENCES [dbo].[onca_rate] ([rate_code])
GO
ALTER TABLE [dbo].[oncd_project_hist] CHECK CONSTRAINT [rate_project_hist_1010]
GO
ALTER TABLE [dbo].[oncd_project_hist]  WITH CHECK ADD  CONSTRAINT [user_project_hist_1006] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_hist] CHECK CONSTRAINT [user_project_hist_1006]
GO
ALTER TABLE [dbo].[oncd_project_hist]  WITH CHECK ADD  CONSTRAINT [user_project_hist_1011] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_hist] CHECK CONSTRAINT [user_project_hist_1011]
GO
