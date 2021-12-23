/* CreateDate: 01/25/2010 11:09:09.630 , ModifyDate: 06/21/2012 10:00:47.077 */
GO
CREATE TABLE [dbo].[onca_project_stage_element](
	[project_stage_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_project_stage_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_project_stage_element] PRIMARY KEY CLUSTERED
(
	[project_stage_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_project_stage_element]  WITH CHECK ADD  CONSTRAINT [project_proj_project_stag_731] FOREIGN KEY([project_project_element_id])
REFERENCES [dbo].[onca_project_project_element] ([project_project_element_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_stage_element] CHECK CONSTRAINT [project_proj_project_stag_731]
GO
ALTER TABLE [dbo].[onca_project_stage_element]  WITH CHECK ADD  CONSTRAINT [project_proj_project_stag_732] FOREIGN KEY([project_project_stage_id])
REFERENCES [dbo].[onca_project_project_stage] ([project_project_stage_id])
GO
ALTER TABLE [dbo].[onca_project_stage_element] CHECK CONSTRAINT [project_proj_project_stag_732]
GO
