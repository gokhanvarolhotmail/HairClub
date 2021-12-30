/* CreateDate: 01/03/2018 17:04:44.100 , ModifyDate: 01/03/2018 17:04:44.100 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cstd_activity_demographic]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [activity_demographic_id], NULL as [activity_id], NULL as [gender], NULL as [birthday], NULL as [occupation_code], NULL as [ethnicity_code], NULL as [maritalstatus_code], NULL as [norwood], NULL as [ludwig], NULL as [age], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [performer], NULL as [price_quoted], NULL as [solution_offered], NULL as [no_sale_reason], NULL as [disc_style]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[activity_demographic_id], t.[activity_id], t.[gender], t.[birthday], t.[occupation_code], t.[ethnicity_code], t.[maritalstatus_code], t.[norwood], t.[ludwig], t.[age], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[performer], t.[price_quoted], t.[solution_offered], t.[no_sale_reason], t.[disc_style]
	from [cdc].[dbo_cstd_activity_demographic_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[activity_demographic_id], t.[activity_id], t.[gender], t.[birthday], t.[occupation_code], t.[ethnicity_code], t.[maritalstatus_code], t.[norwood], t.[ludwig], t.[age], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[performer], t.[price_quoted], t.[solution_offered], t.[no_sale_reason], t.[disc_style]
	from [cdc].[dbo_cstd_activity_demographic_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
