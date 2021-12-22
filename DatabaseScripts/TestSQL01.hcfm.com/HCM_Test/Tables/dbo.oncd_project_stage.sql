/* CreateDate: 01/25/2010 11:09:09.833 , ModifyDate: 06/21/2012 10:05:10.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_stage](
	[project_stage_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_stage_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_stage] PRIMARY KEY CLUSTERED
(
	[project_stage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_stage]  WITH CHECK ADD  CONSTRAINT [project_project_stag_749] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_stage] CHECK CONSTRAINT [project_project_stag_749]
GO
ALTER TABLE [dbo].[oncd_project_stage]  WITH CHECK ADD  CONSTRAINT [project_stag_project_stag_1080] FOREIGN KEY([project_stage_status_code])
REFERENCES [dbo].[onca_project_stage_status] ([project_stage_status_code])
GO
ALTER TABLE [dbo].[oncd_project_stage] CHECK CONSTRAINT [project_stag_project_stag_1080]
GO
ALTER TABLE [dbo].[oncd_project_stage]  WITH CHECK ADD  CONSTRAINT [user_project_stag_1030] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_stage] CHECK CONSTRAINT [user_project_stag_1030]
GO
ALTER TABLE [dbo].[oncd_project_stage]  WITH CHECK ADD  CONSTRAINT [user_project_stag_1031] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_stage] CHECK CONSTRAINT [user_project_stag_1031]
GO
