/* CreateDate: 05/15/2017 11:51:53.890 , ModifyDate: 05/15/2017 11:51:54.210 */
GO
CREATE TABLE [dbo].[datLeadExport](
	[LeadExportID] [int] IDENTITY(1,1) NOT NULL,
	[ExportHeaderID] [int] NOT NULL,
	[contact_contact_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_address_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_address_line_1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_address_line_2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_city] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_state_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_zip_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_country_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_time_zone_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_valid_flag] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_phone_phone_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_phone_phone_number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_phone_valid_flag] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email_email_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email_email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email_valid_flag] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_gender_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_age] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_age_range_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_age_range] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_dnc_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_experience_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_family_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_in_family_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_product] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_hair_loss_spot_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_language_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_promotion_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_source_source_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_source_source_media] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_source_source_format] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_contact_siebel_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_mail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_call] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_solicit] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_do_not_text] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_creation_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_contact_status_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_marketing_score] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_company_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_company_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_address_line_1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_address_line_2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_city] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_state_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_zip_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_country_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_region_number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_region_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_phone_number] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_managing_director] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_center_managing_director_email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[can_confirm_appointment_by_text] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_creation_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_action_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_result_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_source_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_due_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_start_time] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_completion_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_completion_time] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_birthday] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_disc_style] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_ethnicity_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_ethnicity] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_ludwig] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_maritalstatus_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_maritalstatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_no_sale_reason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_norwood] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_occupation_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_occupation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_price_quoted] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_solution_offered] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_performer] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_performer_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_demographic_performer_email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_completion_sale_type_description] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_creation_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_action_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_result_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_source_code] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_due_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_start_time] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_completion_date] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_activity_completion_time] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Household] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Household_Group] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Household_Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Zip] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Zip_Group] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Zip_Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Gender] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Combined_Age] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Education_Model] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Marital_Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Occupation_Group_V2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Latitude] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Longitude] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Match_Level_For_Geo_Data] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Est_Household_Income_V5] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_NCOA_Move_Update_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Mail_Responder] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_MOR_Bank_Upscale_Merchandise_Buyer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_MOR_Bank_Health_And_Fitness_Magazine] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_White_Only] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_Black_Only] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_Asian_Only] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_Hispanic] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Lang_HH_Spanish_Speaking] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_INC_HH_Median_Family_Household_Income] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_MatchStatus] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datLeadExport] PRIMARY KEY CLUSTERED
(
	[LeadExportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datLeadExport_ContactID] ON [dbo].[datLeadExport]
(
	[contact_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadExport_CreateDate] ON [dbo].[datLeadExport]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadExport_ExportHeaderID] ON [dbo].[datLeadExport]
(
	[ExportHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadExport_LastUpdate] ON [dbo].[datLeadExport]
(
	[LastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmpClientExport_CenterNumber] ON [dbo].[datLeadExport]
(
	[company_center_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
