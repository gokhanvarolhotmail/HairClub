/* CreateDate: 02/04/2005 08:29:06.763 , ModifyDate: 06/21/2012 10:05:29.340 */
GO
CREATE TABLE [dbo].[oncd_incident](
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contract_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[resolution_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[case_number] [int] NULL,
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[version_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[incident_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[part_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[incident_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assigned_to_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_date] [datetime] NULL,
	[completion_date] [datetime] NULL,
	[completion_time] [datetime] NULL,
	[completed_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[duration] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[duration_applied] [int] NULL,
 CONSTRAINT [pk_oncd_incident] PRIMARY KEY CLUSTERED
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i10] ON [dbo].[oncd_incident]
(
	[incident_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i2] ON [dbo].[oncd_incident]
(
	[company_id] ASC,
	[open_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i3] ON [dbo].[oncd_incident]
(
	[defect_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i4] ON [dbo].[oncd_incident]
(
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i5] ON [dbo].[oncd_incident]
(
	[resolution_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i6] ON [dbo].[oncd_incident]
(
	[case_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i7] ON [dbo].[oncd_incident]
(
	[product_code] ASC,
	[part_code] ASC,
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i8] ON [dbo].[oncd_incident]
(
	[part_code] ASC,
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_i9] ON [dbo].[oncd_incident]
(
	[assigned_to_user_code] ASC,
	[incident_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [company_incident_217] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [company_incident_217]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [contract_incident_375] FOREIGN KEY([contract_id])
REFERENCES [dbo].[oncd_contract] ([contract_id])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [contract_incident_375]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [defect_incident_282] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [defect_incident_282]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [defect_resol_incident_283] FOREIGN KEY([resolution_id])
REFERENCES [dbo].[oncd_defect_resolution] ([resolution_id])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [defect_resol_incident_283]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [incident_sta_incident_660] FOREIGN KEY([incident_status_code])
REFERENCES [dbo].[onca_incident_status] ([incident_status_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [incident_sta_incident_660]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [incident_typ_incident_661] FOREIGN KEY([incident_type_code])
REFERENCES [dbo].[onca_incident_type] ([incident_type_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [incident_typ_incident_661]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [product_incident_659] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [product_incident_659]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [product_part_incident_1088] FOREIGN KEY([part_code])
REFERENCES [dbo].[onca_product_part] ([part_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [product_part_incident_1088]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [product_vers_incident_1087] FOREIGN KEY([version_code])
REFERENCES [dbo].[onca_product_version] ([version_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [product_vers_incident_1087]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [user_incident_654] FOREIGN KEY([assigned_to_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [user_incident_654]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [user_incident_655] FOREIGN KEY([completed_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [user_incident_655]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [user_incident_656] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [user_incident_656]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [user_incident_657] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [user_incident_657]
GO
ALTER TABLE [dbo].[oncd_incident]  WITH NOCHECK ADD  CONSTRAINT [user_incident_658] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident] CHECK CONSTRAINT [user_incident_658]
GO
