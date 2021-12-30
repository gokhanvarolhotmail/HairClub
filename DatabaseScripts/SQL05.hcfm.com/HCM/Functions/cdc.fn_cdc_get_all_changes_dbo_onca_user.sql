/* CreateDate: 01/03/2018 17:04:45.000 , ModifyDate: 01/03/2018 17:04:45.000 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_onca_user]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [user_code], NULL as [department_code], NULL as [job_function_code], NULL as [login_id], NULL as [password_value], NULL as [password_date], NULL as [password_expires], NULL as [change_password], NULL as [first_name], NULL as [middle_name], NULL as [last_name], NULL as [full_name], NULL as [description], NULL as [title], NULL as [cti_server], NULL as [cti_user_code], NULL as [cti_password], NULL as [cti_station], NULL as [cti_extension], NULL as [action_set_code], NULL as [startup_object_id], NULL as [clear_cache], NULL as [active], NULL as [display_name], NULL as [license_type], NULL as [outlook_sync_frequency], NULL as [outlook_sync_confirm], NULL as [cst_is_queue_user]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[user_code], t.[department_code], t.[job_function_code], t.[login_id], t.[password_value], t.[password_date], t.[password_expires], t.[change_password], t.[first_name], t.[middle_name], t.[last_name], t.[full_name], t.[description], t.[title], t.[cti_server], t.[cti_user_code], t.[cti_password], t.[cti_station], t.[cti_extension], t.[action_set_code], t.[startup_object_id], t.[clear_cache], t.[active], t.[display_name], t.[license_type], t.[outlook_sync_frequency], t.[outlook_sync_confirm], t.[cst_is_queue_user]
	from [cdc].[dbo_onca_user_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[user_code], t.[department_code], t.[job_function_code], t.[login_id], t.[password_value], t.[password_date], t.[password_expires], t.[change_password], t.[first_name], t.[middle_name], t.[last_name], t.[full_name], t.[description], t.[title], t.[cti_server], t.[cti_user_code], t.[cti_password], t.[cti_station], t.[cti_extension], t.[action_set_code], t.[startup_object_id], t.[clear_cache], t.[active], t.[display_name], t.[license_type], t.[outlook_sync_frequency], t.[outlook_sync_confirm], t.[cst_is_queue_user]
	from [cdc].[dbo_onca_user_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
