/* CreateDate: 01/03/2018 17:04:46.713 , ModifyDate: 01/03/2018 17:04:46.713 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_oncd_contact_phone]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_phone_id], NULL as [contact_id], NULL as [phone_type_code], NULL as [country_code_prefix], NULL as [area_code], NULL as [phone_number], NULL as [extension], NULL as [description], NULL as [active], NULL as [sort_order], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [primary_flag], NULL as [cst_valid_flag], NULL as [cst_dnc_code], NULL as [cst_last_dnc_date], NULL as [cst_phone_type_updated_by_user_code], NULL as [cst_phone_type_updated_date], NULL as [cst_full_phone_number], NULL as [cst_skip_trace_vendor_code], NULL as [cst_sfdc_leadphone_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_phone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_6AAF4115
	    when 1 then __$operation
	    else
			case __$min_op_6AAF4115
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
		null as __$update_mask , [contact_phone_id], [contact_id], [phone_type_code], [country_code_prefix], [area_code], [phone_number], [extension], [description], [active], [sort_order], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [cst_valid_flag], [cst_dnc_code], [cst_last_dnc_date], [cst_phone_type_updated_by_user_code], [cst_phone_type_updated_date], [cst_full_phone_number], [cst_skip_trace_vendor_code], [cst_sfdc_leadphone_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_6AAF4115
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_phone_CT] c with (nolock)
			where  ( (c.[contact_phone_id] = t.[contact_phone_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_6AAF4115, __$count_6AAF4115, t.[contact_phone_id], t.[contact_id], t.[phone_type_code], t.[country_code_prefix], t.[area_code], t.[phone_number], t.[extension], t.[description], t.[active], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[cst_valid_flag], t.[cst_dnc_code], t.[cst_last_dnc_date], t.[cst_phone_type_updated_by_user_code], t.[cst_phone_type_updated_date], t.[cst_full_phone_number], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadphone_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_phone_CT] t with (nolock) inner join
		(	select  r.[contact_phone_id], max(r.__$seqval) as __$max_seqval_6AAF4115,
		    count(*) as __$count_6AAF4115
			from [cdc].[dbo_oncd_contact_phone_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_phone_id]) m
		on t.__$seqval = m.__$max_seqval_6AAF4115 and
		    ( (t.[contact_phone_id] = m.[contact_phone_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_phone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_phone_CT] c with (nolock)
							where  ( (c.[contact_phone_id] = t.[contact_phone_id]) )
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
	    case __$count_6AAF4115
	    when 1 then __$operation
	    else
			case __$min_op_6AAF4115
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
		case __$count_6AAF4115
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_6AAF4115
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_phone_id], [contact_id], [phone_type_code], [country_code_prefix], [area_code], [phone_number], [extension], [description], [active], [sort_order], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [cst_valid_flag], [cst_dnc_code], [cst_last_dnc_date], [cst_phone_type_updated_by_user_code], [cst_phone_type_updated_date], [cst_full_phone_number], [cst_skip_trace_vendor_code], [cst_sfdc_leadphone_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_6AAF4115
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_phone_CT] c with (nolock)
			where  ( (c.[contact_phone_id] = t.[contact_phone_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_6AAF4115, __$count_6AAF4115,
		m.__$update_mask , t.[contact_phone_id], t.[contact_id], t.[phone_type_code], t.[country_code_prefix], t.[area_code], t.[phone_number], t.[extension], t.[description], t.[active], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[cst_valid_flag], t.[cst_dnc_code], t.[cst_last_dnc_date], t.[cst_phone_type_updated_by_user_code], t.[cst_phone_type_updated_date], t.[cst_full_phone_number], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadphone_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_phone_CT] t with (nolock) inner join
		(	select  r.[contact_phone_id], max(r.__$seqval) as __$max_seqval_6AAF4115,
		    count(*) as __$count_6AAF4115,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_oncd_contact_phone_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_phone_id]) m
		on t.__$seqval = m.__$max_seqval_6AAF4115 and
		    ( (t.[contact_phone_id] = m.[contact_phone_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_phone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_phone_CT] c with (nolock)
							where  ( (c.[contact_phone_id] = t.[contact_phone_id]) )
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
		null as __$update_mask , t.[contact_phone_id], t.[contact_id], t.[phone_type_code], t.[country_code_prefix], t.[area_code], t.[phone_number], t.[extension], t.[description], t.[active], t.[sort_order], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[cst_valid_flag], t.[cst_dnc_code], t.[cst_last_dnc_date], t.[cst_phone_type_updated_by_user_code], t.[cst_phone_type_updated_date], t.[cst_full_phone_number], t.[cst_skip_trace_vendor_code], t.[cst_sfdc_leadphone_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_phone_CT] t  with (nolock) inner join
		(	select  r.[contact_phone_id], max(r.__$seqval) as __$max_seqval_6AAF4115
			from [cdc].[dbo_oncd_contact_phone_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_phone_id]) m
		on t.__$seqval = m.__$max_seqval_6AAF4115 and
		    ( (t.[contact_phone_id] = m.[contact_phone_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_phone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_phone_CT] c with (nolock)
							where  ( (c.[contact_phone_id] = t.[contact_phone_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
