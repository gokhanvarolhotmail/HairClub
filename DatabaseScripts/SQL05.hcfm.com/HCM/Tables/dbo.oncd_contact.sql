/* CreateDate: 01/03/2018 16:31:34.960 , ModifyDate: 09/10/2020 21:23:20.180 */
GO
CREATE TABLE [dbo].[oncd_contact](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[greeting] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[middle_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[suffix] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name_search] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name_search] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name_soundex] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name_soundex] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[salutation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[external_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_method_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[do_not_solicit] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[duplicate_check] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_call_time] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_complete_sale] [int] NULL,
	[cst_research] [nchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnc_flag] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_referring_store] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_referring_stylist] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_do_not_call] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_language_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_request_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnc_date] [datetime] NULL,
	[cst_sessionid] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_affiliateid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[alt_center] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_loginid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_do_not_email] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_do_not_mail] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_do_not_text] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[surgery_consultation_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_age] [int] NULL,
	[cst_hair_loss_spot_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_experience_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_product] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_in_family_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_family_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_has_valid_cell_phone]  AS ([dbo].[psoHasValidCellPhone]([contact_id])),
	[cst_has_open_confirmation_call]  AS ([dbo].[psoHasOpenConfirmationCall]([contact_id])),
	[cst_siebel_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_previous_first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_previous_last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_contact_accomodation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_do_not_export] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_import_note] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_contact_status_code_INCL] ON [dbo].[oncd_contact]
(
	[contact_status_code] ASC,
	[cst_sfdc_lead_id] ASC,
	[creation_date] ASC
)
INCLUDE([contact_id],[cst_import_note]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_Oncd_contact_Creation_date] ON [dbo].[oncd_contact]
(
	[creation_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_creationdate_status] ON [dbo].[oncd_contact]
(
	[contact_status_code] ASC,
	[creation_date] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_CreationDateINCL] ON [dbo].[oncd_contact]
(
	[creation_date] ASC
)
INCLUDE([contact_id],[cst_gender_code],[cst_sessionid],[cst_affiliateid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_cst_do_not_export] ON [dbo].[oncd_contact]
(
	[cst_do_not_export] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_cst_sfdc_lead_id] ON [dbo].[oncd_contact]
(
	[cst_sfdc_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Oncd_Contact_LastName] ON [dbo].[oncd_contact]
(
	[last_name] ASC
)
INCLUDE([first_name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_status_updated_date] ON [dbo].[oncd_contact]
(
	[status_updated_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_StatusCode] ON [dbo].[oncd_contact]
(
	[contact_status_code] ASC
)
INCLUDE([contact_id],[creation_date],[updated_date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_oncd_contact_updated_date] ON [dbo].[oncd_contact]
(
	[updated_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [NC_HCM_contact_status_code] ON [dbo].[oncd_contact]
(
	[contact_status_code] ASC
)
INCLUDE([contact_id],[greeting],[first_name],[middle_name],[last_name],[suffix],[salutation_code],[creation_date],[updated_date],[cst_gender_code],[cst_do_not_call],[cst_language_code],[cst_promotion_code],[cst_age_range_code],[cst_hair_loss_code],[cst_do_not_email],[cst_do_not_mail],[cst_do_not_text],[cst_age],[cst_hair_loss_spot_code],[cst_hair_loss_experience_code],[cst_hair_loss_product],[cst_hair_loss_family_code],[cst_contact_accomodation_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
