/* CreateDate: 11/18/2014 15:41:31.393 , ModifyDate: 08/21/2015 19:42:41.353 */
GO
CREATE TABLE [dbo].[cstd_responsys_export](
	[contact_contact_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_first_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_last_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_address_line_1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_address_line_2] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_city] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_state_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_zip_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_country_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_time_zone_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_phone_phone_number] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email_email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_gender_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_age] [int] NULL,
	[contact_age_range_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_age_range] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_dnc_date] [datetime] NULL,
	[contact_hair_loss_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_experience_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_family_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_in_family_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_product] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_spot_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_language_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_promotion_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_source_source_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_source_source_media] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_source_source_format] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_contact_siebel_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_mail] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_call] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_solicit] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_text] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_creation_date] [datetime] NULL,
	[contact_contact_status_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_company_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_number] [int] NULL,
	[company_company_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_address_line_1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_address_line_2] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_city] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_state_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_zip_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_country_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_type] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_region_number] [int] NULL,
	[company_center_region_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_phone_number] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_creation_date] [datetime] NULL,
	[appointment_activity_action_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_result_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_source_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_due_date] [date] NULL,
	[appointment_activity_start_time] [time](7) NULL,
	[appointment_activity_completion_date] [date] NULL,
	[appointment_activity_completion_time] [time](7) NULL,
	[activity_demographic_birthday] [date] NULL,
	[activity_demographic_disc_style] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_ethnicity_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_ethnicity] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_ludwig] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_maritalstatus_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_maritalstatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_no_sale_reason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_norwood] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_occupation_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_occupation] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_price_quoted] [money] NULL,
	[activity_demographic_solution_offered] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_completion_sale_type_description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_creation_date] [datetime] NULL,
	[brochure_activity_action_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_result_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_source_code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_due_date] [date] NULL,
	[brochure_activity_start_time] [time](7) NULL,
	[brochure_activity_completion_date] [date] NULL,
	[brochure_activity_completion_time] [time](7) NULL
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_responsys_export_contact_id] ON [dbo].[cstd_responsys_export]
(
	[contact_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
