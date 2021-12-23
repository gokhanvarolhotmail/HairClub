/* CreateDate: 01/25/2010 11:09:09.723 , ModifyDate: 06/21/2012 10:05:10.173 */
GO
CREATE TABLE [dbo].[oncd_project_stage_element](
	[project_stage_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_stage_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_stage_element] PRIMARY KEY CLUSTERED
(
	[project_stage_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_stage_element]  WITH NOCHECK ADD  CONSTRAINT [project_elem_project_stag_755] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_stage_element] CHECK CONSTRAINT [project_elem_project_stag_755]
GO
ALTER TABLE [dbo].[oncd_project_stage_element]  WITH NOCHECK ADD  CONSTRAINT [project_stag_project_stag_776] FOREIGN KEY([project_stage_id])
REFERENCES [dbo].[oncd_project_stage] ([project_stage_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_stage_element] CHECK CONSTRAINT [project_stag_project_stag_776]
GO
