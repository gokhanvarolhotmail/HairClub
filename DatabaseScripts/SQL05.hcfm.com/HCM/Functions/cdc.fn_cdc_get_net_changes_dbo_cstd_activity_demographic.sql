/* CreateDate: 01/03/2018 17:04:44.107 , ModifyDate: 01/03/2018 17:04:44.107 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cstd_activity_demographic]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [activity_demographic_id], NULL as [activity_id], NULL as [gender], NULL as [birthday], NULL as [occupation_code], NULL as [ethnicity_code], NULL as [maritalstatus_code], NULL as [norwood], NULL as [ludwig], NULL as [age], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [performer], NULL as [price_quoted], NULL as [solution_offered], NULL as [no_sale_reason], NULL as [disc_style]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_511BB9A2
	    when 1 then __$operation
	    else
			case __$min_op_511BB9A2
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
		null as __$update_mask , [activity_demographic_id], [activity_id], [gender], [birthday], [occupation_code], [ethnicity_code], [maritalstatus_code], [norwood], [ludwig], [age], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [performer], [price_quoted], [solution_offered], [no_sale_reason], [disc_style]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_511BB9A2
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cstd_activity_demographic_CT] c with (nolock)
			where  ( (c.[activity_demographic_id] = t.[activity_demographic_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_511BB9A2, __$count_511BB9A2, t.[activity_demographic_id], t.[activity_id], t.[gender], t.[birthday], t.[occupation_code], t.[ethnicity_code], t.[maritalstatus_code], t.[norwood], t.[ludwig], t.[age], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[performer], t.[price_quoted], t.[solution_offered], t.[no_sale_reason], t.[disc_style]
		from [cdc].[dbo_cstd_activity_demographic_CT] t with (nolock) inner join
		(	select  r.[activity_demographic_id], max(r.__$seqval) as __$max_seqval_511BB9A2,
		    count(*) as __$count_511BB9A2
			from [cdc].[dbo_cstd_activity_demographic_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[activity_demographic_id]) m
		on t.__$seqval = m.__$max_seqval_511BB9A2 and
		    ( (t.[activity_demographic_id] = m.[activity_demographic_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_activity_demographic_CT] c with (nolock)
							where  ( (c.[activity_demographic_id] = t.[activity_demographic_id]) )
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
	    case __$count_511BB9A2
	    when 1 then __$operation
	    else
			case __$min_op_511BB9A2
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
		case __$count_511BB9A2
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_511BB9A2
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [activity_demographic_id], [activity_id], [gender], [birthday], [occupation_code], [ethnicity_code], [maritalstatus_code], [norwood], [ludwig], [age], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [performer], [price_quoted], [solution_offered], [no_sale_reason], [disc_style]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_511BB9A2
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cstd_activity_demographic_CT] c with (nolock)
			where  ( (c.[activity_demographic_id] = t.[activity_demographic_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_511BB9A2, __$count_511BB9A2,
		m.__$update_mask , t.[activity_demographic_id], t.[activity_id], t.[gender], t.[birthday], t.[occupation_code], t.[ethnicity_code], t.[maritalstatus_code], t.[norwood], t.[ludwig], t.[age], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[performer], t.[price_quoted], t.[solution_offered], t.[no_sale_reason], t.[disc_style]
		from [cdc].[dbo_cstd_activity_demographic_CT] t with (nolock) inner join
		(	select  r.[activity_demographic_id], max(r.__$seqval) as __$max_seqval_511BB9A2,
		    count(*) as __$count_511BB9A2,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cstd_activity_demographic_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[activity_demographic_id]) m
		on t.__$seqval = m.__$max_seqval_511BB9A2 and
		    ( (t.[activity_demographic_id] = m.[activity_demographic_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_activity_demographic_CT] c with (nolock)
							where  ( (c.[activity_demographic_id] = t.[activity_demographic_id]) )
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
		null as __$update_mask , t.[activity_demographic_id], t.[activity_id], t.[gender], t.[birthday], t.[occupation_code], t.[ethnicity_code], t.[maritalstatus_code], t.[norwood], t.[ludwig], t.[age], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[performer], t.[price_quoted], t.[solution_offered], t.[no_sale_reason], t.[disc_style]
		from [cdc].[dbo_cstd_activity_demographic_CT] t  with (nolock) inner join
		(	select  r.[activity_demographic_id], max(r.__$seqval) as __$max_seqval_511BB9A2
			from [cdc].[dbo_cstd_activity_demographic_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[activity_demographic_id]) m
		on t.__$seqval = m.__$max_seqval_511BB9A2 and
		    ( (t.[activity_demographic_id] = m.[activity_demographic_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_activity_demographic', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_activity_demographic_CT] c with (nolock)
							where  ( (c.[activity_demographic_id] = t.[activity_demographic_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
