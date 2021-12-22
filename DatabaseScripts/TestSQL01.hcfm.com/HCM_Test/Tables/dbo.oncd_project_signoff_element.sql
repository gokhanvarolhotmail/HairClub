/* CreateDate: 01/25/2010 11:09:09.850 , ModifyDate: 06/21/2012 10:05:10.167 */
GO
CREATE TABLE [dbo].[oncd_project_signoff_element](
	[project_signoff_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_signoff_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[signoff_text] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[signoff_rate] [decimal](5, 2) NULL,
	[signoff_time] [int] NULL,
	[sort_order] [int] NULL,
	[project_element_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_signoff_element] PRIMARY KEY CLUSTERED
(
	[project_signoff_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_signoff_elemen_i2] ON [dbo].[oncd_project_signoff_element]
(
	[project_signoff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_signoff_elemen_i3] ON [dbo].[oncd_project_signoff_element]
(
	[project_element_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_signoff_element]  WITH CHECK ADD  CONSTRAINT [project_elem_project_sign_1029] FOREIGN KEY([project_element_id])
REFERENCES [dbo].[oncd_project_element] ([project_element_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff_element] CHECK CONSTRAINT [project_elem_project_sign_1029]
GO
ALTER TABLE [dbo].[oncd_project_signoff_element]  WITH CHECK ADD  CONSTRAINT [project_project_sign_952] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff_element] CHECK CONSTRAINT [project_project_sign_952]
GO
ALTER TABLE [dbo].[oncd_project_signoff_element]  WITH CHECK ADD  CONSTRAINT [project_sign_project_sign_951] FOREIGN KEY([project_signoff_id])
REFERENCES [dbo].[oncd_project_signoff] ([project_signoff_id])
GO
ALTER TABLE [dbo].[oncd_project_signoff_element] CHECK CONSTRAINT [project_sign_project_sign_951]
GO
