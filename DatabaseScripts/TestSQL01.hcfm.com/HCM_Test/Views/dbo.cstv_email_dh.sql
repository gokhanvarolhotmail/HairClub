/* CreateDate: 05/02/2012 14:05:38.710 , ModifyDate: 06/21/2012 16:47:05.353 */
GO
CREATE VIEW [dbo].[cstv_email_dh]
AS

SELECT [contact_alt_center]
      ,[contact_contact_id]
      ,[contact_contact_method_code]
      ,[contact_contact_status_code]
      ,[contact_created_by_user_code]
      ,[contact_creation_date]
      ,[contact_affiliateid]
      ,[contact_age]
      ,[contact_age_range_code]
      ,[contact_call_time]
      ,[contact_complete_sale]
      ,[contact_dnc_date]
      ,[contact_dnc_flag]
      ,[contact_do_not_call]
      ,[contact_do_not_email]
      ,[contact_do_not_mail]
      ,[contact_do_not_text]
      ,[contact_gender_code]
      ,[contact_hair_loss_code]
      ,[contact_hair_loss_experience_code]
      ,[contact_hair_loss_family_code]
      ,[contact_hair_loss_in_family_code]
      ,[contact_hair_loss_product]
      ,[contact_hair_loss_spot_code]
      ,[contact_language_code]
      ,[contact_loginid]
      ,[contact_promotion_code]
      ,[contact_referring_store]
      ,[contact_referring_stylist]
      ,[contact_request_code]
      ,[contact_research]
      ,[contact_sessionid]
      ,[contact_do_not_solicit]
      ,[contact_duplicate_check]
      ,[contact_external_id]
      ,[contact_first_name]
      ,[contact_first_name_search]
      ,[contact_first_name_soundex]
      ,[contact_greeting]
      ,[contact_last_name]
      ,[contact_last_name_search]
      ,[contact_last_name_soundex]
      ,[contact_middle_name]
      ,[contact_salutation_code]
      ,[contact_status_updated_by_user_code]
      ,[contact_status_updated_date]
      ,[contact_suffix]
      ,[contact_surgery_consultation_flag]
      ,[contact_updated_by_user_code]
      ,[contact_updated_date]
      ,[contact_phone_active]
      ,[contact_phone_area_code]
      ,[contact_phone_contact_id]
      ,[contact_phone_contact_phone_id]
      ,[contact_phone_country_code_prefix]
      ,[contact_phone_created_by_user_code]
      ,[contact_phone_creation_date]
      ,[contact_phone_description]
      ,[contact_phone_extension]
      ,[contact_phone_phone_number]
      ,[contact_phone_phone_type_code]
      ,[contact_phone_primary_flag]
      ,[contact_phone_sort_order]
      ,[contact_phone_updated_by_user_code]
      ,[contact_phone_updated_date]
      ,[contact_address_address_line_1]
      ,[contact_address_address_line_1_soundex]
      ,[contact_address_address_line_2]
      ,[contact_address_address_line_2_soundex]
      ,[contact_address_address_line_3]
      ,[contact_address_address_line_4]
      ,[contact_address_address_type_code]
      ,[contact_address_city]
      ,[contact_address_city_soundex]
      ,[contact_address_company_address_id]
      ,[contact_address_contact_address_id]
      ,[contact_address_contact_id]
      ,[contact_address_country_code]
      ,[contact_address_county_code]
      ,[contact_address_created_by_user_code]
      ,[contact_address_creation_date]
      ,[contact_address_primary_flag]
      ,[contact_address_sort_order]
      ,[contact_address_state_code]
      ,[contact_address_time_zone_code]
      ,[contact_address_updated_by_user_code]
      ,[contact_address_updated_date]
      ,[contact_address_zip_code]
      ,[contact_age_range_active]
      ,[contact_age_range_age_range_code]
      ,[contact_age_range_description]
      ,[contact_age_range_maximum_age]
      ,[contact_age_range_minimum_age]
      ,[contact_email_active]
      ,[contact_email_contact_email_id]
      ,[contact_email_contact_id]
      ,[contact_email_created_by_user_code]
      ,[contact_email_creation_date]
      ,[contact_email_description]
      ,[contact_email_email]
      ,[contact_email_email_type_code]
      ,[contact_email_primary_flag]
      ,[contact_email_sort_order]
      ,[contact_email_updated_by_user_code]
      ,[contact_email_updated_date]
      ,[contact_company_company_id]
      ,[contact_company_company_role_code]
      ,[contact_company_contact_company_id]
      ,[contact_company_contact_id]
      ,[contact_company_created_by_user_code]
      ,[contact_company_creation_date]
      ,[contact_company_preferred_center_flag]
      ,[contact_company_department_code]
      ,[contact_company_description]
      ,[contact_company_internal_title_code]
      ,[contact_company_primary_flag]
      ,[contact_company_reports_to_contact_id]
      ,[contact_company_sort_order]
      ,[contact_company_title]
      ,[contact_company_updated_by_user_code]
      ,[contact_company_updated_date]
      ,[company_annual_sales]
      ,[company_company_id]
      ,[company_company_name_1]
      ,[company_company_name_1_search]
      ,[company_company_name_1_soundex]
      ,[company_company_name_2]
      ,[company_company_name_2_search]
      ,[company_company_name_2_soundex]
      ,[company_company_status_code]
      ,[company_company_type_code]
      ,[company_contact_method_code]
      ,[company_created_by_user_code]
      ,[company_creation_date]
      ,[company_center_manager_name]
      ,[company_center_number]
      ,[company_company_map_link]
      ,[company_director_name]
      ,[company_dma]
      ,[company_do_not_solicit]
      ,[company_duplicate_check]
      ,[company_external_id]
      ,[company_number_of_employees]
      ,[company_parent_company_id]
      ,[company_profile_code]
      ,[company_status_updated_by_user_code]
      ,[company_status_updated_date]
      ,[company_updated_by_user_code]
      ,[company_updated_date]
      ,[company_address_address_line_1]
      ,[company_address_address_line_1_soundex]
      ,[company_address_address_line_2]
      ,[company_address_address_line_2_soundex]
      ,[company_address_address_line_3]
      ,[company_address_address_line_4]
      ,[company_address_address_type_code]
      ,[company_address_city]
      ,[company_address_city_soundex]
      ,[company_address_company_address_id]
      ,[company_address_company_id]
      ,[company_address_country_code]
      ,[company_address_county_code]
      ,[company_address_created_by_user_code]
      ,[company_address_creation_date]
      ,[company_address_primary_flag]
      ,[company_address_sort_order]
      ,[company_address_state_code]
      ,[company_address_time_zone_code]
      ,[company_address_updated_by_user_code]
      ,[company_address_updated_date]
      ,[company_address_zip_code]
      ,[appointment_activity_action_code]
      ,[appointment_activity_activity_id]
      ,[appointment_activity_batch_address_type_code]
      ,[appointment_activity_batch_result_code]
      ,[appointment_activity_batch_status_code]
      ,[appointment_activity_campaign_code]
      ,[appointment_activity_completed_by_user_code]
      ,[appointment_activity_completion_date]
      ,[appointment_activity_completion_time]
      ,[appointment_activity_confirmed_time]
      ,[appointment_activity_confirmed_time_from]
      ,[appointment_activity_confirmed_time_to]
      ,[appointment_activity_created_by_user_code]
      ,[appointment_activity_creation_date]
      ,[appointment_activity_activity_type_code]
      ,[appointment_activity_followup_date]
      ,[appointment_activity_followup_time]
      ,[appointment_activity_lock_by_user_code]
      ,[appointment_activity_lock_date]
      ,[appointment_activity_no_followup_flag]
      ,[appointment_activity_override_time_zone]
      ,[appointment_activity_promotion_code]
      ,[appointment_activity_time_zone_code]
      ,[appointment_activity_utc_start_date]
      ,[appointment_activity_description]
      ,[appointment_activity_document_id]
      ,[appointment_activity_due_date]
      ,[appointment_activity_duration]
      ,[appointment_activity_incident_id]
      ,[appointment_activity_milestone_activity_id]
      ,[appointment_activity_notify_when_completed]
      ,[appointment_activity_opportunity_id]
      ,[appointment_activity_priority]
      ,[appointment_activity_project_code]
      ,[appointment_activity_project_id]
      ,[appointment_activity_recur_id]
      ,[appointment_activity_result_code]
      ,[appointment_activity_source_code]
      ,[appointment_activity_start_time]
      ,[appointment_activity_updated_by_user_code]
      ,[appointment_activity_updated_date]
      ,[brochure_activity_action_code]
      ,[brochure_activity_activity_id]
      ,[brochure_activity_batch_address_type_code]
      ,[brochure_activity_batch_result_code]
      ,[brochure_activity_batch_status_code]
      ,[brochure_activity_campaign_code]
      ,[brochure_activity_completed_by_user_code]
      ,[brochure_activity_completion_date]
      ,[brochure_activity_completion_time]
      ,[brochure_activity_confirmed_time]
      ,[brochure_activity_confirmed_time_from]
      ,[brochure_activity_confirmed_time_to]
      ,[brochure_activity_created_by_user_code]
      ,[brochure_activity_creation_date]
      ,[brochure_activity_activity_type_code]
      ,[brochure_activity_followup_date]
      ,[brochure_activity_followup_time]
      ,[brochure_activity_lock_by_user_code]
      ,[brochure_activity_lock_date]
      ,[brochure_activity_no_followup_flag]
      ,[brochure_activity_override_time_zone]
      ,[brochure_activity_promotion_code]
      ,[brochure_activity_time_zone_code]
      ,[brochure_activity_utc_start_date]
      ,[brochure_activity_description]
      ,[brochure_activity_document_id]
      ,[brochure_activity_due_date]
      ,[brochure_activity_duration]
      ,[brochure_activity_incident_id]
      ,[brochure_activity_milestone_activity_id]
      ,[brochure_activity_notify_when_completed]
      ,[brochure_activity_opportunity_id]
      ,[brochure_activity_priority]
      ,[brochure_activity_project_code]
      ,[brochure_activity_project_id]
      ,[brochure_activity_recur_id]
      ,[brochure_activity_result_code]
      ,[brochure_activity_source_code]
      ,[brochure_activity_start_time]
      ,[brochure_activity_updated_by_user_code]
      ,[brochure_activity_updated_date]
      ,[activity_demographic_activity_demographic_id]
      ,[activity_demographic_activity_id]
      ,[activity_demographic_age]
      ,[activity_demographic_birthday]
      ,[activity_demographic_created_by_user_code]
      ,[activity_demographic_creation_date]
      ,[activity_demographic_disc_style]
      ,[activity_demographic_ethnicity_code]
      ,[activity_demographic_gender]
      ,[activity_demographic_ludwig]
      ,[activity_demographic_maritalstatus_code]
      ,[activity_demographic_no_sale_reason]
      ,[activity_demographic_norwood]
      ,[activity_demographic_occupation_code]
      ,[activity_demographic_performer]
      ,[activity_demographic_price_quoted]
      ,[activity_demographic_solution_offered]
      ,[activity_demographic_updated_by_user_code]
      ,[activity_demographic_updated_date]
      ,[contact_source_assignment_date]
      ,[contact_source_contact_id]
      ,[contact_source_contact_source_id]
      ,[contact_source_created_by_user_code]
      ,[contact_source_creation_date]
      ,[contact_source_dnis_number]
      ,[contact_source_sub_source_code]
      ,[contact_source_media_code]
      ,[contact_source_primary_flag]
      ,[contact_source_sort_order]
      ,[contact_source_source_code]
      ,[contact_source_updated_by_user_code]
      ,[contact_source_updated_date]
      ,[appointment_activity_user_activity_id]
      ,[appointment_activity_user_activity_user_id]
      ,[appointment_activity_user_assignment_date]
      ,[appointment_activity_user_attendance]
      ,[appointment_activity_user_created_by_user_code]
      ,[appointment_activity_user_creation_date]
      ,[appointment_activity_user_primary_flag]
      ,[appointment_activity_user_sort_order]
      ,[appointment_activity_user_updated_by_user_code]
      ,[appointment_activity_user_updated_date]
      ,[appointment_activity_user_user_code]
      ,[brochure_activity_user_activity_id]
      ,[brochure_activity_user_activity_user_id]
      ,[brochure_activity_user_assignment_date]
      ,[brochure_activity_user_attendance]
      ,[brochure_activity_user_created_by_user_code]
      ,[brochure_activity_user_creation_date]
      ,[brochure_activity_user_primary_flag]
      ,[brochure_activity_user_sort_order]
      ,[brochure_activity_user_updated_by_user_code]
      ,[brochure_activity_user_updated_date]
      ,[brochure_activity_user_user_code]
      ,[contact_completion_activity_id]
      ,[contact_completion_balance_amount]
      ,[contact_completion_balance_percentage]
      ,[contact_completion_base_price]
      ,[contact_completion_client_number]
      ,[contact_completion_comment]
      ,[contact_completion_company_id]
      ,[contact_completion_contact_completion_id]
      ,[contact_completion_contact_id]
      ,[contact_completion_contract_amount]
      ,[contact_completion_contract_number]
      ,[contact_completion_created_by_user_code]
      ,[contact_completion_creation_date]
      ,[contact_completion_date_rescheduled]
      ,[contact_completion_date_saved]
      ,[contact_completion_discount_amount]
      ,[contact_completion_discount_markup_flag]
      ,[contact_completion_discount_percentage]
      ,[contact_completion_followup_result]
      ,[contact_completion_followup_result_id]
      ,[contact_completion_hair_length]
      ,[contact_completion_head_size]
      ,[contact_completion_initial_payment]
      ,[contact_completion_length_price]
      ,[contact_completion_number_of_graphs]
      ,[contact_completion_original_appointment_date]
      ,[contact_completion_referred_to_doctor_flag]
      ,[contact_completion_reschedule_flag]
      ,[contact_completion_sale_no_sale_flag]
      ,[contact_completion_sale_type_code]
      ,[contact_completion_sale_type_description]
      ,[contact_completion_services]
      ,[contact_completion_show_no_show_flag]
      ,[contact_completion_status_line]
      ,[contact_completion_surgery_consultation_flag]
      ,[contact_completion_surgery_offered_flag]
      ,[contact_completion_systems]
      ,[contact_completion_time_rescheduled]
      ,[contact_completion_updated_by_user_code]
      ,[contact_completion_updated_date]
  FROM [cstd_email_dh_flat]


