/* CreateDate: 01/25/2010 11:09:09.863 , ModifyDate: 06/21/2012 10:00:47.070 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_project_project_element](
	[project_project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
 CONSTRAINT [pk_onca_project_project_element] PRIMARY KEY CLUSTERED
(
	[project_project_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_project_project_element]  WITH CHECK ADD  CONSTRAINT [project_elem_project_proj_729] FOREIGN KEY([project_element_type_code])
REFERENCES [dbo].[onca_project_element_type] ([project_element_type_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_project_element] CHECK CONSTRAINT [project_elem_project_proj_729]
GO
ALTER TABLE [dbo].[onca_project_project_element]  WITH CHECK ADD  CONSTRAINT [project_type_project_proj_735] FOREIGN KEY([project_type_code])
REFERENCES [dbo].[onca_project_type] ([project_type_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_project_element] CHECK CONSTRAINT [project_type_project_proj_735]
GO
