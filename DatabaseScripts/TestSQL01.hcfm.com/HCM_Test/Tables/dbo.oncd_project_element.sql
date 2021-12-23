/* CreateDate: 01/25/2010 11:09:09.710 , ModifyDate: 06/21/2012 10:05:09.967 */
GO
CREATE TABLE [dbo].[oncd_project_element](
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[rate_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_element_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_element] PRIMARY KEY CLUSTERED
(
	[project_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_element_i2] ON [dbo].[oncd_project_element]
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_element_i3_] ON [dbo].[oncd_project_element]
(
	[defect_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_element_i4] ON [dbo].[oncd_project_element]
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [defect_project_elem_986] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [defect_project_elem_986]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [incident_project_elem_987] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [incident_project_elem_987]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [project_elem_project_elem_988] FOREIGN KEY([project_element_status_code])
REFERENCES [dbo].[onca_project_element_status] ([project_element_status_code])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [project_elem_project_elem_988]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [project_elem_project_elem_989] FOREIGN KEY([project_element_type_code])
REFERENCES [dbo].[onca_project_element_type] ([project_element_type_code])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [project_elem_project_elem_989]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [project_project_elem_744] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [project_project_elem_744]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [rate_project_elem_990] FOREIGN KEY([rate_code])
REFERENCES [dbo].[onca_rate] ([rate_code])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [rate_project_elem_990]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [user_project_elem_984] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [user_project_elem_984]
GO
ALTER TABLE [dbo].[oncd_project_element]  WITH NOCHECK ADD  CONSTRAINT [user_project_elem_985] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_element] CHECK CONSTRAINT [user_project_elem_985]
GO
