/* CreateDate: 01/03/2018 17:04:37.450 , ModifyDate: 01/03/2018 17:04:37.450 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_csta_contact_saletype]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [saletype_code], NULL as [description], NULL as [active], NULL as [frame], NULL as [price], NULL as [select_size_flag], NULL as [size_sets_price], NULL as [length_sets_price], NULL as [base_is_init_pay], NULL as [percentage], NULL as [message_under], NULL as [message_over], NULL as [systems], NULL as [BusinessSegmentID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[saletype_code], t.[description], t.[active], t.[frame], t.[price], t.[select_size_flag], t.[size_sets_price], t.[length_sets_price], t.[base_is_init_pay], t.[percentage], t.[message_under], t.[message_over], t.[systems], t.[BusinessSegmentID]
	from [cdc].[dbo_csta_contact_saletype_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[saletype_code], t.[description], t.[active], t.[frame], t.[price], t.[select_size_flag], t.[size_sets_price], t.[length_sets_price], t.[base_is_init_pay], t.[percentage], t.[message_under], t.[message_over], t.[systems], t.[BusinessSegmentID]
	from [cdc].[dbo_csta_contact_saletype_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
