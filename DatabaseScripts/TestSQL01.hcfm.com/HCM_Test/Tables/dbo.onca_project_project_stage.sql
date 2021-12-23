/* CreateDate: 01/25/2010 11:09:09.600 , ModifyDate: 06/21/2012 10:00:47.073 */
GO
CREATE TABLE [dbo].[onca_project_project_stage](
	[project_project_stage_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_project_project_stage] PRIMARY KEY CLUSTERED
(
	[project_project_stage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_project_project_stage]  WITH NOCHECK ADD  CONSTRAINT [project_stag_project_proj_733] FOREIGN KEY([project_stage_code])
REFERENCES [dbo].[onca_project_stage] ([project_stage_code])
GO
ALTER TABLE [dbo].[onca_project_project_stage] CHECK CONSTRAINT [project_stag_project_proj_733]
GO
ALTER TABLE [dbo].[onca_project_project_stage]  WITH NOCHECK ADD  CONSTRAINT [project_type_project_proj_736] FOREIGN KEY([project_type_code])
REFERENCES [dbo].[onca_project_type] ([project_type_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_project_stage] CHECK CONSTRAINT [project_type_project_proj_736]
GO
