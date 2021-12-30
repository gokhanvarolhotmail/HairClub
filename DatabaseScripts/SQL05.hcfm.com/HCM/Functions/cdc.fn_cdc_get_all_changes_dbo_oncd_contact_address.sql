/* CreateDate: 01/03/2018 17:04:46.140 , ModifyDate: 01/03/2018 17:04:46.140 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_oncd_contact_address]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_address_id], NULL as [contact_id], NULL as [address_type_code], NULL as [address_line_1], NULL as [address_line_2], NULL as [address_line_3], NULL as [address_line_4], NULL as [address_line_1_soundex], NULL as [address_line_2_soundex], NULL as [city], NULL as [city_soundex], NULL as [state_code], NULL as [zip_code], NULL as [county_code], NULL as [country_code], NULL as [time_zone_code], NULL as [sort_order], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [primary_flag], NULL as [company_address_id], NULL as [cst_valid_flag], NULL as [cst_active], NULL as [cst_skip_trace_vendor_code], NULL as [cst_sfdc_leadaddress_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_address_id], t.[contact_id], t.[address_type_code], t.[address_line_1], t.[address_line_2], t.[address_line_3], t.[address_line_4], t.[address_line_1_soundex], t.[address_line_2_soundex], t.[city], t.[city_soundex], t.[state_code], t.[zip_code], t.[county_code], t.[country_code], t.[time_zone_code], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[company_address_id], t.[cst_valid_flag], t.[cst_active], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadaddress_id], t.[cst_do_not_export], t.[cst_import_note]
	from [cdc].[dbo_oncd_contact_address_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[contact_address_id], t.[contact_id], t.[address_type_code], t.[address_line_1], t.[address_line_2], t.[address_line_3], t.[address_line_4], t.[address_line_1_soundex], t.[address_line_2_soundex], t.[city], t.[city_soundex], t.[state_code], t.[zip_code], t.[county_code], t.[country_code], t.[time_zone_code], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[company_address_id], t.[cst_valid_flag], t.[cst_active], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadaddress_id], t.[cst_do_not_export], t.[cst_import_note]
	from [cdc].[dbo_oncd_contact_address_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
