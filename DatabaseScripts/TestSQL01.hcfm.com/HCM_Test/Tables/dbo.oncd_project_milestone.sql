/* CreateDate: 01/25/2010 11:09:09.770 , ModifyDate: 06/21/2012 10:05:10.063 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_milestone](
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[milestone_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_milestone] PRIMARY KEY CLUSTERED
(
	[project_milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_milestone]  WITH CHECK ADD  CONSTRAINT [project_mile_project_mile_1015] FOREIGN KEY([project_milestone_status_code])
REFERENCES [dbo].[onca_project_milestone_status] ([project_milestone_status_code])
GO
ALTER TABLE [dbo].[oncd_project_milestone] CHECK CONSTRAINT [project_mile_project_mile_1015]
GO
ALTER TABLE [dbo].[oncd_project_milestone]  WITH CHECK ADD  CONSTRAINT [project_project_mile_745] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_milestone] CHECK CONSTRAINT [project_project_mile_745]
GO
ALTER TABLE [dbo].[oncd_project_milestone]  WITH CHECK ADD  CONSTRAINT [user_project_mile_1013] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_milestone] CHECK CONSTRAINT [user_project_mile_1013]
GO
ALTER TABLE [dbo].[oncd_project_milestone]  WITH CHECK ADD  CONSTRAINT [user_project_mile_1014] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_milestone] CHECK CONSTRAINT [user_project_mile_1014]
GO
