/* CreateDate: 01/03/2018 17:04:48.163 , ModifyDate: 01/03/2018 17:04:48.163 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cstd_contact_marketing_score]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_marketing_score_id], NULL as [contact_id], NULL as [marketing_score_contact_type_code], NULL as [marketing_score_type], NULL as [marketing_score], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_B9840EFC
	    when 1 then __$operation
	    else
			case __$min_op_B9840EFC
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
		null as __$update_mask , [contact_marketing_score_id], [contact_id], [marketing_score_contact_type_code], [marketing_score_type], [marketing_score], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_B9840EFC
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cstd_contact_marketing_score_CT] c with (nolock)
			where  ( (c.[contact_marketing_score_id] = t.[contact_marketing_score_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_B9840EFC, __$count_B9840EFC, t.[contact_marketing_score_id], t.[contact_id], t.[marketing_score_contact_type_code], t.[marketing_score_type], t.[marketing_score], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
		from [cdc].[dbo_cstd_contact_marketing_score_CT] t with (nolock) inner join
		(	select  r.[contact_marketing_score_id], max(r.__$seqval) as __$max_seqval_B9840EFC,
		    count(*) as __$count_B9840EFC
			from [cdc].[dbo_cstd_contact_marketing_score_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_marketing_score_id]) m
		on t.__$seqval = m.__$max_seqval_B9840EFC and
		    ( (t.[contact_marketing_score_id] = m.[contact_marketing_score_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_contact_marketing_score_CT] c with (nolock)
							where  ( (c.[contact_marketing_score_id] = t.[contact_marketing_score_id]) )
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
	    case __$count_B9840EFC
	    when 1 then __$operation
	    else
			case __$min_op_B9840EFC
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
		case __$count_B9840EFC
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_B9840EFC
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_marketing_score_id], [contact_id], [marketing_score_contact_type_code], [marketing_score_type], [marketing_score], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_B9840EFC
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cstd_contact_marketing_score_CT] c with (nolock)
			where  ( (c.[contact_marketing_score_id] = t.[contact_marketing_score_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_B9840EFC, __$count_B9840EFC,
		m.__$update_mask , t.[contact_marketing_score_id], t.[contact_id], t.[marketing_score_contact_type_code], t.[marketing_score_type], t.[marketing_score], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
		from [cdc].[dbo_cstd_contact_marketing_score_CT] t with (nolock) inner join
		(	select  r.[contact_marketing_score_id], max(r.__$seqval) as __$max_seqval_B9840EFC,
		    count(*) as __$count_B9840EFC,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cstd_contact_marketing_score_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_marketing_score_id]) m
		on t.__$seqval = m.__$max_seqval_B9840EFC and
		    ( (t.[contact_marketing_score_id] = m.[contact_marketing_score_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_contact_marketing_score_CT] c with (nolock)
							where  ( (c.[contact_marketing_score_id] = t.[contact_marketing_score_id]) )
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
		null as __$update_mask , t.[contact_marketing_score_id], t.[contact_id], t.[marketing_score_contact_type_code], t.[marketing_score_type], t.[marketing_score], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code]
		from [cdc].[dbo_cstd_contact_marketing_score_CT] t  with (nolock) inner join
		(	select  r.[contact_marketing_score_id], max(r.__$seqval) as __$max_seqval_B9840EFC
			from [cdc].[dbo_cstd_contact_marketing_score_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_marketing_score_id]) m
		on t.__$seqval = m.__$max_seqval_B9840EFC and
		    ( (t.[contact_marketing_score_id] = m.[contact_marketing_score_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_marketing_score', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_contact_marketing_score_CT] c with (nolock)
							where  ( (c.[contact_marketing_score_id] = t.[contact_marketing_score_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
