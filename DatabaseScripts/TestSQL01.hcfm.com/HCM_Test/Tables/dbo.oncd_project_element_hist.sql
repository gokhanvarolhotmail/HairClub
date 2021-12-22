/* CreateDate: 01/25/2010 11:09:09.863 , ModifyDate: 06/21/2012 10:05:10.050 */
GO
CREATE TABLE [dbo].[oncd_project_element_hist](
	[project_element_hist_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[rate_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_element_hist] PRIMARY KEY CLUSTERED
(
	[project_element_hist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_element_hist]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_1001] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_element_hist] CHECK CONSTRAINT [project_elem_project_elem_1001]
GO
ALTER TABLE [dbo].[oncd_project_element_hist]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_1002] FOREIGN KEY([project_element_status_code])
REFERENCES [dbo].[onca_project_element_status] ([project_element_status_code])
GO
ALTER TABLE [dbo].[oncd_project_element_hist] CHECK CONSTRAINT [project_elem_project_elem_1002]
GO
ALTER TABLE [dbo].[oncd_project_element_hist]  WITH CHECK ADD  CONSTRAINT [project_revi_project_elem_763] FOREIGN KEY([project_revision_id])
REFERENCES [dbo].[oncd_project_revision] ([project_revision_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_element_hist] CHECK CONSTRAINT [project_revi_project_elem_763]
GO
ALTER TABLE [dbo].[oncd_project_element_hist]  WITH CHECK ADD  CONSTRAINT [rate_project_elem_1003] FOREIGN KEY([rate_code])
REFERENCES [dbo].[onca_rate] ([rate_code])
GO
ALTER TABLE [dbo].[oncd_project_element_hist] CHECK CONSTRAINT [rate_project_elem_1003]
GO
ALTER TABLE [dbo].[oncd_project_element_hist]  WITH CHECK ADD  CONSTRAINT [user_project_elem_1000] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_element_hist] CHECK CONSTRAINT [user_project_elem_1000]
GO
ALTER TABLE [dbo].[oncd_project_element_hist]  WITH CHECK ADD  CONSTRAINT [user_project_elem_999] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_element_hist] CHECK CONSTRAINT [user_project_elem_999]
GO
