/* CreateDate: 01/03/2018 17:04:46.893 , ModifyDate: 01/03/2018 17:04:46.893 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_oncd_contact_source]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_source_id], NULL as [contact_id], NULL as [source_code], NULL as [media_code], NULL as [sort_order], NULL as [assignment_date], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [primary_flag], NULL as [cst_dnis_number], NULL as [cst_sub_source_code]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_source', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_7BFC73A6
	    when 1 then __$operation
	    else
			case __$min_op_7BFC73A6
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
		null as __$update_mask , [contact_source_id], [contact_id], [source_code], [media_code], [sort_order], [assignment_date], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [cst_dnis_number], [cst_sub_source_code]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_7BFC73A6
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_source_CT] c with (nolock)
			where  ( (c.[contact_source_id] = t.[contact_source_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_7BFC73A6, __$count_7BFC73A6, t.[contact_source_id], t.[contact_id], t.[source_code], t.[media_code], t.[sort_order], t.[assignment_date], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[cst_dnis_number], t.[cst_sub_source_code]
		from [cdc].[dbo_oncd_contact_source_CT] t with (nolock) inner join
		(	select  r.[contact_source_id], max(r.__$seqval) as __$max_seqval_7BFC73A6,
		    count(*) as __$count_7BFC73A6
			from [cdc].[dbo_oncd_contact_source_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_source_id]) m
		on t.__$seqval = m.__$max_seqval_7BFC73A6 and
		    ( (t.[contact_source_id] = m.[contact_source_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_source', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_source_CT] c with (nolock)
							where  ( (c.[contact_source_id] = t.[contact_source_id]) )
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
	    case __$count_7BFC73A6
	    when 1 then __$operation
	    else
			case __$min_op_7BFC73A6
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
		case __$count_7BFC73A6
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_7BFC73A6
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_source_id], [contact_id], [source_code], [media_code], [sort_order], [assignment_date], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [cst_dnis_number], [cst_sub_source_code]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_7BFC73A6
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_source_CT] c with (nolock)
			where  ( (c.[contact_source_id] = t.[contact_source_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_7BFC73A6, __$count_7BFC73A6,
		m.__$update_mask , t.[contact_source_id], t.[contact_id], t.[source_code], t.[media_code], t.[sort_order], t.[assignment_date], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[cst_dnis_number], t.[cst_sub_source_code]
		from [cdc].[dbo_oncd_contact_source_CT] t with (nolock) inner join
		(	select  r.[contact_source_id], max(r.__$seqval) as __$max_seqval_7BFC73A6,
		    count(*) as __$count_7BFC73A6,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_oncd_contact_source_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_source_id]) m
		on t.__$seqval = m.__$max_seqval_7BFC73A6 and
		    ( (t.[contact_source_id] = m.[contact_source_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_source', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_source_CT] c with (nolock)
							where  ( (c.[contact_source_id] = t.[contact_source_id]) )
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
		null as __$update_mask , t.[contact_source_id], t.[contact_id], t.[source_code], t.[media_code], t.[sort_order], t.[assignment_date], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[cst_dnis_number], t.[cst_sub_source_code]
		from [cdc].[dbo_oncd_contact_source_CT] t  with (nolock) inner join
		(	select  r.[contact_source_id], max(r.__$seqval) as __$max_seqval_7BFC73A6
			from [cdc].[dbo_oncd_contact_source_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_source_id]) m
		on t.__$seqval = m.__$max_seqval_7BFC73A6 and
		    ( (t.[contact_source_id] = m.[contact_source_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_source', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_source_CT] c with (nolock)
							where  ( (c.[contact_source_id] = t.[contact_source_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO