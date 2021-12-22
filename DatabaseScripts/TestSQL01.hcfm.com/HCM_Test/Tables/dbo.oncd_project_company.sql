/* CreateDate: 01/25/2010 11:09:09.740 , ModifyDate: 06/21/2012 10:05:09.943 */
GO
CREATE TABLE [dbo].[oncd_project_company](
	[project_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_company_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_company] PRIMARY KEY CLUSTERED
(
	[project_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_company_i2] ON [dbo].[oncd_project_company]
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_project_company_i3_] ON [dbo].[oncd_project_company]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_company]  WITH CHECK ADD  CONSTRAINT [company_project_comp_980] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_project_company] CHECK CONSTRAINT [company_project_comp_980]
GO
ALTER TABLE [dbo].[oncd_project_company]  WITH CHECK ADD  CONSTRAINT [project_comp_project_comp_981] FOREIGN KEY([project_company_role_code])
REFERENCES [dbo].[onca_project_company_role] ([project_company_role_code])
GO
ALTER TABLE [dbo].[oncd_project_company] CHECK CONSTRAINT [project_comp_project_comp_981]
GO
ALTER TABLE [dbo].[oncd_project_company]  WITH CHECK ADD  CONSTRAINT [project_project_comp_742] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_project_company] CHECK CONSTRAINT [project_project_comp_742]
GO
