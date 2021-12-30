/* CreateDate: 01/03/2018 17:04:44.377 , ModifyDate: 01/03/2018 17:04:44.377 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cstd_contact_completion]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_completion_id], NULL as [company_id], NULL as [created_by_user_code], NULL as [updated_by_user_code], NULL as [contact_id], NULL as [sale_type_code], NULL as [sale_type_description], NULL as [show_no_show_flag], NULL as [sale_no_sale_flag], NULL as [contract_number], NULL as [contract_amount], NULL as [client_number], NULL as [initial_payment], NULL as [systems], NULL as [services], NULL as [number_of_graphs], NULL as [original_appointment_date], NULL as [date_saved], NULL as [status_line], NULL as [head_size], NULL as [base_price], NULL as [discount_amount], NULL as [discount_percentage], NULL as [balance_amount], NULL as [balance_percentage], NULL as [hair_length], NULL as [reschedule_flag], NULL as [date_rescheduled], NULL as [time_rescheduled], NULL as [discount_markup_flag], NULL as [comment], NULL as [followup_result_id], NULL as [followup_result], NULL as [surgery_offered_flag], NULL as [referred_to_doctor_flag], NULL as [creation_date], NULL as [updated_date], NULL as [activity_id], NULL as [length_price], NULL as [surgery_consultation_flag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_completion_id], t.[company_id], t.[created_by_user_code], t.[updated_by_user_code], t.[contact_id], t.[sale_type_code], t.[sale_type_description], t.[show_no_show_flag], t.[sale_no_sale_flag], t.[contract_number], t.[contract_amount], t.[client_number], t.[initial_payment], t.[systems], t.[services], t.[number_of_graphs], t.[original_appointment_date], t.[date_saved], t.[status_line], t.[head_size], t.[base_price], t.[discount_amount], t.[discount_percentage], t.[balance_amount], t.[balance_percentage], t.[hair_length], t.[reschedule_flag], t.[date_rescheduled], t.[time_rescheduled], t.[discount_markup_flag], t.[comment], t.[followup_result_id], t.[followup_result], t.[surgery_offered_flag], t.[referred_to_doctor_flag], t.[creation_date], t.[updated_date], t.[activity_id], t.[length_price], t.[surgery_consultation_flag]
	from [cdc].[dbo_cstd_contact_completion_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_completion_id], t.[company_id], t.[created_by_user_code], t.[updated_by_user_code], t.[contact_id], t.[sale_type_code], t.[sale_type_description], t.[show_no_show_flag], t.[sale_no_sale_flag], t.[contract_number], t.[contract_amount], t.[client_number], t.[initial_payment], t.[systems], t.[services], t.[number_of_graphs], t.[original_appointment_date], t.[date_saved], t.[status_line], t.[head_size], t.[base_price], t.[discount_amount], t.[discount_percentage], t.[balance_amount], t.[balance_percentage], t.[hair_length], t.[reschedule_flag], t.[date_rescheduled], t.[time_rescheduled], t.[discount_markup_flag], t.[comment], t.[followup_result_id], t.[followup_result], t.[surgery_offered_flag], t.[referred_to_doctor_flag], t.[creation_date], t.[updated_date], t.[activity_id], t.[length_price], t.[surgery_consultation_flag]
	from [cdc].[dbo_cstd_contact_completion_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
