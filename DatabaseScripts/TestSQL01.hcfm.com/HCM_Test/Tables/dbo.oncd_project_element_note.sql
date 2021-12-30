/* CreateDate: 01/25/2010 11:09:09.770 , ModifyDate: 06/21/2012 10:05:10.053 */
GO
CREATE TABLE [dbo].[oncd_project_element_note](
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_element_note] PRIMARY KEY CLUSTERED
(
	[project_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_element_note]  WITH CHECK ADD  CONSTRAINT [project_elem_project_elem_754] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_element_note] CHECK CONSTRAINT [project_elem_project_elem_754]
GO
ALTER TABLE [dbo].[oncd_project_element_note]  WITH CHECK ADD  CONSTRAINT [user_project_elem_1004] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_element_note] CHECK CONSTRAINT [user_project_elem_1004]
GO
ALTER TABLE [dbo].[oncd_project_element_note]  WITH CHECK ADD  CONSTRAINT [user_project_elem_1005] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_element_note] CHECK CONSTRAINT [user_project_elem_1005]
GO
