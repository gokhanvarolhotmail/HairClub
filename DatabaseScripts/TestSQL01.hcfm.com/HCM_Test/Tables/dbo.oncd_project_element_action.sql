/* CreateDate: 01/25/2010 11:09:09.787 , ModifyDate: 06/21/2012 10:05:09.960 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_element_action](
	[project_element_action_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_element_action] PRIMARY KEY CLUSTERED
(
	[project_element_action_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_element_action]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_752] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_element_action] CHECK CONSTRAINT [project_elem_project_elem_752]
GO
ALTER TABLE [dbo].[oncd_project_element_action]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_991] FOREIGN KEY([project_element_status_code])
REFERENCES [dbo].[onca_project_element_status] ([project_element_status_code])
GO
ALTER TABLE [dbo].[oncd_project_element_action] CHECK CONSTRAINT [project_elem_project_elem_991]
GO
ALTER TABLE [dbo].[oncd_project_element_action]  WITH CHECK ADD  CONSTRAINT [project_mile_project_elem_758] FOREIGN KEY([project_milestone_id])
REFERENCES [dbo].[oncd_project_milestone] ([project_milestone_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_element_action] CHECK CONSTRAINT [project_mile_project_elem_758]
GO
