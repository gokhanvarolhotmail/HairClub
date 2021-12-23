/* CreateDate: 01/25/2010 11:09:09.803 , ModifyDate: 06/21/2012 10:00:47.000 */
GO
CREATE TABLE [dbo].[onca_project_element_factor](
	[project_element_factor_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_factor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
 CONSTRAINT [pk_onca_project_element_factor] PRIMARY KEY CLUSTERED
(
	[project_element_factor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_project_element_factor]  WITH NOCHECK ADD  CONSTRAINT [project_elem_project_elem_728] FOREIGN KEY([project_element_type_code])
REFERENCES [dbo].[onca_project_element_type] ([project_element_type_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_element_factor] CHECK CONSTRAINT [project_elem_project_elem_728]
GO
ALTER TABLE [dbo].[onca_project_element_factor]  WITH NOCHECK ADD  CONSTRAINT [project_fact_project_elem_730] FOREIGN KEY([project_factor_code])
REFERENCES [dbo].[onca_project_factor] ([project_factor_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_element_factor] CHECK CONSTRAINT [project_fact_project_elem_730]
GO
