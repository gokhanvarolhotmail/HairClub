/* CreateDate: 06/07/2012 12:36:19.460 , ModifyDate: 01/30/2014 10:33:41.643 */
GO
CREATE VIEW [dbo].[cstv_contact_details]
AS
SELECT
oncd_contact.alt_center AS contact_alt_center,
oncd_contact.contact_id AS contact_contact_id,
oncd_contact.contact_method_code AS contact_contact_method_code,
oncd_contact.contact_status_code AS contact_contact_status_code,
oncd_contact.created_by_user_code AS contact_created_by_user_code,
oncd_contact.creation_date AS contact_creation_date,
oncd_contact.cst_affiliateid AS contact_affiliateid,
oncd_contact.cst_age AS contact_age,
oncd_contact.cst_age_range_code AS contact_age_range_code,
oncd_contact.cst_call_time AS contact_call_time,
oncd_contact.cst_complete_sale AS contact_complete_sale,
oncd_contact.cst_dnc_date AS contact_dnc_date,
oncd_contact.cst_dnc_flag AS contact_dnc_flag,
oncd_contact.cst_do_not_call AS contact_do_not_call,
oncd_contact.cst_do_not_email AS contact_do_not_email,
oncd_contact.cst_do_not_mail AS contact_do_not_mail,
oncd_contact.cst_do_not_text AS contact_do_not_text,
oncd_contact.cst_gender_code AS contact_gender_code,
oncd_contact.cst_hair_loss_code AS contact_hair_loss_code,
oncd_contact.cst_hair_loss_experience_code AS contact_hair_loss_experience_code,
oncd_contact.cst_hair_loss_family_code AS contact_hair_loss_family_code,
oncd_contact.cst_hair_loss_in_family_code AS contact_hair_loss_in_family_code,
oncd_contact.cst_hair_loss_product AS contact_hair_loss_product,
oncd_contact.cst_hair_loss_spot_code AS contact_hair_loss_spot_code,
oncd_contact.cst_language_code AS contact_language_code,
oncd_contact.cst_loginid AS contact_loginid,
oncd_contact.cst_promotion_code AS contact_promotion_code,
oncd_contact.cst_referring_store AS contact_referring_store,
oncd_contact.cst_referring_stylist AS contact_referring_stylist,
oncd_contact.cst_request_code AS contact_request_code,
oncd_contact.cst_research AS contact_research,
oncd_contact.cst_sessionid AS contact_sessionid,
oncd_contact.do_not_solicit AS contact_do_not_solicit,
oncd_contact.duplicate_check AS contact_duplicate_check,
oncd_contact.external_id AS contact_external_id,
oncd_contact.first_name AS contact_first_name,
oncd_contact.first_name_search AS contact_first_name_search,
oncd_contact.first_name_soundex AS contact_first_name_soundex,
oncd_contact.greeting AS contact_greeting,
oncd_contact.last_name AS contact_last_name,
oncd_contact.last_name_search AS contact_last_name_search,
oncd_contact.last_name_soundex AS contact_last_name_soundex,
oncd_contact.middle_name AS contact_middle_name,
oncd_contact.salutation_code AS contact_salutation_code,
oncd_contact.status_updated_by_user_code AS contact_status_updated_by_user_code,
oncd_contact.status_updated_date AS contact_status_updated_date,
oncd_contact.suffix AS contact_suffix,
oncd_contact.surgery_consultation_flag AS contact_surgery_consultation_flag,
oncd_contact.updated_by_user_code AS contact_updated_by_user_code,
oncd_contact.updated_date AS contact_updated_date,
oncd_contact_phone.active AS contact_phone_active,
oncd_contact_phone.area_code AS contact_phone_area_code,
oncd_contact_phone.contact_id AS contact_phone_contact_id,
oncd_contact_phone.contact_phone_id AS contact_phone_contact_phone_id,
oncd_contact_phone.country_code_prefix AS contact_phone_country_code_prefix,
oncd_contact_phone.created_by_user_code AS contact_phone_created_by_user_code,
oncd_contact_phone.creation_date AS contact_phone_creation_date,
--oncd_contact_phone.cst_invalid_flag AS contact_phone_invalid_flag,
--oncd_contact_phone.cst_service_tier AS contact_phone_service_tier,
--oncd_contact_phone.cst_vendor_code AS contact_phone_vendor_code,
oncd_contact_phone.description AS contact_phone_description,
oncd_contact_phone.extension AS contact_phone_extension,
oncd_contact_phone.phone_number AS contact_phone_phone_number,
oncd_contact_phone.phone_type_code AS contact_phone_phone_type_code,
oncd_contact_phone.primary_flag AS contact_phone_primary_flag,
oncd_contact_phone.sort_order AS contact_phone_sort_order,
oncd_contact_phone.updated_by_user_code AS contact_phone_updated_by_user_code,
oncd_contact_phone.updated_date AS contact_phone_updated_date,
oncd_contact_address.address_line_1 AS contact_address_address_line_1,
oncd_contact_address.address_line_1_soundex AS contact_address_address_line_1_soundex,
oncd_contact_address.address_line_2 AS contact_address_address_line_2,
oncd_contact_address.address_line_2_soundex AS contact_address_address_line_2_soundex,
oncd_contact_address.address_line_3 AS contact_address_address_line_3,
oncd_contact_address.address_line_4 AS contact_address_address_line_4,
oncd_contact_address.address_type_code AS contact_address_address_type_code,
oncd_contact_address.city AS contact_address_city,
oncd_contact_address.city_soundex AS contact_address_city_soundex,
oncd_contact_address.company_address_id AS contact_address_company_address_id,
oncd_contact_address.contact_address_id AS contact_address_contact_address_id,
oncd_contact_address.contact_id AS contact_address_contact_id,
oncd_contact_address.country_code AS contact_address_country_code,
oncd_contact_address.county_code AS contact_address_county_code,
oncd_contact_address.created_by_user_code AS contact_address_created_by_user_code,
oncd_contact_address.creation_date AS contact_address_creation_date,
--oncd_contact_address.cst_invalid_flag AS contact_address_invalid_flag,
--oncd_contact_address.cst_service_tier AS contact_address_service_tier,
--oncd_contact_address.cst_vendor_code AS contact_address_vendor_code,
oncd_contact_address.primary_flag AS contact_address_primary_flag,
oncd_contact_address.sort_order AS contact_address_sort_order,
oncd_contact_address.state_code AS contact_address_state_code,
oncd_contact_address.time_zone_code AS contact_address_time_zone_code,
oncd_contact_address.updated_by_user_code AS contact_address_updated_by_user_code,
oncd_contact_address.updated_date AS contact_address_updated_date,
oncd_contact_address.zip_code AS contact_address_zip_code,
csta_contact_age_range.active AS contact_age_range_active,
csta_contact_age_range.age_range_code AS contact_age_range_age_range_code,
csta_contact_age_range.description AS contact_age_range_description,
csta_contact_age_range.maximum_age AS contact_age_range_maximum_age,
csta_contact_age_range.minimum_age AS contact_age_range_minimum_age,
oncd_contact_email.active AS contact_email_active,
oncd_contact_email.contact_email_id AS contact_email_contact_email_id,
oncd_contact_email.contact_id AS contact_email_contact_id,
oncd_contact_email.created_by_user_code AS contact_email_created_by_user_code,
oncd_contact_email.creation_date AS contact_email_creation_date,
oncd_contact_email.description AS contact_email_description,
oncd_contact_email.email AS contact_email_email,
oncd_contact_email.email_type_code AS contact_email_email_type_code,
oncd_contact_email.primary_flag AS contact_email_primary_flag,
oncd_contact_email.sort_order AS contact_email_sort_order,
oncd_contact_email.updated_by_user_code AS contact_email_updated_by_user_code,
oncd_contact_email.updated_date AS contact_email_updated_date,
oncd_contact_company.company_id AS contact_company_company_id,
oncd_contact_company.company_role_code AS contact_company_company_role_code,
oncd_contact_company.contact_company_id AS contact_company_contact_company_id,
oncd_contact_company.contact_id AS contact_company_contact_id,
oncd_contact_company.created_by_user_code AS contact_company_created_by_user_code,
oncd_contact_company.creation_date AS contact_company_creation_date,
oncd_contact_company.cst_preferred_center_flag AS contact_company_preferred_center_flag,
oncd_contact_company.department_code AS contact_company_department_code,
oncd_contact_company.description AS contact_company_description,
oncd_contact_company.internal_title_code AS contact_company_internal_title_code,
oncd_contact_company.primary_flag AS contact_company_primary_flag,
oncd_contact_company.reports_to_contact_id AS contact_company_reports_to_contact_id,
oncd_contact_company.sort_order AS contact_company_sort_order,
oncd_contact_company.title AS contact_company_title,
oncd_contact_company.updated_by_user_code AS contact_company_updated_by_user_code,
oncd_contact_company.updated_date AS contact_company_updated_date,
oncd_company.annual_sales AS company_annual_sales,
oncd_company.company_id AS company_company_id,
oncd_company.company_name_1 AS company_company_name_1,
oncd_company.company_name_1_search AS company_company_name_1_search,
oncd_company.company_name_1_soundex AS company_company_name_1_soundex,
oncd_company.company_name_2 AS company_company_name_2,
oncd_company.company_name_2_search AS company_company_name_2_search,
oncd_company.company_name_2_soundex AS company_company_name_2_soundex,
oncd_company.company_status_code AS company_company_status_code,
oncd_company.company_type_code AS company_company_type_code,
oncd_company.contact_method_code AS company_contact_method_code,
oncd_company.created_by_user_code AS company_created_by_user_code,
oncd_company.creation_date AS company_creation_date,
oncd_company.cst_center_manager_name AS company_center_manager_name,
oncd_company.cst_center_number AS company_center_number,
oncd_company.cst_company_map_link AS company_company_map_link,
oncd_company.cst_director_name AS company_director_name,
oncd_company.cst_dma AS company_dma,
oncd_company.do_not_solicit AS company_do_not_solicit,
oncd_company.duplicate_check AS company_duplicate_check,
oncd_company.external_id AS company_external_id,
oncd_company.number_of_employees AS company_number_of_employees,
oncd_company.parent_company_id AS company_parent_company_id,
oncd_company.profile_code AS company_profile_code,
oncd_company.status_updated_by_user_code AS company_status_updated_by_user_code,
oncd_company.status_updated_date AS company_status_updated_date,
oncd_company.updated_by_user_code AS company_updated_by_user_code,
oncd_company.updated_date AS company_updated_date,
appointment_activity.action_code AS appointment_activity_action_code,
appointment_activity.activity_id AS appointment_activity_activity_id,
appointment_activity.batch_address_type_code AS appointment_activity_batch_address_type_code,
appointment_activity.batch_result_code AS appointment_activity_batch_result_code,
appointment_activity.batch_status_code AS appointment_activity_batch_status_code,
appointment_activity.campaign_code AS appointment_activity_campaign_code,
appointment_activity.completed_by_user_code AS appointment_activity_completed_by_user_code,
appointment_activity.completion_date AS appointment_activity_completion_date,
appointment_activity.completion_time AS appointment_activity_completion_time,
appointment_activity.confirmed_time AS appointment_activity_confirmed_time,
appointment_activity.confirmed_time_from AS appointment_activity_confirmed_time_from,
appointment_activity.confirmed_time_to AS appointment_activity_confirmed_time_to,
appointment_activity.created_by_user_code AS appointment_activity_created_by_user_code,
appointment_activity.creation_date AS appointment_activity_creation_date,
appointment_activity.cst_activity_type_code AS appointment_activity_activity_type_code,
--appointment_activity.cst_brochure_download AS appointment_activity_brochure_download,
appointment_activity.cst_followup_date AS appointment_activity_followup_date,
appointment_activity.cst_followup_time AS appointment_activity_followup_time,
appointment_activity.cst_lock_by_user_code AS appointment_activity_lock_by_user_code,
appointment_activity.cst_lock_date AS appointment_activity_lock_date,
appointment_activity.cst_no_followup_flag AS appointment_activity_no_followup_flag,
appointment_activity.cst_override_time_zone AS appointment_activity_override_time_zone,
appointment_activity.cst_promotion_code AS appointment_activity_promotion_code,
appointment_activity.cst_time_zone_code AS appointment_activity_time_zone_code,
appointment_activity.cst_utc_start_date AS appointment_activity_utc_start_date,
appointment_activity.description AS appointment_activity_description,
appointment_activity.document_id AS appointment_activity_document_id,
appointment_activity.due_date AS appointment_activity_due_date,
appointment_activity.duration AS appointment_activity_duration,
appointment_activity.incident_id AS appointment_activity_incident_id,
appointment_activity.milestone_activity_id AS appointment_activity_milestone_activity_id,
appointment_activity.notify_when_completed AS appointment_activity_notify_when_completed,
appointment_activity.opportunity_id AS appointment_activity_opportunity_id,
appointment_activity.priority AS appointment_activity_priority,
appointment_activity.project_code AS appointment_activity_project_code,
appointment_activity.project_id AS appointment_activity_project_id,
appointment_activity.recur_id AS appointment_activity_recur_id,
appointment_activity.result_code AS appointment_activity_result_code,
appointment_activity.source_code AS appointment_activity_source_code,
appointment_activity.start_time AS appointment_activity_start_time,
appointment_activity.updated_by_user_code AS appointment_activity_updated_by_user_code,
appointment_activity.updated_date AS appointment_activity_updated_date,
last_activity.action_code AS last_activity_action_code,
last_activity.activity_id AS last_activity_activity_id,
last_activity.batch_address_type_code AS last_activity_batch_address_type_code,
last_activity.batch_result_code AS last_activity_batch_result_code,
last_activity.batch_status_code AS last_activity_batch_status_code,
last_activity.campaign_code AS last_activity_campaign_code,
last_activity.completed_by_user_code AS last_activity_completed_by_user_code,
last_activity.completion_date AS last_activity_completion_date,
last_activity.completion_time AS last_activity_completion_time,
last_activity.confirmed_time AS last_activity_confirmed_time,
last_activity.confirmed_time_from AS last_activity_confirmed_time_from,
last_activity.confirmed_time_to AS last_activity_confirmed_time_to,
last_activity.created_by_user_code AS last_activity_created_by_user_code,
last_activity.creation_date AS last_activity_creation_date,
last_activity.cst_activity_type_code AS last_activity_activity_type_code,
--last_activity.cst_brochure_download AS last_activity_brochure_download,
last_activity.cst_followup_date AS last_activity_followup_date,
last_activity.cst_followup_time AS last_activity_followup_time,
last_activity.cst_lock_by_user_code AS last_activity_lock_by_user_code,
last_activity.cst_lock_date AS last_activity_lock_date,
last_activity.cst_no_followup_flag AS last_activity_no_followup_flag,
last_activity.cst_override_time_zone AS last_activity_override_time_zone,
last_activity.cst_promotion_code AS last_activity_promotion_code,
last_activity.cst_time_zone_code AS last_activity_time_zone_code,
last_activity.cst_utc_start_date AS last_activity_utc_start_date,
last_activity.description AS last_activity_description,
last_activity.document_id AS last_activity_document_id,
last_activity.due_date AS last_activity_due_date,
last_activity.duration AS last_activity_duration,
last_activity.incident_id AS last_activity_incident_id,
last_activity.milestone_activity_id AS last_activity_milestone_activity_id,
last_activity.notify_when_completed AS last_activity_notify_when_completed,
last_activity.opportunity_id AS last_activity_opportunity_id,
last_activity.priority AS last_activity_priority,
last_activity.project_code AS last_activity_project_code,
last_activity.project_id AS last_activity_project_id,
last_activity.recur_id AS last_activity_recur_id,
last_activity.result_code AS last_activity_result_code,
last_activity.source_code AS last_activity_source_code,
last_activity.start_time AS last_activity_start_time,
last_activity.updated_by_user_code AS last_activity_updated_by_user_code,
last_activity.updated_date AS last_activity_updated_date,
oncd_contact_source.assignment_date AS contact_source_assignment_date,
oncd_contact_source.contact_id AS contact_source_contact_id,
oncd_contact_source.contact_source_id AS contact_source_contact_source_id,
oncd_contact_source.created_by_user_code AS contact_source_created_by_user_code,
oncd_contact_source.creation_date AS contact_source_creation_date,
oncd_contact_source.cst_dnis_number AS contact_source_dnis_number,
oncd_contact_source.cst_sub_source_code AS contact_source_sub_source_code,
oncd_contact_source.media_code AS contact_source_media_code,
oncd_contact_source.primary_flag AS contact_source_primary_flag,
oncd_contact_source.sort_order AS contact_source_sort_order,
oncd_contact_source.source_code AS contact_source_source_code,
oncd_contact_source.updated_by_user_code AS contact_source_updated_by_user_code,
oncd_contact_source.updated_date AS contact_source_updated_date
FROM oncd_contact
LEFT OUTER JOIN oncd_contact_phone WITH (NOLOCK) ON
	oncd_contact.contact_id = oncd_contact_phone.contact_id AND
	oncd_contact_phone.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_address WITH (NOLOCK) ON
	oncd_contact.contact_id = oncd_contact_address.contact_id AND
	oncd_contact_address.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_source WITH (NOLOCK) ON
	oncd_contact.contact_id = oncd_contact_source.contact_id AND
	oncd_contact_source.primary_flag = 'Y'
