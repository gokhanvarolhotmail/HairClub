/* CreateDate: 01/03/2018 17:04:45.847 , ModifyDate: 01/03/2018 17:04:45.847 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_oncd_contact]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_id], NULL as [greeting], NULL as [first_name], NULL as [middle_name], NULL as [last_name], NULL as [suffix], NULL as [first_name_search], NULL as [last_name_search], NULL as [first_name_soundex], NULL as [last_name_soundex], NULL as [salutation_code], NULL as [contact_status_code], NULL as [external_id], NULL as [contact_method_code], NULL as [do_not_solicit], NULL as [duplicate_check], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [status_updated_date], NULL as [status_updated_by_user_code], NULL as [cst_gender_code], NULL as [cst_call_time], NULL as [cst_complete_sale], NULL as [cst_research], NULL as [cst_dnc_flag], NULL as [cst_referring_store], NULL as [cst_referring_stylist], NULL as [cst_do_not_call], NULL as [cst_language_code], NULL as [cst_promotion_code], NULL as [cst_request_code], NULL as [cst_age_range_code], NULL as [cst_hair_loss_code], NULL as [cst_dnc_date], NULL as [cst_sessionid], NULL as [cst_affiliateid], NULL as [alt_center], NULL as [cst_loginid], NULL as [cst_do_not_email], NULL as [cst_do_not_mail], NULL as [cst_do_not_text], NULL as [surgery_consultation_flag], NULL as [cst_age], NULL as [cst_hair_loss_spot_code], NULL as [cst_hair_loss_experience_code], NULL as [cst_hair_loss_product], NULL as [cst_hair_loss_in_family_code], NULL as [cst_hair_loss_family_code], NULL as [cst_has_valid_cell_phone], NULL as [cst_has_open_confirmation_call], NULL as [cst_siebel_id], NULL as [cst_previous_first_name], NULL as [cst_previous_last_name], NULL as [cst_updated_by_user_code], NULL as [cst_contact_accomodation_code], NULL as [cst_sfdc_lead_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_id], t.[greeting], t.[first_name], t.[middle_name], t.[last_name], t.[suffix], t.[first_name_search], t.[last_name_search], t.[first_name_soundex], t.[last_name_soundex], t.[salutation_code], t.[contact_status_code], t.[external_id], t.[contact_method_code], t.[do_not_solicit], t.[duplicate_check], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[status_updated_date], t.[status_updated_by_user_code], t.[cst_gender_code], t.[cst_call_time], t.[cst_complete_sale], t.[cst_research], t.[cst_dnc_flag], t.[cst_referring_store], t.[cst_referring_stylist], t.[cst_do_not_call], t.[cst_language_code], t.[cst_promotion_code], t.[cst_request_code], t.[cst_age_range_code], t.[cst_hair_loss_code], t.[cst_dnc_date], t.[cst_sessionid], t.[cst_affiliateid], t.[alt_center], t.[cst_loginid], t.[cst_do_not_email], t.[cst_do_not_mail], t.[cst_do_not_text], t.[surgery_consultation_flag], t.[cst_age], t.[cst_hair_loss_spot_code], t.[cst_hair_loss_experience_code], t.[cst_hair_loss_product], t.[cst_hair_loss_in_family_code], t.[cst_hair_loss_family_code], t.[cst_has_valid_cell_phone], t.[cst_has_open_confirmation_call], t.[cst_siebel_id], t.[cst_previous_first_name], t.[cst_previous_last_name], t.[cst_updated_by_user_code], t.[cst_contact_accomodation_code], t.[cst_sfdc_lead_id], t.[cst_do_not_export], t.[cst_import_note]
	from [cdc].[dbo_oncd_contact_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_id], t.[greeting], t.[first_name], t.[middle_name], t.[last_name], t.[suffix], t.[first_name_search], t.[last_name_search], t.[first_name_soundex], t.[last_name_soundex], t.[salutation_code], t.[contact_status_code], t.[external_id], t.[contact_method_code], t.[do_not_solicit], t.[duplicate_check], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[status_updated_date], t.[status_updated_by_user_code], t.[cst_gender_code], t.[cst_call_time], t.[cst_complete_sale], t.[cst_research], t.[cst_dnc_flag], t.[cst_referring_store], t.[cst_referring_stylist], t.[cst_do_not_call], t.[cst_language_code], t.[cst_promotion_code], t.[cst_request_code], t.[cst_age_range_code], t.[cst_hair_loss_code], t.[cst_dnc_date], t.[cst_sessionid], t.[cst_affiliateid], t.[alt_center], t.[cst_loginid], t.[cst_do_not_email], t.[cst_do_not_mail], t.[cst_do_not_text], t.[surgery_consultation_flag], t.[cst_age], t.[cst_hair_loss_spot_code], t.[cst_hair_loss_experience_code], t.[cst_hair_loss_product], t.[cst_hair_loss_in_family_code], t.[cst_hair_loss_family_code], t.[cst_has_valid_cell_phone], t.[cst_has_open_confirmation_call], t.[cst_siebel_id], t.[cst_previous_first_name], t.[cst_previous_last_name], t.[cst_updated_by_user_code], t.[cst_contact_accomodation_code], t.[cst_sfdc_lead_id], t.[cst_do_not_export], t.[cst_import_note]
	from [cdc].[dbo_oncd_contact_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
