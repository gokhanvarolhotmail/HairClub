/* CreateDate: 01/03/2018 17:04:44.607 , ModifyDate: 01/03/2018 17:04:44.607 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_onca_action]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [action_code], NULL as [description], NULL as [action_type_code], NULL as [chain_id], NULL as [schedule_type], NULL as [prompt_for_schedule], NULL as [available_to_outlook], NULL as [available_to_mobile], NULL as [prompt_for_next], NULL as [source_code], NULL as [campaign_code], NULL as [active], NULL as [sort_order], NULL as [cst_noble_exclusion], NULL as [cst_noble_addition], NULL as [cst_is_outbound_call], NULL as [cst_category_code]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_C960D716
	    when 1 then __$operation
	    else
			case __$min_op_C960D716
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
		null as __$update_mask , [action_code], [description], [action_type_code], [chain_id], [schedule_type], [prompt_for_schedule], [available_to_outlook], [available_to_mobile], [prompt_for_next], [source_code], [campaign_code], [active], [sort_order], [cst_noble_exclusion], [cst_noble_addition], [cst_is_outbound_call], [cst_category_code]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_C960D716
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_onca_action_CT] c with (nolock)
			where  ( (c.[action_code] = t.[action_code]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_C960D716, __$count_C960D716, t.[action_code], t.[description], t.[action_type_code], t.[chain_id], t.[schedule_type], t.[prompt_for_schedule], t.[available_to_outlook], t.[available_to_mobile], t.[prompt_for_next], t.[source_code], t.[campaign_code], t.[active], t.[sort_order], t.[cst_noble_exclusion], t.[cst_noble_addition], t.[cst_is_outbound_call], t.[cst_category_code]
		from [cdc].[dbo_onca_action_CT] t with (nolock) inner join
		(	select  r.[action_code], max(r.__$seqval) as __$max_seqval_C960D716,
		    count(*) as __$count_C960D716
			from [cdc].[dbo_onca_action_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[action_code]) m
		on t.__$seqval = m.__$max_seqval_C960D716 and
		    ( (t.[action_code] = m.[action_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_action_CT] c with (nolock)
							where  ( (c.[action_code] = t.[action_code]) )
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
	    case __$count_C960D716
	    when 1 then __$operation
	    else
			case __$min_op_C960D716
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
		case __$count_C960D716
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_C960D716
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [action_code], [description], [action_type_code], [chain_id], [schedule_type], [prompt_for_schedule], [available_to_outlook], [available_to_mobile], [prompt_for_next], [source_code], [campaign_code], [active], [sort_order], [cst_noble_exclusion], [cst_noble_addition], [cst_is_outbound_call], [cst_category_code]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_C960D716
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_onca_action_CT] c with (nolock)
			where  ( (c.[action_code] = t.[action_code]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_C960D716, __$count_C960D716,
		m.__$update_mask , t.[action_code], t.[description], t.[action_type_code], t.[chain_id], t.[schedule_type], t.[prompt_for_schedule], t.[available_to_outlook], t.[available_to_mobile], t.[prompt_for_next], t.[source_code], t.[campaign_code], t.[active], t.[sort_order], t.[cst_noble_exclusion], t.[cst_noble_addition], t.[cst_is_outbound_call], t.[cst_category_code]
		from [cdc].[dbo_onca_action_CT] t with (nolock) inner join
		(	select  r.[action_code], max(r.__$seqval) as __$max_seqval_C960D716,
		    count(*) as __$count_C960D716,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_onca_action_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[action_code]) m
		on t.__$seqval = m.__$max_seqval_C960D716 and
		    ( (t.[action_code] = m.[action_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_action_CT] c with (nolock)
							where  ( (c.[action_code] = t.[action_code]) )
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
		null as __$update_mask , t.[action_code], t.[description], t.[action_type_code], t.[chain_id], t.[schedule_type], t.[prompt_for_schedule], t.[available_to_outlook], t.[available_to_mobile], t.[prompt_for_next], t.[source_code], t.[campaign_code], t.[active], t.[sort_order], t.[cst_noble_exclusion], t.[cst_noble_addition], t.[cst_is_outbound_call], t.[cst_category_code]
		from [cdc].[dbo_onca_action_CT] t  with (nolock) inner join
		(	select  r.[action_code], max(r.__$seqval) as __$max_seqval_C960D716
			from [cdc].[dbo_onca_action_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[action_code]) m
		on t.__$seqval = m.__$max_seqval_C960D716 and
		    ( (t.[action_code] = m.[action_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_action', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_action_CT] c with (nolock)
							where  ( (c.[action_code] = t.[action_code]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
