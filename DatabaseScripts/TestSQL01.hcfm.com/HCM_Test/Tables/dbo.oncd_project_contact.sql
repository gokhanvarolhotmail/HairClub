/* CreateDate: 01/25/2010 11:09:09.880 , ModifyDate: 06/21/2012 10:05:09.947 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_contact](
	[project_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_contact_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_contact] PRIMARY KEY CLUSTERED
(
	[project_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_contact_i2_] ON [dbo].[oncd_project_contact]
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_contact_i3_] ON [dbo].[oncd_project_contact]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_contact]  WITH CHECK ADD  CONSTRAINT [contact_project_cont_982] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_project_contact] CHECK CONSTRAINT [contact_project_cont_982]
GO
ALTER TABLE [dbo].[oncd_project_contact]  WITH CHECK ADD  CONSTRAINT [project_cont_project_cont_983] FOREIGN KEY([project_contact_role_code])
REFERENCES [dbo].[onca_project_contact_role] ([project_contact_role_code])
GO
ALTER TABLE [dbo].[oncd_project_contact] CHECK CONSTRAINT [project_cont_project_cont_983]
GO
ALTER TABLE [dbo].[oncd_project_contact]  WITH CHECK ADD  CONSTRAINT [project_project_cont_743] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_contact] CHECK CONSTRAINT [project_project_cont_743]
GO
