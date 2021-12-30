/* CreateDate: 01/03/2018 17:04:47.323 , ModifyDate: 01/03/2018 17:04:47.323 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_oncd_contact_user]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_user_id], NULL as [contact_id], NULL as [user_code], NULL as [job_function_code], NULL as [primary_flag], NULL as [sort_order], NULL as [assignment_date], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_user_id], t.[contact_id], t.[user_code], t.[job_function_code], t.[primary_flag], t.[sort_order], t.[assignment_date], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
	from [cdc].[dbo_oncd_contact_user_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_user_id], t.[contact_id], t.[user_code], t.[job_function_code], t.[primary_flag], t.[sort_order], t.[assignment_date], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
	from [cdc].[dbo_oncd_contact_user_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
