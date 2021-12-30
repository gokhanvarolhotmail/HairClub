/* CreateDate: 01/03/2018 17:04:48.157 , ModifyDate: 01/03/2018 17:04:48.157 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cstd_contact_marketing_score]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_marketing_score_id], NULL as [contact_id], NULL as [marketing_score_contact_type_code], NULL as [marketing_score_type], NULL as [marketing_score], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_marketing_score_id], t.[contact_id], t.[marketing_score_contact_type_code], t.[marketing_score_type], t.[marketing_score], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
	from [cdc].[dbo_cstd_contact_marketing_score_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_marketing_score_id], t.[contact_id], t.[marketing_score_contact_type_code], t.[marketing_score_type], t.[marketing_score], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
	from [cdc].[dbo_cstd_contact_marketing_score_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
