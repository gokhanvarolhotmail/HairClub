/* CreateDate: 01/25/2010 11:09:09.770 , ModifyDate: 06/21/2012 10:05:10.043 */
GO
CREATE TABLE [dbo].[oncd_project_element_action_h](
	[project_element_action_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_action_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_element_a_hist] PRIMARY KEY CLUSTERED
(
	[project_element_action_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_element_action_h]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_992] FOREIGN KEY([project_element_action_id])
REFERENCES [dbo].[oncd_project_element_action] ([project_element_action_id])
GO
ALTER TABLE [dbo].[oncd_project_element_action_h] CHECK CONSTRAINT [project_elem_project_elem_992]
GO
ALTER TABLE [dbo].[oncd_project_element_action_h]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_993] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_element_action_h] CHECK CONSTRAINT [project_elem_project_elem_993]
GO
ALTER TABLE [dbo].[oncd_project_element_action_h]  WITH CHECK ADD  CONSTRAINT [project_mile_project_elem_994] FOREIGN KEY([project_milestone_id])
REFERENCES [dbo].[oncd_project_milestone] ([project_milestone_id])
GO
ALTER TABLE [dbo].[oncd_project_element_action_h] CHECK CONSTRAINT [project_mile_project_elem_994]
GO
ALTER TABLE [dbo].[oncd_project_element_action_h]  WITH CHECK ADD  CONSTRAINT [project_revi_project_elem_761] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
GO
ALTER TABLE [dbo].[oncd_project_element_action_h] CHECK CONSTRAINT [project_revi_project_elem_761]
GO
