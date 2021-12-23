/* CreateDate: 01/18/2005 09:34:08.373 , ModifyDate: 10/23/2017 12:35:40.107 */
/* ***HasTriggers*** TriggerCount: 2 */
GO
CREATE TABLE [dbo].[oncd_company](
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_name_1] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_2] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_1_search] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_2_search] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_1_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_2_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[annual_sales] [int] NULL,
	[number_of_employees] [int] NULL,
	[profile_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[external_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_method_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[do_not_solicit] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[duplicate_check] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parent_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_center_number] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_company_map_link] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_center_manager_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_director_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dma] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company] PRIMARY KEY CLUSTERED
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_company_company_id] ON [dbo].[oncd_company]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_company_cst_Center_Number] ON [dbo].[oncd_company]
(
	[cst_center_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_i2] ON [dbo].[oncd_company]
(
	[company_name_1_search] ASC,
	[company_name_2_search] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_i3] ON [dbo].[oncd_company]
(
	[company_name_2_search] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_i4] ON [dbo].[oncd_company]
(
	[parent_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_i5] ON [dbo].[oncd_company]
(
	[company_name_1_soundex] ASC,
	[company_name_2_soundex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_i6] ON [dbo].[oncd_company]
(
	[profile_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [company_company_329] FOREIGN KEY([parent_company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [company_company_329]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [company_prof_company_501] FOREIGN KEY([profile_code])
REFERENCES [dbo].[onca_company_profile] ([profile_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [company_prof_company_501]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [company_stat_company_504] FOREIGN KEY([company_status_code])
REFERENCES [dbo].[onca_company_status] ([company_status_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [company_stat_company_504]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [company_type_company_502] FOREIGN KEY([company_type_code])
REFERENCES [dbo].[onca_company_type] ([company_type_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [company_type_company_502]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [contact_meth_company_503] FOREIGN KEY([contact_method_code])
REFERENCES [dbo].[onca_contact_method] ([contact_method_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [contact_meth_company_503]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [user_company_505] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [user_company_505]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [user_company_506] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [user_company_506]
GO
ALTER TABLE [dbo].[oncd_company]  WITH NOCHECK ADD  CONSTRAINT [user_company_507] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [user_company_507]
GO
CREATE TRIGGER [dbo].[pso_oncd_company_after_delete]
   ON  [dbo].[oncd_company]
   AFTER DELETE
AS
	UPDATE cstd_contact_flat SET
		primary_center_name = NULL,
		primary_center_number = NULL
	FROM deleted
	INNER JOIN oncd_contact_company ON
		deleted.company_id = oncd_contact_company.company_id
		AND oncd_contact_company.primary_flag = 'Y'
	INNER JOIN cstd_contact_flat on cstd_contact_flat.contact_id = oncd_contact_company.contact_id
GO
ALTER TABLE [dbo].[oncd_company] ENABLE TRIGGER [pso_oncd_company_after_delete]
GO
CREATE TRIGGER [dbo].[pso_oncd_company_after_update]
   ON  [dbo].[oncd_company]
   AFTER UPDATE
AS
	UPDATE cstd_contact_flat SET
		primary_center_name = dbo.psoRemoveNonAlphaNumeric(oncd_company.company_name_1),
		primary_center_number = oncd_company.cst_center_number
	FROM oncd_company
	INNER JOIN oncd_contact_company ON
		oncd_company.company_id = oncd_contact_company.company_id
		AND oncd_contact_company.primary_flag = 'Y'
	INNER JOIN inserted on oncd_contact_company.company_id = inserted.company_id
	INNER JOIN cstd_contact_flat on cstd_contact_flat.contact_id = oncd_contact_company.contact_id
GO
ALTER TABLE [dbo].[oncd_company] ENABLE TRIGGER [pso_oncd_company_after_update]
GO