LEFT OUTER JOIN csta_contact_age_range WITH (NOLOCK) ON
	oncd_contact.cst_age_range_code = csta_contact_age_range.age_range_code
LEFT OUTER JOIN oncd_contact_email WITH (NOLOCK) ON
	oncd_contact.contact_id = oncd_contact_email.contact_id AND
	oncd_contact_email.primary_flag = 'Y' AND
	LEN(RTRIM(ISNULL(oncd_contact_email.email,''))) > 0
INNER JOIN oncd_contact_company WITH (NOLOCK) ON
	oncd_contact.contact_id = oncd_contact_company.contact_id AND
	oncd_contact_company.primary_flag = 'Y'
INNER JOIN oncd_company WITH (NOLOCK) ON
	oncd_contact_company.company_id = oncd_company.company_id
INNER JOIN oncd_company_address WITH (NOLOCK) ON
	oncd_company.company_id = oncd_company_address.company_id AND
	oncd_company_address.primary_flag = 'Y'
LEFT OUTER JOIN oncd_activity appointment_activity WITH (NOLOCK) ON appointment_activity.activity_id = (
	SELECT TOP 1 oncd_activity.activity_id
	FROM oncd_activity
	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
	WHERE
		oncd_activity_contact.contact_id = oncd_contact.contact_id AND
		oncd_activity.action_code = 'APPOINT'
	ORDER BY oncd_activity.due_date DESC)
LEFT OUTER JOIN oncd_activity_user appointment_activity_user WITH (NOLOCK) ON
	appointment_activity.activity_id = appointment_activity_user.activity_id ANd
	appointment_activity_user.primary_flag = 'Y'
LEFT OUTER JOIN oncd_activity last_activity WITH (NOLOCK) ON last_activity.activity_id = (
	SELECT TOP 1 oncd_activity.activity_id
	FROM oncd_activity
	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
	WHERE
		oncd_activity_contact.contact_id = oncd_contact.contact_id
	ORDER BY oncd_activity.due_date DESC)
GO