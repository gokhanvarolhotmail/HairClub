/* CreateDate: 01/03/2018 17:04:45.280 , ModifyDate: 01/03/2018 17:04:45.280 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_onca_zip]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [zip_id], NULL as [zip_code], NULL as [city], NULL as [country_code], NULL as [state_code], NULL as [zip_code_type], NULL as [county_code], NULL as [latitude], NULL as [longitude], NULL as [area_code], NULL as [finance_code], NULL as [last_line], NULL as [facility_code], NULL as [msa_code], NULL as [pmsa_code], NULL as [cst_dma], NULL as [cst_city_type]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[zip_id], t.[zip_code], t.[city], t.[country_code], t.[state_code], t.[zip_code_type], t.[county_code], t.[latitude], t.[longitude], t.[area_code], t.[finance_code], t.[last_line], t.[facility_code], t.[msa_code], t.[pmsa_code], t.[cst_dma], t.[cst_city_type]
	from [cdc].[dbo_onca_zip_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[zip_id], t.[zip_code], t.[city], t.[country_code], t.[state_code], t.[zip_code_type], t.[county_code], t.[latitude], t.[longitude], t.[area_code], t.[finance_code], t.[last_line], t.[facility_code], t.[msa_code], t.[pmsa_code], t.[cst_dma], t.[cst_city_type]
	from [cdc].[dbo_onca_zip_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
