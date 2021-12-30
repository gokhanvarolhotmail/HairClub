/* CreateDate: 01/03/2018 17:04:44.603 , ModifyDate: 01/03/2018 17:04:44.603 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_onca_action]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [action_code], NULL as [description], NULL as [action_type_code], NULL as [chain_id], NULL as [schedule_type], NULL as [prompt_for_schedule], NULL as [available_to_outlook], NULL as [available_to_mobile], NULL as [prompt_for_next], NULL as [source_code], NULL as [campaign_code], NULL as [active], NULL as [sort_order], NULL as [cst_noble_exclusion], NULL as [cst_noble_addition], NULL as [cst_is_outbound_call], NULL as [cst_category_code]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[action_code], t.[description], t.[action_type_code], t.[chain_id], t.[schedule_type], t.[prompt_for_schedule], t.[available_to_outlook], t.[available_to_mobile], t.[prompt_for_next], t.[source_code], t.[campaign_code], t.[active], t.[sort_order], t.[cst_noble_exclusion], t.[cst_noble_addition], t.[cst_is_outbound_call], t.[cst_category_code]
	from [cdc].[dbo_onca_action_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[action_code], t.[description], t.[action_type_code], t.[chain_id], t.[schedule_type], t.[prompt_for_schedule], t.[available_to_outlook], t.[available_to_mobile], t.[prompt_for_next], t.[source_code], t.[campaign_code], t.[active], t.[sort_order], t.[cst_noble_exclusion], t.[cst_noble_addition], t.[cst_is_outbound_call], t.[cst_category_code]
	from [cdc].[dbo_onca_action_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
