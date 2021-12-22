/* CreateDate: 07/21/2014 15:41:36.847 , ModifyDate: 07/21/2014 15:41:36.847 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 18 June 2012
-- Description:	Refreshes the data for a single contact.
-- =============================================
CREATE PROCEDURE [dbo].[pso_RefreshEmailDHContactBatch]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE cstd_email_dh_flat
	SET
		--contact_alt_center = alt_center,
		--contact_contact_method_code = contact_method_code,
		contact_contact_status_code = contact_status_code,
		contact_created_by_user_code = created_by_user_code,
		contact_creation_date = creation_date,
		--contact_affiliateid = cst_affiliateid,
		contact_age = cst_age,
		contact_age_range_code = cst_age_range_code,
		--contact_call_time = cst_call_time,
		--contact_complete_sale = cst_complete_sale,
		contact_dnc_date = cst_dnc_date,
		--contact_dnc_flag = cst_dnc_flag,
		contact_do_not_call = cst_do_not_call,
		contact_do_not_email = cst_do_not_email,
		contact_do_not_mail = cst_do_not_mail,
		--contact_do_not_text = cst_do_not_text,
		contact_gender_code = cst_gender_code,
		contact_hair_loss_code = cst_hair_loss_code,
		contact_hair_loss_experience_code = cst_hair_loss_experience_code,
		contact_hair_loss_family_code = cst_hair_loss_family_code,
		contact_hair_loss_in_family_code = cst_hair_loss_in_family_code,
		contact_hair_loss_product = cst_hair_loss_product,
		contact_hair_loss_spot_code = cst_hair_loss_spot_code,
		contact_language_code = cst_language_code,
		--contact_loginid = cst_loginid,
		contact_promotion_code = cst_promotion_code,
		--contact_referring_store = cst_referring_store,
		--contact_referring_stylist = cst_referring_stylist,
		--contact_request_code = cst_request_code,
		--contact_research = cst_research,
		--contact_sessionid = cst_sessionid,
		contact_do_not_solicit = do_not_solicit,
		--contact_duplicate_check = duplicate_check,
		--contact_external_id = external_id,
		contact_first_name = first_name,
		contact_first_name_search = first_name_search,
		--contact_first_name_soundex = first_name_soundex,
		--contact_greeting = greeting,
		contact_last_name = last_name,
		contact_last_name_search = last_name_search,
		--contact_last_name_soundex = last_name_soundex,
		--contact_middle_name = middle_name,
		--contact_salutation_code = salutation_code,
		--contact_status_updated_by_user_code = status_updated_by_user_code,
		--contact_status_updated_date = status_updated_date,
		--contact_suffix = suffix,
		contact_surgery_consultation_flag = surgery_consultation_flag--,
		--contact_updated_by_user_code = updated_by_user_code,
		--contact_updated_date = updated_date
	FROM oncd_contact WITH (NOLOCK)
	WHERE
		cstd_email_dh_flat.contact_contact_id = oncd_contact.contact_id

	UPDATE cstd_email_dh_flat
	SET
		--contact_email_active = active,
		--contact_email_contact_email_id = contact_email_id,
		--contact_email_contact_id = contact_id,
		--contact_email_created_by_user_code = created_by_user_code,
		--contact_email_creation_date = creation_date,
		--contact_email_description = description,
		contact_email_email = email--,
		--contact_email_email_type_code = email_type_code,
		--contact_email_primary_flag = primary_flag,
		--contact_email_sort_order = sort_order,
		--contact_email_updated_by_user_code = updated_by_user_code,
		--contact_email_updated_date = updated_date
	FROM oncd_contact_email WITH (NOLOCK)
	WHERE
		cstd_email_dh_flat.contact_contact_id = oncd_contact_email.contact_id AND
		oncd_contact_email.primary_flag = 'Y'

	UPDATE cstd_email_dh_flat
	SET
		--contact_phone_active = active,
		contact_phone_area_code = area_code,
		--contact_phone_contact_id = contact_id,
		--contact_phone_contact_phone_id = contact_phone_id,
		--contact_phone_country_code_prefix = country_code_prefix,
		--contact_phone_created_by_user_code = created_by_user_code,
		--contact_phone_creation_date = creation_date,
		--contact_phone_description = description,
		contact_phone_extension = extension,
		contact_phone_phone_number = phone_number--,
		--contact_phone_phone_type_code = phone_type_code,
		--contact_phone_primary_flag = primary_flag,
		--contact_phone_sort_order = sort_order,
		--contact_phone_updated_by_user_code = updated_by_user_code,
		--contact_phone_updated_date = updated_date
	FROM oncd_contact_phone WITH (NOLOCK)
	WHERE
		cstd_email_dh_flat.contact_contact_id = oncd_contact_phone.contact_id AND
		oncd_contact_phone.primary_flag = 'Y'

	UPDATE cstd_email_dh_flat
	SET
		contact_address_address_line_1 = address_line_1,
		--contact_address_address_line_1_soundex = address_line_1_soundex,
		--contact_address_address_line_2 = address_line_2,
		--contact_address_address_line_2_soundex = address_line_2_soundex,
		--contact_address_address_line_3 = address_line_3,
		--contact_address_address_line_4 = address_line_4,
		--contact_address_address_type_code = address_type_code,
		contact_address_city = city,
		--contact_address_city_soundex = city_soundex,
		--contact_address_company_address_id = company_address_id,
		--contact_address_contact_address_id = contact_address_id,
		--contact_address_contact_id = contact_id,
		--contact_address_country_code = country_code,
		--contact_address_county_code = county_code,
		--contact_address_created_by_user_code = created_by_user_code,
		--contact_address_creation_date = creation_date,
		--contact_address_primary_flag = primary_flag,
		--contact_address_sort_order = sort_order,
		contact_address_state_code = state_code,
		--contact_address_time_zone_code = time_zone_code,
		--contact_address_updated_by_user_code = updated_by_user_code,
		--contact_address_updated_date = updated_date,
		contact_address_zip_code = zip_code
	FROM oncd_contact_address WITH (NOLOCK)
	WHERE
		cstd_email_dh_flat.contact_contact_id = oncd_contact_address.contact_id AND
		oncd_contact_address.primary_flag = 'Y'

	--UPDATE cstd_email_dh_flat
	--SET
	--	contact_age_range_active = active,
	--	contact_age_range_age_range_code = age_range_code,
	--	contact_age_range_description = description,
	--	contact_age_range_maximum_age = maximum_age,
	--	contact_age_range_minimum_age = minimum_age
	--FROM csta_contact_age_range WITH (NOLOCK)
	--INNER JOIN oncd_contact  WITH (NOLOCK)
	--	ON csta_contact_age_range.age_range_code = oncd_contact.cst_age_range_code
	--WHERE
	--	cstd_email_dh_flat.contact_contact_id = @ContactId AND
	--	oncd_contact.contact_id = @ContactId

	UPDATE cstd_email_dh_flat
	SET
		--contact_company_company_id = oncd_contact_company.company_id,
		--contact_company_company_role_code = oncd_contact_company.company_role_code,
		--contact_company_contact_company_id = oncd_contact_company.contact_company_id,
		--contact_company_contact_id = oncd_contact_company.contact_id,
		--contact_company_created_by_user_code = oncd_contact_company.created_by_user_code,
		--contact_company_creation_date = oncd_contact_company.creation_date,
		--contact_company_preferred_center_flag = oncd_contact_company.cst_preferred_center_flag,
		--contact_company_department_code = oncd_contact_company.department_code,
		--contact_company_description = oncd_contact_company.description,
		--contact_company_internal_title_code = oncd_contact_company.internal_title_code,
		--contact_company_primary_flag = oncd_contact_company.primary_flag,
		--contact_company_reports_to_contact_id = oncd_contact_company.reports_to_contact_id,
		--contact_company_sort_order = oncd_contact_company.sort_order,
		--contact_company_title = oncd_contact_company.title,
		--contact_company_updated_by_user_code = oncd_contact_company.updated_by_user_code,
		--contact_company_updated_date = oncd_contact_company.updated_date,
		--company_annual_sales = oncd_company.annual_sales,
		company_company_id = oncd_company.company_id,
		company_company_name_1 = oncd_company.company_name_1,
		--company_company_name_1_search = oncd_company.company_name_1_search,
		--company_company_name_1_soundex = oncd_company.company_name_1_soundex,
		--company_company_name_2 = oncd_company.company_name_2,
		--company_company_name_2_search = oncd_company.company_name_2_search,
		--company_company_name_2_soundex = oncd_company.company_name_2_soundex,
		--company_company_status_code = oncd_company.company_status_code,
		--company_company_type_code = oncd_company.company_type_code,
		--company_contact_method_code = oncd_company.contact_method_code,
		--company_created_by_user_code = oncd_company.created_by_user_code,
		--company_creation_date = oncd_company.creation_date,
		--company_center_manager_name = oncd_company.cst_center_manager_name,
		company_center_number = oncd_company.cst_center_number,
		company_company_map_link = oncd_company.cst_company_map_link,
		--company_director_name = oncd_company.cst_director_name,
		--company_dma = oncd_company.cst_dma,
		--company_do_not_solicit = oncd_company.do_not_solicit,
		--company_duplicate_check = oncd_company.duplicate_check,
		--company_external_id = oncd_company.external_id,
		--company_number_of_employees = oncd_company.number_of_employees,
		--company_parent_company_id = oncd_company.parent_company_id,
		--company_profile_code = oncd_company.profile_code,
		--company_status_updated_by_user_code = oncd_company.status_updated_by_user_code,
		--company_status_updated_date = oncd_company.status_updated_date,
		--company_updated_by_user_code = oncd_company.updated_by_user_code,
		--company_updated_date = oncd_company.updated_date,
		company_address_address_line_1 = oncd_company_address.address_line_1,
		--company_address_address_line_1_soundex = oncd_company_address.address_line_1_soundex,
		company_address_address_line_2 = oncd_company_address.address_line_2,
		--company_address_address_line_2_soundex = oncd_company_address.address_line_2_soundex,
		--company_address_address_line_3 = oncd_company_address.address_line_3,
		--company_address_address_line_4 = oncd_company_address.address_line_4,
		--company_address_address_type_code = oncd_company_address.address_type_code,
		company_address_city = oncd_company_address.city,
		--company_address_city_soundex = oncd_company_address.city_soundex,
		--company_address_company_address_id = oncd_company_address.company_address_id,
		--company_address_company_id = oncd_company_address.company_id,
		company_address_country_code = oncd_company_address.country_code,
		--company_address_county_code = oncd_company_address.county_code,
		--company_address_created_by_user_code = oncd_company_address.created_by_user_code,
		--company_address_creation_date = oncd_company_address.creation_date,
		--company_address_primary_flag = oncd_company_address.primary_flag,
		--company_address_sort_order = oncd_company_address.sort_order,
		company_address_state_code = oncd_company_address.state_code,
		--company_address_time_zone_code = oncd_company_address.time_zone_code,
		--company_address_updated_by_user_code = oncd_company_address.updated_by_user_code,
		--company_address_updated_date = oncd_company_address.updated_date,
		company_address_zip_code = oncd_company_address.zip_code
	FROM oncd_contact_company WITH (NOLOCK)
	INNER JOIN oncd_company  WITH (NOLOCK)
		ON oncd_contact_company.company_id = oncd_company.company_id
	INNER JOIN oncd_company_address  WITH (NOLOCK)
		ON oncd_company.company_id = oncd_company_address.company_id and oncd_company_address.primary_flag = 'Y'
	WHERE
		cstd_email_dh_flat.contact_contact_id = oncd_contact_company.contact_id AND
		oncd_contact_company.primary_flag = 'Y'

	UPDATE cstd_email_dh_flat
	SET
		--appointment_activity_action_code = oncd_activity.action_code,
		appointment_activity_activity_id = oncd_activity.activity_id,
		--appointment_activity_batch_address_type_code = oncd_activity.batch_address_type_code,
		--appointment_activity_batch_result_code = oncd_activity.batch_result_code,
		--appointment_activity_batch_status_code = oncd_activity.batch_status_code,
		--appointment_activity_campaign_code = oncd_activity.campaign_code,
		appointment_activity_completed_by_user_code = oncd_activity.completed_by_user_code,
		appointment_activity_completion_date = oncd_activity.completion_date,
		appointment_activity_completion_time = oncd_activity.completion_time,
		--appointment_activity_confirmed_time = oncd_activity.confirmed_time,
		--appointment_activity_confirmed_time_from = oncd_activity.confirmed_time_from,
		--appointment_activity_confirmed_time_to = oncd_activity.confirmed_time_to,
		--appointment_activity_created_by_user_code = oncd_activity.created_by_user_code,
		appointment_activity_creation_date = oncd_activity.creation_date,
		appointment_activity_activity_type_code = oncd_activity.cst_activity_type_code,
		--appointment_activity_followup_date = oncd_activity.cst_followup_date,
		--appointment_activity_followup_time = oncd_activity.cst_followup_time,
		--appointment_activity_lock_by_user_code = oncd_activity.cst_lock_by_user_code,
		--appointment_activity_lock_date = oncd_activity.cst_lock_date,
		--appointment_activity_no_followup_flag = oncd_activity.cst_no_followup_flag,
		--appointment_activity_override_time_zone = oncd_activity.cst_override_time_zone,
		--appointment_activity_promotion_code = oncd_activity.cst_promotion_code,
		--appointment_activity_time_zone_code = oncd_activity.cst_time_zone_code,
		--appointment_activity_utc_start_date = oncd_activity.cst_utc_start_date,
		--appointment_activity_description = oncd_activity.description,
		--appointment_activity_document_id = oncd_activity.document_id,
		appointment_activity_due_date = oncd_activity.due_date,
		--appointment_activity_duration = oncd_activity.duration,
		--appointment_activity_incident_id = oncd_activity.incident_id,
		--appointment_activity_milestone_activity_id = oncd_activity.milestone_activity_id,
		--appointment_activity_notify_when_completed = oncd_activity.notify_when_completed,
		--appointment_activity_opportunity_id = oncd_activity.opportunity_id,
		--appointment_activity_priority = oncd_activity.priority,
		--appointment_activity_project_code = oncd_activity.project_code,
		--appointment_activity_project_id = oncd_activity.project_id,
		--appointment_activity_recur_id = oncd_activity.recur_id,
		appointment_activity_result_code = oncd_activity.result_code,
		appointment_activity_source_code = oncd_activity.source_code,
		appointment_activity_start_time = oncd_activity.start_time,
		--appointment_activity_updated_by_user_code = oncd_activity.updated_by_user_code,
		--appointment_activity_updated_date = oncd_activity.updated_date,
		--appointment_activity_user_activity_id = oncd_activity_user.activity_id,
		--appointment_activity_user_activity_user_id = oncd_activity_user.activity_user_id,
		--appointment_activity_user_assignment_date = oncd_activity_user.assignment_date,
		--appointment_activity_user_attendance = oncd_activity_user.attendance,
		--appointment_activity_user_created_by_user_code = oncd_activity_user.created_by_user_code,
		--appointment_activity_user_creation_date = oncd_activity_user.creation_date,
		--appointment_activity_user_primary_flag = oncd_activity_user.primary_flag,
		--appointment_activity_user_sort_order = oncd_activity_user.sort_order,
		--appointment_activity_user_updated_by_user_code = oncd_activity_user.updated_by_user_code,
		--appointment_activity_user_updated_date = oncd_activity_user.updated_date,
		appointment_activity_user_user_code = oncd_activity_user.user_code
	FROM oncd_activity WITH (NOLOCK)
	LEFT OUTER JOIN oncd_activity_user  WITH (NOLOCK) ON
		oncd_activity.activity_id = oncd_activity_user.activity_id AND
		oncd_activity_user.primary_flag = 'Y'
	INNER JOIN cstd_email_dh_appointment_activity WITH (NOLOCK) ON
		oncd_activity.activity_id = cstd_email_dh_appointment_activity.activity_id
	WHERE
		cstd_email_dh_flat.contact_contact_id = cstd_email_dh_appointment_activity.contact_id

	UPDATE cstd_email_dh_flat
	SET
		--brochure_activity_action_code = oncd_activity.action_code,
		brochure_activity_activity_id = oncd_activity.activity_id,
		--brochure_activity_batch_address_type_code = oncd_activity.batch_address_type_code,
		--brochure_activity_batch_result_code = oncd_activity.batch_result_code,
		--brochure_activity_batch_status_code = oncd_activity.batch_status_code,
		--brochure_activity_campaign_code = oncd_activity.campaign_code,
		brochure_activity_completed_by_user_code = oncd_activity.completed_by_user_code,
		brochure_activity_completion_date = oncd_activity.completion_date,
		brochure_activity_completion_time = oncd_activity.completion_time,
		--brochure_activity_confirmed_time = oncd_activity.confirmed_time,
		--brochure_activity_confirmed_time_from = oncd_activity.confirmed_time_from,
		--brochure_activity_confirmed_time_to = oncd_activity.confirmed_time_to,
		--brochure_activity_created_by_user_code = oncd_activity.created_by_user_code,
		brochure_activity_creation_date = oncd_activity.creation_date,
		brochure_activity_activity_type_code = oncd_activity.cst_activity_type_code,
		--brochure_activity_followup_date = oncd_activity.cst_followup_date,
		--brochure_activity_followup_time = oncd_activity.cst_followup_time,
		--brochure_activity_lock_by_user_code = oncd_activity.cst_lock_by_user_code,
		--brochure_activity_lock_date = oncd_activity.cst_lock_date,
		--brochure_activity_no_followup_flag = oncd_activity.cst_no_followup_flag,
		--brochure_activity_override_time_zone = oncd_activity.cst_override_time_zone,
		--brochure_activity_promotion_code = oncd_activity.cst_promotion_code,
		--brochure_activity_time_zone_code = oncd_activity.cst_time_zone_code,
		--brochure_activity_utc_start_date = oncd_activity.cst_utc_start_date,
		--brochure_activity_description = oncd_activity.description,
		--brochure_activity_document_id = oncd_activity.document_id,
		brochure_activity_due_date = oncd_activity.due_date,
		--brochure_activity_duration = oncd_activity.duration,
		--brochure_activity_incident_id = oncd_activity.incident_id,
		--brochure_activity_milestone_activity_id = oncd_activity.milestone_activity_id,
		--brochure_activity_notify_when_completed = oncd_activity.notify_when_completed,
		--brochure_activity_opportunity_id = oncd_activity.opportunity_id,
		--brochure_activity_priority = oncd_activity.priority,
		--brochure_activity_project_code = oncd_activity.project_code,
		--brochure_activity_project_id = oncd_activity.project_id,
		--brochure_activity_recur_id = oncd_activity.recur_id,
		brochure_activity_result_code = oncd_activity.result_code,
		brochure_activity_source_code = oncd_activity.source_code,
		brochure_activity_start_time = oncd_activity.start_time,
		--brochure_activity_updated_by_user_code = oncd_activity.updated_by_user_code,
		--brochure_activity_updated_date = oncd_activity.updated_date,
		--brochure_activity_user_activity_id = oncd_activity_user.activity_id,
		--brochure_activity_user_activity_user_id = oncd_activity_user.activity_user_id,
		--brochure_activity_user_assignment_date = oncd_activity_user.assignment_date,
		--brochure_activity_user_attendance = oncd_activity_user.attendance,
		--brochure_activity_user_created_by_user_code = oncd_activity_user.created_by_user_code,
		--brochure_activity_user_creation_date = oncd_activity_user.creation_date,
		--brochure_activity_user_primary_flag = oncd_activity_user.primary_flag,
		--brochure_activity_user_sort_order = oncd_activity_user.sort_order,
		--brochure_activity_user_updated_by_user_code = oncd_activity_user.updated_by_user_code,
		--brochure_activity_user_updated_date = oncd_activity_user.updated_date,
		brochure_activity_user_user_code = oncd_activity_user.user_code
	FROM oncd_activity WITH (NOLOCK)
	LEFT OUTER JOIN oncd_activity_user  WITH (NOLOCK) ON
		oncd_activity.activity_id = oncd_activity_user.activity_id AND
		oncd_activity_user.primary_flag = 'Y'
	INNER JOIN cstd_email_dh_brochure_activity WITH (NOLOCK) ON
		oncd_activity.activity_id = cstd_email_dh_brochure_activity.activity_id
	WHERE
		cstd_email_dh_flat.contact_contact_id = cstd_email_dh_brochure_activity.contact_id

	UPDATE cstd_email_dh_flat
	SET
		--activity_demographic_activity_demographic_id = cstd_activity_demographic.activity_demographic_id,
		--activity_demographic_activity_id = cstd_activity_demographic.activity_id,
		--activity_demographic_age = cstd_activity_demographic.age,
		activity_demographic_birthday = cstd_activity_demographic.birthday,
		--activity_demographic_created_by_user_code = cstd_activity_demographic.created_by_user_code,
		--activity_demographic_creation_date = cstd_activity_demographic.creation_date,
		activity_demographic_disc_style = cstd_activity_demographic.disc_style,
		activity_demographic_ethnicity_code = cstd_activity_demographic.ethnicity_code,
		--activity_demographic_gender = cstd_activity_demographic.gender,
		activity_demographic_ludwig = cstd_activity_demographic.ludwig,
		activity_demographic_maritalstatus_code = cstd_activity_demographic.maritalstatus_code,
		activity_demographic_no_sale_reason = cstd_activity_demographic.no_sale_reason,
		activity_demographic_norwood = cstd_activity_demographic.norwood,
		activity_demographic_occupation_code = cstd_activity_demographic.occupation_code,
		--activity_demographic_performer = cstd_activity_demographic.performer,
		activity_demographic_price_quoted = cstd_activity_demographic.price_quoted,
		activity_demographic_solution_offered = cstd_activity_demographic.solution_offered--,
		--activity_demographic_updated_by_user_code = cstd_activity_demographic.updated_by_user_code,
		--activity_demographic_updated_date = cstd_activity_demographic.updated_date
	FROM cstd_activity_demographic WITH (NOLOCK)
	INNER JOIN cstd_email_dh_activity_demographic WITH (NOLOCK) ON
		cstd_activity_demographic.activity_demographic_id = cstd_email_dh_activity_demographic.activity_demographic_id
	WHERE
		cstd_email_dh_flat.contact_contact_id = cstd_email_dh_activity_demographic.contact_id

	UPDATE cstd_email_dh_flat
	SET
		--contact_source_assignment_date = assignment_date,
		--contact_source_contact_id = contact_id,
		--contact_source_contact_source_id = contact_source_id,
		--contact_source_created_by_user_code = created_by_user_code,
		--contact_source_creation_date = creation_date,
		--contact_source_dnis_number = cst_dnis_number,
		--contact_source_sub_source_code = cst_sub_source_code,
		--contact_source_media_code = media_code,
		--contact_source_primary_flag = primary_flag,
		--contact_source_sort_order = sort_order,
		contact_source_source_code = source_code--,
		--contact_source_updated_by_user_code = updated_by_user_code,
		--contact_source_updated_date = updated_date
	FROM oncd_contact_source WITH (NOLOCK)
	WHERE
		cstd_email_dh_flat.contact_contact_id = oncd_contact_source.contact_id AND
		oncd_contact_source.primary_flag = 'Y'

	UPDATE cstd_email_dh_flat
	SET
		--contact_completion_activity_id = cstd_contact_completion.activity_id,
		--contact_completion_balance_amount = cstd_contact_completion.balance_amount,
		--contact_completion_balance_percentage = cstd_contact_completion.balance_percentage,
		--contact_completion_base_price = cstd_contact_completion.base_price,
		--contact_completion_client_number = cstd_contact_completion.client_number,
		--contact_completion_comment = cstd_contact_completion.comment,
		--contact_completion_company_id = cstd_contact_completion.company_id,
		--contact_completion_contact_completion_id = cstd_contact_completion.contact_completion_id,
		--contact_completion_contact_id = cstd_contact_completion.contact_id,
		--contact_completion_contract_amount = cstd_contact_completion.contract_amount,
		--contact_completion_contract_number = cstd_contact_completion.contract_number,
		--contact_completion_created_by_user_code = cstd_contact_completion.created_by_user_code,
		--contact_completion_creation_date = cstd_contact_completion.creation_date,
		--contact_completion_date_rescheduled = cstd_contact_completion.date_rescheduled,
		--contact_completion_date_saved = cstd_contact_completion.date_saved,
		--contact_completion_discount_amount = cstd_contact_completion.discount_amount,
		--contact_completion_discount_markup_flag = cstd_contact_completion.discount_markup_flag,
		--contact_completion_discount_percentage = cstd_contact_completion.discount_percentage,
		--contact_completion_followup_result = cstd_contact_completion.followup_result,
		--contact_completion_followup_result_id = cstd_contact_completion.followup_result_id,
		--contact_completion_hair_length = cstd_contact_completion.hair_length,
		--contact_completion_head_size = cstd_contact_completion.head_size,
		--contact_completion_initial_payment = cstd_contact_completion.initial_payment,
		--contact_completion_length_price = cstd_contact_completion.length_price,
		--contact_completion_number_of_graphs = cstd_contact_completion.number_of_graphs,
		--contact_completion_original_appointment_date = cstd_contact_completion.original_appointment_date,
		--contact_completion_referred_to_doctor_flag = cstd_contact_completion.referred_to_doctor_flag,
		--contact_completion_reschedule_flag = cstd_contact_completion.reschedule_flag,
		--contact_completion_sale_no_sale_flag = cstd_contact_completion.sale_no_sale_flag,
		--contact_completion_sale_type_code = cstd_contact_completion.sale_type_code,
		contact_completion_sale_type_description = cstd_contact_completion.sale_type_description--,
		--contact_completion_services = cstd_contact_completion.services,
		--contact_completion_show_no_show_flag = cstd_contact_completion.show_no_show_flag,
		--contact_completion_status_line = cstd_contact_completion.status_line,
		--contact_completion_surgery_consultation_flag = cstd_contact_completion.surgery_consultation_flag,
		--contact_completion_surgery_offered_flag = cstd_contact_completion.surgery_offered_flag,
		--contact_completion_systems = cstd_contact_completion.systems,
		--contact_completion_time_rescheduled = cstd_contact_completion.time_rescheduled,
		--contact_completion_updated_by_user_code = cstd_contact_completion.updated_by_user_code,
		--contact_completion_updated_date = cstd_contact_completion.updated_date
	FROM cstd_contact_completion WITH (NOLOCK)
	INNER JOIN cstd_email_dh_contact_completion WITH (NOLOCK) ON
		cstd_contact_completion.contact_completion_id = cstd_email_dh_contact_completion.contact_completion_id
	WHERE
		cstd_email_dh_flat.contact_contact_id = cstd_email_dh_contact_completion.contact_id

	--DELETE FROM cstd_email_dh_activity_demographic WHERE contact_id = @ContactId
	--DELETE FROM cstd_email_dh_appointment_activity WHERE contact_id = @ContactId
	--DELETE FROM cstd_email_dh_brochure_activity WHERE contact_id = @ContactId
	--DELETE FROM cstd_email_dh_contact_completion WHERE contact_id = @ContactId
END
GO
