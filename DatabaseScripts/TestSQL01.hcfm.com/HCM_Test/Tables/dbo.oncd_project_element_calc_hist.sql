/* CreateDate: 01/25/2010 11:09:09.897 , ModifyDate: 06/21/2012 10:05:10.047 */
GO
CREATE TABLE [dbo].[oncd_project_element_calc_hist](
	[project_element_calc_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_factor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[factor_type_flag] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[factor] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[quantity] [int] NOT NULL,
	[override] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[project_element_calc_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_element_calc_hist] PRIMARY KEY CLUSTERED
(
	[project_element_calc_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist]  WITH NOCHECK ADD  CONSTRAINT [project_elem_project_elem_996] FOREIGN KEY([project_element_calc_id])
REFERENCES [dbo].[oncd_project_element_calc] ([project_element_calc_id])
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist] CHECK CONSTRAINT [project_elem_project_elem_996]
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist]  WITH NOCHECK ADD  CONSTRAINT [project_elem_project_elem_997] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist] CHECK CONSTRAINT [project_elem_project_elem_997]
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist]  WITH NOCHECK ADD  CONSTRAINT [project_fact_project_elem_998] FOREIGN KEY([project_factor_code])
REFERENCES [dbo].[onca_project_factor] ([project_factor_code])
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist] CHECK CONSTRAINT [project_fact_project_elem_998]
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist]  WITH NOCHECK ADD  CONSTRAINT [project_revi_project_elem_762] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
GO
ALTER TABLE [dbo].[oncd_project_element_calc_hist] CHECK CONSTRAINT [project_revi_project_elem_762]
GO