--SELECT
--oncd_contact.alt_center AS contact_alt_center,
--oncd_contact.contact_id AS contact_contact_id,
--oncd_contact.contact_method_code AS contact_contact_method_code,
--oncd_contact.contact_status_code AS contact_contact_status_code,
--oncd_contact.created_by_user_code AS contact_created_by_user_code,
--oncd_contact.creation_date AS contact_creation_date,
--oncd_contact.cst_affiliateid AS contact_affiliateid,
--oncd_contact.cst_age AS contact_age,
--oncd_contact.cst_age_range_code AS contact_age_range_code,
--oncd_contact.cst_call_time AS contact_call_time,
--oncd_contact.cst_complete_sale AS contact_complete_sale,
--oncd_contact.cst_dnc_date AS contact_dnc_date,
--oncd_contact.cst_dnc_flag AS contact_dnc_flag,
--oncd_contact.cst_do_not_call AS contact_do_not_call,
--oncd_contact.cst_do_not_email AS contact_do_not_email,
--oncd_contact.cst_do_not_mail AS contact_do_not_mail,
--oncd_contact.cst_do_not_text AS contact_do_not_text,
--oncd_contact.cst_gender_code AS contact_gender_code,
--oncd_contact.cst_hair_loss_code AS contact_hair_loss_code,
--oncd_contact.cst_hair_loss_experience_code AS contact_hair_loss_experience_code,
--oncd_contact.cst_hair_loss_family_code AS contact_hair_loss_family_code,
--oncd_contact.cst_hair_loss_in_family_code AS contact_hair_loss_in_family_code,
--oncd_contact.cst_hair_loss_product AS contact_hair_loss_product,
--oncd_contact.cst_hair_loss_spot_code AS contact_hair_loss_spot_code,
--oncd_contact.cst_language_code AS contact_language_code,
--oncd_contact.cst_loginid AS contact_loginid,
--oncd_contact.cst_promotion_code AS contact_promotion_code,
--oncd_contact.cst_referring_store AS contact_referring_store,
--oncd_contact.cst_referring_stylist AS contact_referring_stylist,
--oncd_contact.cst_request_code AS contact_request_code,
--oncd_contact.cst_research AS contact_research,
--oncd_contact.cst_sessionid AS contact_sessionid,
--oncd_contact.do_not_solicit AS contact_do_not_solicit,
--oncd_contact.duplicate_check AS contact_duplicate_check,
--oncd_contact.external_id AS contact_external_id,
--oncd_contact.first_name AS contact_first_name,
--oncd_contact.first_name_search AS contact_first_name_search,
--oncd_contact.first_name_soundex AS contact_first_name_soundex,
--oncd_contact.greeting AS contact_greeting,
--oncd_contact.last_name AS contact_last_name,
--oncd_contact.last_name_search AS contact_last_name_search,
--oncd_contact.last_name_soundex AS contact_last_name_soundex,
--oncd_contact.middle_name AS contact_middle_name,
--oncd_contact.salutation_code AS contact_salutation_code,
--oncd_contact.status_updated_by_user_code AS contact_status_updated_by_user_code,
--oncd_contact.status_updated_date AS contact_status_updated_date,
--oncd_contact.suffix AS contact_suffix,
--oncd_contact.surgery_consultation_flag AS contact_surgery_consultation_flag,
--oncd_contact.updated_by_user_code AS contact_updated_by_user_code,
--oncd_contact.updated_date AS contact_updated_date,
--oncd_contact_phone.active AS contact_phone_active,
--oncd_contact_phone.area_code AS contact_phone_area_code,
--oncd_contact_phone.contact_id AS contact_phone_contact_id,
--oncd_contact_phone.contact_phone_id AS contact_phone_contact_phone_id,
--oncd_contact_phone.country_code_prefix AS contact_phone_country_code_prefix,
--oncd_contact_phone.created_by_user_code AS contact_phone_created_by_user_code,
--oncd_contact_phone.creation_date AS contact_phone_creation_date,
----oncd_contact_phone.cst_invalid_flag AS contact_phone_invalid_flag,
----oncd_contact_phone.cst_service_tier AS contact_phone_service_tier,
----oncd_contact_phone.cst_vendor_code AS contact_phone_vendor_code,
--oncd_contact_phone.description AS contact_phone_description,
--oncd_contact_phone.extension AS contact_phone_extension,
--oncd_contact_phone.phone_number AS contact_phone_phone_number,
--oncd_contact_phone.phone_type_code AS contact_phone_phone_type_code,
--oncd_contact_phone.primary_flag AS contact_phone_primary_flag,
--oncd_contact_phone.sort_order AS contact_phone_sort_order,
--oncd_contact_phone.updated_by_user_code AS contact_phone_updated_by_user_code,
--oncd_contact_phone.updated_date AS contact_phone_updated_date,
--oncd_contact_address.address_line_1 AS contact_address_address_line_1,
--oncd_contact_address.address_line_1_soundex AS contact_address_address_line_1_soundex,
--oncd_contact_address.address_line_2 AS contact_address_address_line_2,
--oncd_contact_address.address_line_2_soundex AS contact_address_address_line_2_soundex,
--oncd_contact_address.address_line_3 AS contact_address_address_line_3,
--oncd_contact_address.address_line_4 AS contact_address_address_line_4,
--oncd_contact_address.address_type_code AS contact_address_address_type_code,
--oncd_contact_address.city AS contact_address_city,
--oncd_contact_address.city_soundex AS contact_address_city_soundex,
--oncd_contact_address.company_address_id AS contact_address_company_address_id,
--oncd_contact_address.contact_address_id AS contact_address_contact_address_id,
--oncd_contact_address.contact_id AS contact_address_contact_id,
--oncd_contact_address.country_code AS contact_address_country_code,
--oncd_contact_address.county_code AS contact_address_county_code,
--oncd_contact_address.created_by_user_code AS contact_address_created_by_user_code,
--oncd_contact_address.creation_date AS contact_address_creation_date,
----oncd_contact_address.cst_invalid_flag AS contact_address_invalid_flag,
----oncd_contact_address.cst_service_tier AS contact_address_service_tier,
----oncd_contact_address.cst_vendor_code AS contact_address_vendor_code,
--oncd_contact_address.primary_flag AS contact_address_primary_flag,
--oncd_contact_address.sort_order AS contact_address_sort_order,
--oncd_contact_address.state_code AS contact_address_state_code,
--oncd_contact_address.time_zone_code AS contact_address_time_zone_code,
--oncd_contact_address.updated_by_user_code AS contact_address_updated_by_user_code,
--oncd_contact_address.updated_date AS contact_address_updated_date,
--oncd_contact_address.zip_code AS contact_address_zip_code,
--csta_contact_age_range.active AS contact_age_range_active,
--csta_contact_age_range.age_range_code AS contact_age_range_age_range_code,
--csta_contact_age_range.description AS contact_age_range_description,
--csta_contact_age_range.maximum_age AS contact_age_range_maximum_age,
--csta_contact_age_range.minimum_age AS contact_age_range_minimum_age,
--oncd_contact_email.active AS contact_email_active,
--oncd_contact_email.contact_email_id AS contact_email_contact_email_id,
--oncd_contact_email.contact_id AS contact_email_contact_id,
--oncd_contact_email.created_by_user_code AS contact_email_created_by_user_code,
--oncd_contact_email.creation_date AS contact_email_creation_date,
--oncd_contact_email.description AS contact_email_description,
--oncd_contact_email.email AS contact_email_email,
--oncd_contact_email.email_type_code AS contact_email_email_type_code,
--oncd_contact_email.primary_flag AS contact_email_primary_flag,
--oncd_contact_email.sort_order AS contact_email_sort_order,
--oncd_contact_email.updated_by_user_code AS contact_email_updated_by_user_code,
--oncd_contact_email.updated_date AS contact_email_updated_date,
--oncd_contact_company.company_id AS contact_company_company_id,
--oncd_contact_company.company_role_code AS contact_company_company_role_code,
--oncd_contact_company.contact_company_id AS contact_company_contact_company_id,
--oncd_contact_company.contact_id AS contact_company_contact_id,
--oncd_contact_company.created_by_user_code AS contact_company_created_by_user_code,
--oncd_contact_company.creation_date AS contact_company_creation_date,
--oncd_contact_company.cst_preferred_center_flag AS contact_company_preferred_center_flag,
--oncd_contact_company.department_code AS contact_company_department_code,
--oncd_contact_company.description AS contact_company_description,
--oncd_contact_company.internal_title_code AS contact_company_internal_title_code,
--oncd_contact_company.primary_flag AS contact_company_primary_flag,
--oncd_contact_company.reports_to_contact_id AS contact_company_reports_to_contact_id,
--oncd_contact_company.sort_order AS contact_company_sort_order,
--oncd_contact_company.title AS contact_company_title,
--oncd_contact_company.updated_by_user_code AS contact_company_updated_by_user_code,
--oncd_contact_company.updated_date AS contact_company_updated_date,
--oncd_company.annual_sales AS company_annual_sales,
--oncd_company.company_id AS company_company_id,
--oncd_company.company_name_1 AS company_company_name_1,
--oncd_company.company_name_1_search AS company_company_name_1_search,
--oncd_company.company_name_1_soundex AS company_company_name_1_soundex,
--oncd_company.company_name_2 AS company_company_name_2,
--oncd_company.company_name_2_search AS company_company_name_2_search,
--oncd_company.company_name_2_soundex AS company_company_name_2_soundex,
--oncd_company.company_status_code AS company_company_status_code,
--oncd_company.company_type_code AS company_company_type_code,
--oncd_company.contact_method_code AS company_contact_method_code,
--oncd_company.created_by_user_code AS company_created_by_user_code,
--oncd_company.creation_date AS company_creation_date,
--oncd_company.cst_center_manager_name AS company_center_manager_name,
--oncd_company.cst_center_number AS company_center_number,
--oncd_company.cst_company_map_link AS company_company_map_link,
--oncd_company.cst_director_name AS company_director_name,
--oncd_company.cst_dma AS company_dma,
--oncd_company.do_not_solicit AS company_do_not_solicit,
--oncd_company.duplicate_check AS company_duplicate_check,
--oncd_company.external_id AS company_external_id,
--oncd_company.number_of_employees AS company_number_of_employees,
--oncd_company.parent_company_id AS company_parent_company_id,
--oncd_company.profile_code AS company_profile_code,
--oncd_company.status_updated_by_user_code AS company_status_updated_by_user_code,
--oncd_company.status_updated_date AS company_status_updated_date,
--oncd_company.updated_by_user_code AS company_updated_by_user_code,
--oncd_company.updated_date AS company_updated_date,
--oncd_company_address.address_line_1 AS company_address_address_line_1,
--oncd_company_address.address_line_1_soundex AS company_address_address_line_1_soundex,
--oncd_company_address.address_line_2 AS company_address_address_line_2,
--oncd_company_address.address_line_2_soundex AS company_address_address_line_2_soundex,
--oncd_company_address.address_line_3 AS company_address_address_line_3,
--oncd_company_address.address_line_4 AS company_address_address_line_4,
--oncd_company_address.address_type_code AS company_address_address_type_code,
--oncd_company_address.city AS company_address_city,
--oncd_company_address.city_soundex AS company_address_city_soundex,
--oncd_company_address.company_address_id AS company_address_company_address_id,
--oncd_company_address.company_id AS company_address_company_id,
--oncd_company_address.country_code AS company_address_country_code,
--oncd_company_address.county_code AS company_address_county_code,
--oncd_company_address.created_by_user_code AS company_address_created_by_user_code,
--oncd_company_address.creation_date AS company_address_creation_date,
--oncd_company_address.primary_flag AS company_address_primary_flag,
--oncd_company_address.sort_order AS company_address_sort_order,
--oncd_company_address.state_code AS company_address_state_code,
--oncd_company_address.time_zone_code AS company_address_time_zone_code,
--oncd_company_address.updated_by_user_code AS company_address_updated_by_user_code,
--oncd_company_address.updated_date AS company_address_updated_date,
--oncd_company_address.zip_code AS company_address_zip_code,
--appointment_activity.action_code AS appointment_activity_action_code,
--appointment_activity.activity_id AS appointment_activity_activity_id,
--appointment_activity.batch_address_type_code AS appointment_activity_batch_address_type_code,
--appointment_activity.batch_result_code AS appointment_activity_batch_result_code,
--appointment_activity.batch_status_code AS appointment_activity_batch_status_code,
--appointment_activity.campaign_code AS appointment_activity_campaign_code,
--appointment_activity.completed_by_user_code AS appointment_activity_completed_by_user_code,
--appointment_activity.completion_date AS appointment_activity_completion_date,
--appointment_activity.completion_time AS appointment_activity_completion_time,
--appointment_activity.confirmed_time AS appointment_activity_confirmed_time,
--appointment_activity.confirmed_time_from AS appointment_activity_confirmed_time_from,
--appointment_activity.confirmed_time_to AS appointment_activity_confirmed_time_to,
--appointment_activity.created_by_user_code AS appointment_activity_created_by_user_code,
--appointment_activity.creation_date AS appointment_activity_creation_date,
--appointment_activity.cst_activity_type_code AS appointment_activity_activity_type_code,
----appointment_activity.cst_brochure_download AS appointment_activity_brochure_download,
--appointment_activity.cst_followup_date AS appointment_activity_followup_date,
--appointment_activity.cst_followup_time AS appointment_activity_followup_time,
--appointment_activity.cst_lock_by_user_code AS appointment_activity_lock_by_user_code,
--appointment_activity.cst_lock_date AS appointment_activity_lock_date,
--appointment_activity.cst_no_followup_flag AS appointment_activity_no_followup_flag,
--appointment_activity.cst_override_time_zone AS appointment_activity_override_time_zone,
--appointment_activity.cst_promotion_code AS appointment_activity_promotion_code,
--appointment_activity.cst_time_zone_code AS appointment_activity_time_zone_code,
--appointment_activity.cst_utc_start_date AS appointment_activity_utc_start_date,
--appointment_activity.description AS appointment_activity_description,
--appointment_activity.document_id AS appointment_activity_document_id,
--appointment_activity.due_date AS appointment_activity_due_date,
--appointment_activity.duration AS appointment_activity_duration,
--appointment_activity.incident_id AS appointment_activity_incident_id,
--appointment_activity.milestone_activity_id AS appointment_activity_milestone_activity_id,
--appointment_activity.notify_when_completed AS appointment_activity_notify_when_completed,
--appointment_activity.opportunity_id AS appointment_activity_opportunity_id,
--appointment_activity.priority AS appointment_activity_priority,
--appointment_activity.project_code AS appointment_activity_project_code,
--appointment_activity.project_id AS appointment_activity_project_id,
--appointment_activity.recur_id AS appointment_activity_recur_id,
--appointment_activity.result_code AS appointment_activity_result_code,
--appointment_activity.source_code AS appointment_activity_source_code,
--appointment_activity.start_time AS appointment_activity_start_time,
--appointment_activity.updated_by_user_code AS appointment_activity_updated_by_user_code,
--appointment_activity.updated_date AS appointment_activity_updated_date,
--brochure_activity.action_code AS brochure_activity_action_code,
--brochure_activity.activity_id AS brochure_activity_activity_id,
--brochure_activity.batch_address_type_code AS brochure_activity_batch_address_type_code,
--brochure_activity.batch_result_code AS brochure_activity_batch_result_code,
--brochure_activity.batch_status_code AS brochure_activity_batch_status_code,
--brochure_activity.campaign_code AS brochure_activity_campaign_code,
--brochure_activity.completed_by_user_code AS brochure_activity_completed_by_user_code,
--brochure_activity.completion_date AS brochure_activity_completion_date,
--brochure_activity.completion_time AS brochure_activity_completion_time,
--brochure_activity.confirmed_time AS brochure_activity_confirmed_time,
--brochure_activity.confirmed_time_from AS brochure_activity_confirmed_time_from,
--brochure_activity.confirmed_time_to AS brochure_activity_confirmed_time_to,
--brochure_activity.created_by_user_code AS brochure_activity_created_by_user_code,
--brochure_activity.creation_date AS brochure_activity_creation_date,
--brochure_activity.cst_activity_type_code AS brochure_activity_activity_type_code,
----brochure_activity.cst_brochure_download AS brochure_activity_brochure_download,
--brochure_activity.cst_followup_date AS brochure_activity_followup_date,
--brochure_activity.cst_followup_time AS brochure_activity_followup_time,
--brochure_activity.cst_lock_by_user_code AS brochure_activity_lock_by_user_code,
--brochure_activity.cst_lock_date AS brochure_activity_lock_date,
--brochure_activity.cst_no_followup_flag AS brochure_activity_no_followup_flag,
--brochure_activity.cst_override_time_zone AS brochure_activity_override_time_zone,
--brochure_activity.cst_promotion_code AS brochure_activity_promotion_code,
--brochure_activity.cst_time_zone_code AS brochure_activity_time_zone_code,
--brochure_activity.cst_utc_start_date AS brochure_activity_utc_start_date,
--brochure_activity.description AS brochure_activity_description,
--brochure_activity.document_id AS brochure_activity_document_id,
--brochure_activity.due_date AS brochure_activity_due_date,
--brochure_activity.duration AS brochure_activity_duration,
--brochure_activity.incident_id AS brochure_activity_incident_id,
--brochure_activity.milestone_activity_id AS brochure_activity_milestone_activity_id,
--brochure_activity.notify_when_completed AS brochure_activity_notify_when_completed,
--brochure_activity.opportunity_id AS brochure_activity_opportunity_id,
--brochure_activity.priority AS brochure_activity_priority,
--brochure_activity.project_code AS brochure_activity_project_code,
--brochure_activity.project_id AS brochure_activity_project_id,
--brochure_activity.recur_id AS brochure_activity_recur_id,
--brochure_activity.result_code AS brochure_activity_result_code,
--brochure_activity.source_code AS brochure_activity_source_code,
--brochure_activity.start_time AS brochure_activity_start_time,
--brochure_activity.updated_by_user_code AS brochure_activity_updated_by_user_code,
--brochure_activity.updated_date AS brochure_activity_updated_date,
--cstd_activity_demographic.activity_demographic_id AS activity_demographic_activity_demographic_id,
--cstd_activity_demographic.activity_id AS activity_demographic_activity_id,
--cstd_activity_demographic.age AS activity_demographic_age,
--cstd_activity_demographic.birthday AS activity_demographic_birthday,
--cstd_activity_demographic.created_by_user_code AS activity_demographic_created_by_user_code,
--cstd_activity_demographic.creation_date AS activity_demographic_creation_date,
--cstd_activity_demographic.disc_style AS activity_demographic_disc_style,
--cstd_activity_demographic.ethnicity_code AS activity_demographic_ethnicity_code,
--cstd_activity_demographic.gender AS activity_demographic_gender,
--cstd_activity_demographic.ludwig AS activity_demographic_ludwig,
--cstd_activity_demographic.maritalstatus_code AS activity_demographic_maritalstatus_code,
--cstd_activity_demographic.no_sale_reason AS activity_demographic_no_sale_reason,
--cstd_activity_demographic.norwood AS activity_demographic_norwood,
--cstd_activity_demographic.occupation_code AS activity_demographic_occupation_code,
--cstd_activity_demographic.performer AS activity_demographic_performer,
--cstd_activity_demographic.price_quoted AS activity_demographic_price_quoted,
--cstd_activity_demographic.solution_offered AS activity_demographic_solution_offered,
--cstd_activity_demographic.updated_by_user_code AS activity_demographic_updated_by_user_code,
--cstd_activity_demographic.updated_date AS activity_demographic_updated_date,
--oncd_contact_source.assignment_date AS contact_source_assignment_date,
--oncd_contact_source.contact_id AS contact_source_contact_id,
--oncd_contact_source.contact_source_id AS contact_source_contact_source_id,
--oncd_contact_source.created_by_user_code AS contact_source_created_by_user_code,
--oncd_contact_source.creation_date AS contact_source_creation_date,
--oncd_contact_source.cst_dnis_number AS contact_source_dnis_number,
--oncd_contact_source.cst_sub_source_code AS contact_source_sub_source_code,
--oncd_contact_source.media_code AS contact_source_media_code,
--oncd_contact_source.primary_flag AS contact_source_primary_flag,
--oncd_contact_source.sort_order AS contact_source_sort_order,
--oncd_contact_source.source_code AS contact_source_source_code,
--oncd_contact_source.updated_by_user_code AS contact_source_updated_by_user_code,
--oncd_contact_source.updated_date AS contact_source_updated_date,
--appointment_activity_user.activity_id AS appointment_activity_user_activity_id,
--appointment_activity_user.activity_user_id AS appointment_activity_user_activity_user_id,
--appointment_activity_user.assignment_date AS appointment_activity_user_assignment_date,
--appointment_activity_user.attendance AS appointment_activity_user_attendance,
--appointment_activity_user.created_by_user_code AS appointment_activity_user_created_by_user_code,
--appointment_activity_user.creation_date AS appointment_activity_user_creation_date,
--appointment_activity_user.primary_flag AS appointment_activity_user_primary_flag,
--appointment_activity_user.sort_order AS appointment_activity_user_sort_order,
--appointment_activity_user.updated_by_user_code AS appointment_activity_user_updated_by_user_code,
--appointment_activity_user.updated_date AS appointment_activity_user_updated_date,
--appointment_activity_user.user_code AS appointment_activity_user_user_code,
--brochure_activity_user.activity_id AS brochure_activity_user_activity_id,
--brochure_activity_user.activity_user_id AS brochure_activity_user_activity_user_id,
--brochure_activity_user.assignment_date AS brochure_activity_user_assignment_date,
--brochure_activity_user.attendance AS brochure_activity_user_attendance,
--brochure_activity_user.created_by_user_code AS brochure_activity_user_created_by_user_code,
--brochure_activity_user.creation_date AS brochure_activity_user_creation_date,
--brochure_activity_user.primary_flag AS brochure_activity_user_primary_flag,
--brochure_activity_user.sort_order AS brochure_activity_user_sort_order,
--brochure_activity_user.updated_by_user_code AS brochure_activity_user_updated_by_user_code,
--brochure_activity_user.updated_date AS brochure_activity_user_updated_date,
--brochure_activity_user.user_code AS brochure_activity_user_user_code,
--cstd_contact_completion.activity_id AS contact_completion_activity_id,
--cstd_contact_completion.balance_amount AS contact_completion_balance_amount,
--cstd_contact_completion.balance_percentage AS contact_completion_balance_percentage,
--cstd_contact_completion.base_price AS contact_completion_base_price,
--cstd_contact_completion.client_number AS contact_completion_client_number,
--cstd_contact_completion.comment AS contact_completion_comment,
--cstd_contact_completion.company_id AS contact_completion_company_id,
--cstd_contact_completion.contact_completion_id AS contact_completion_contact_completion_id,
--cstd_contact_completion.contact_id AS contact_completion_contact_id,
--cstd_contact_completion.contract_amount AS contact_completion_contract_amount,
--cstd_contact_completion.contract_number AS contact_completion_contract_number,
--cstd_contact_completion.created_by_user_code AS contact_completion_created_by_user_code,
--cstd_contact_completion.creation_date AS contact_completion_creation_date,
--cstd_contact_completion.date_rescheduled AS contact_completion_date_rescheduled,
--cstd_contact_completion.date_saved AS contact_completion_date_saved,
--cstd_contact_completion.discount_amount AS contact_completion_discount_amount,
--cstd_contact_completion.discount_markup_flag AS contact_completion_discount_markup_flag,
--cstd_contact_completion.discount_percentage AS contact_completion_discount_percentage,
--cstd_contact_completion.followup_result AS contact_completion_followup_result,
--cstd_contact_completion.followup_result_id AS contact_completion_followup_result_id,
--cstd_contact_completion.hair_length AS contact_completion_hair_length,
--cstd_contact_completion.head_size AS contact_completion_head_size,
--cstd_contact_completion.initial_payment AS contact_completion_initial_payment,
--cstd_contact_completion.length_price AS contact_completion_length_price,
--cstd_contact_completion.number_of_graphs AS contact_completion_number_of_graphs,
--cstd_contact_completion.original_appointment_date AS contact_completion_original_appointment_date,
--cstd_contact_completion.referred_to_doctor_flag AS contact_completion_referred_to_doctor_flag,
--cstd_contact_completion.reschedule_flag AS contact_completion_reschedule_flag,
--cstd_contact_completion.sale_no_sale_flag AS contact_completion_sale_no_sale_flag,
--cstd_contact_completion.sale_type_code AS contact_completion_sale_type_code,
--cstd_contact_completion.sale_type_description AS contact_completion_sale_type_description,
--cstd_contact_completion.services AS contact_completion_services,
--cstd_contact_completion.show_no_show_flag AS contact_completion_show_no_show_flag,
--cstd_contact_completion.status_line AS contact_completion_status_line,
--cstd_contact_completion.surgery_consultation_flag AS contact_completion_surgery_consultation_flag,
--cstd_contact_completion.surgery_offered_flag AS contact_completion_surgery_offered_flag,
--cstd_contact_completion.systems AS contact_completion_systems,
--cstd_contact_completion.time_rescheduled AS contact_completion_time_rescheduled,
--cstd_contact_completion.updated_by_user_code AS contact_completion_updated_by_user_code,
--cstd_contact_completion.updated_date AS contact_completion_updated_date
--FROM oncd_contact
--LEFT OUTER JOIN oncd_contact_phone WITH (NOLOCK) ON
--	oncd_contact.contact_id = oncd_contact_phone.contact_id AND
--	oncd_contact_phone.primary_flag = 'Y'
--LEFT OUTER JOIN oncd_contact_address WITH (NOLOCK) ON
--	oncd_contact.contact_id = oncd_contact_address.contact_id AND
--	oncd_contact_address.primary_flag = 'Y'
--LEFT OUTER JOIN oncd_contact_source WITH (NOLOCK) ON
--	oncd_contact.contact_id = oncd_contact_source.contact_id AND
--	oncd_contact_source.primary_flag = 'Y'
--LEFT OUTER JOIN csta_contact_age_range WITH (NOLOCK) ON
--	oncd_contact.cst_age_range_code = csta_contact_age_range.age_range_code
--INNER JOIN oncd_contact_email WITH (NOLOCK) ON
--	oncd_contact.contact_id = oncd_contact_email.contact_id AND
--	oncd_contact_email.primary_flag = 'Y' AND
--	LEN(RTRIM(ISNULL(oncd_contact_email.email,''))) > 0
--INNER JOIN oncd_contact_company WITH (NOLOCK) ON
--	oncd_contact.contact_id = oncd_contact_company.contact_id AND
--	oncd_contact_company.primary_flag = 'Y'
--INNER JOIN oncd_company WITH (NOLOCK) ON
--	oncd_contact_company.company_id = oncd_company.company_id
--INNER JOIN oncd_company_address WITH (NOLOCK) ON
--	oncd_company.company_id = oncd_company_address.company_id AND
--	oncd_company_address.primary_flag = 'Y'
--LEFT OUTER JOIN oncd_activity appointment_activity WITH (NOLOCK) ON appointment_activity.activity_id = (
--	SELECT TOP 1 oncd_activity.activity_id
--	FROM oncd_activity
--	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
--	WHERE
--		oncd_activity_contact.contact_id = oncd_contact.contact_id AND
--		oncd_activity.action_code = 'APPOINT'
--	ORDER BY oncd_activity.due_date DESC)
--LEFT OUTER JOIN oncd_activity_user appointment_activity_user WITH (NOLOCK) ON
--	appointment_activity.activity_id = appointment_activity_user.activity_id ANd
--	appointment_activity_user.primary_flag = 'Y'
--LEFT OUTER JOIN oncd_activity brochure_activity WITH (NOLOCK) ON brochure_activity.activity_id = (
--	SELECT TOP 1 oncd_activity.activity_id
--	FROM oncd_activity
--	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
--	WHERE
--		oncd_activity_contact.contact_id = oncd_contact.contact_id AND
--		oncd_activity.action_code = 'BROCHCALL'
--	ORDER BY oncd_activity.due_date DESC)
--LEFT OUTER JOIN oncd_activity_user brochure_activity_user WITH (NOLOCK) ON
--	brochure_activity.activity_id = brochure_activity_user.activity_id AND
--	brochure_activity_user.primary_flag = 'Y'
--LEFT OUTER JOIN cstd_activity_demographic WITH (NOLOCK) ON cstd_activity_demographic.activity_demographic_id = (
--	SELECT TOP 1 activity_demographic.activity_demographic_id
--	FROM cstd_activity_demographic AS activity_demographic
--	INNER JOIN oncd_activity WITH (NOLOCK) ON activity_demographic.activity_id = oncd_activity.activity_id
--	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
--	WHERE
--		oncd_activity_contact.contact_id = oncd_contact.contact_id
--	ORDER BY activity_demographic.updated_date DESC)
--LEFT OUTER JOIN cstd_contact_completion WITH (NOLOCK) ON cstd_contact_completion.contact_completion_id = (
--	SELECT TOP 1 contact_completion.contact_completion_id
--	FROM cstd_contact_completion AS contact_completion
--	WHERE
--		contact_completion.contact_id = oncd_contact.contact_id
--	ORDER BY contact_completion.creation_date DESC)
--WHERE oncd_contact.contact_status_code = 'LEAD'
GO
