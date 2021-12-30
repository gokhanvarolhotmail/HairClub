/* CreateDate: 01/03/2018 17:04:46.147 , ModifyDate: 01/03/2018 17:04:46.147 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_oncd_contact_address]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_address_id], NULL as [contact_id], NULL as [address_type_code], NULL as [address_line_1], NULL as [address_line_2], NULL as [address_line_3], NULL as [address_line_4], NULL as [address_line_1_soundex], NULL as [address_line_2_soundex], NULL as [city], NULL as [city_soundex], NULL as [state_code], NULL as [zip_code], NULL as [county_code], NULL as [country_code], NULL as [time_zone_code], NULL as [sort_order], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [primary_flag], NULL as [company_address_id], NULL as [cst_valid_flag], NULL as [cst_active], NULL as [cst_skip_trace_vendor_code], NULL as [cst_sfdc_leadaddress_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_43854F5A
	    when 1 then __$operation
	    else
			case __$min_op_43854F5A
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		null as __$update_mask , [contact_address_id], [contact_id], [address_type_code], [address_line_1], [address_line_2], [address_line_3], [address_line_4], [address_line_1_soundex], [address_line_2_soundex], [city], [city_soundex], [state_code], [zip_code], [county_code], [country_code], [time_zone_code], [sort_order], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [company_address_id], [cst_valid_flag], [cst_active], [cst_skip_trace_vendor_code], [cst_sfdc_leadaddress_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_43854F5A
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_address_CT] c with (nolock)
			where  ( (c.[contact_address_id] = t.[contact_address_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_43854F5A, __$count_43854F5A, t.[contact_address_id], t.[contact_id], t.[address_type_code], t.[address_line_1], t.[address_line_2], t.[address_line_3], t.[address_line_4], t.[address_line_1_soundex], t.[address_line_2_soundex], t.[city], t.[city_soundex], t.[state_code], t.[zip_code], t.[county_code], t.[country_code], t.[time_zone_code], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[company_address_id], t.[cst_valid_flag], t.[cst_active], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadaddress_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_address_CT] t with (nolock) inner join
		(	select  r.[contact_address_id], max(r.__$seqval) as __$max_seqval_43854F5A,
		    count(*) as __$count_43854F5A
			from [cdc].[dbo_oncd_contact_address_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_address_id]) m
		on t.__$seqval = m.__$max_seqval_43854F5A and
		    ( (t.[contact_address_id] = m.[contact_address_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_address_CT] c with (nolock)
							where  ( (c.[contact_address_id] = t.[contact_address_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

	select __$start_lsn,
	    case __$count_43854F5A
	    when 1 then __$operation
	    else
			case __$min_op_43854F5A
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		case __$count_43854F5A
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_43854F5A
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_address_id], [contact_id], [address_type_code], [address_line_1], [address_line_2], [address_line_3], [address_line_4], [address_line_1_soundex], [address_line_2_soundex], [city], [city_soundex], [state_code], [zip_code], [county_code], [country_code], [time_zone_code], [sort_order], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [company_address_id], [cst_valid_flag], [cst_active], [cst_skip_trace_vendor_code], [cst_sfdc_leadaddress_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_43854F5A
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_address_CT] c with (nolock)
			where  ( (c.[contact_address_id] = t.[contact_address_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_43854F5A, __$count_43854F5A,
		m.__$update_mask , t.[contact_address_id], t.[contact_id], t.[address_type_code], t.[address_line_1], t.[address_line_2], t.[address_line_3], t.[address_line_4], t.[address_line_1_soundex], t.[address_line_2_soundex], t.[city], t.[city_soundex], t.[state_code], t.[zip_code], t.[county_code], t.[country_code], t.[time_zone_code], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[company_address_id], t.[cst_valid_flag], t.[cst_active], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadaddress_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_address_CT] t with (nolock) inner join
		(	select  r.[contact_address_id], max(r.__$seqval) as __$max_seqval_43854F5A,
		    count(*) as __$count_43854F5A,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_oncd_contact_address_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_address_id]) m
		on t.__$seqval = m.__$max_seqval_43854F5A and
		    ( (t.[contact_address_id] = m.[contact_address_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_address_CT] c with (nolock)
							where  ( (c.[contact_address_id] = t.[contact_address_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

		select t.__$start_lsn as __$start_lsn,
		case t.__$operation
			when 1 then 1
			else 5
		end as __$operation,
		null as __$update_mask , t.[contact_address_id], t.[contact_id], t.[address_type_code], t.[address_line_1], t.[address_line_2], t.[address_line_3], t.[address_line_4], t.[address_line_1_soundex], t.[address_line_2_soundex], t.[city], t.[city_soundex], t.[state_code], t.[zip_code], t.[county_code], t.[country_code], t.[time_zone_code], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[company_address_id], t.[cst_valid_flag], t.[cst_active], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadaddress_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_address_CT] t  with (nolock) inner join
		(	select  r.[contact_address_id], max(r.__$seqval) as __$max_seqval_43854F5A
			from [cdc].[dbo_oncd_contact_address_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_address_id]) m
		on t.__$seqval = m.__$max_seqval_43854F5A and
		    ( (t.[contact_address_id] = m.[contact_address_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_address', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_address_CT] c with (nolock)
							where  ( (c.[contact_address_id] = t.[contact_address_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
