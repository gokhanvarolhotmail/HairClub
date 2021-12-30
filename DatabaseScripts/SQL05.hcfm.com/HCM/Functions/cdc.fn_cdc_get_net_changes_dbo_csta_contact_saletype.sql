/* CreateDate: 01/03/2018 17:04:37.460 , ModifyDate: 01/03/2018 17:04:37.460 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_csta_contact_saletype]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [saletype_code], NULL as [description], NULL as [active], NULL as [frame], NULL as [price], NULL as [select_size_flag], NULL as [size_sets_price], NULL as [length_sets_price], NULL as [base_is_init_pay], NULL as [percentage], NULL as [message_under], NULL as [message_over], NULL as [systems], NULL as [BusinessSegmentID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_C7D0F923
	    when 1 then __$operation
	    else
			case __$min_op_C7D0F923
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
		null as __$update_mask , [saletype_code], [description], [active], [frame], [price], [select_size_flag], [size_sets_price], [length_sets_price], [base_is_init_pay], [percentage], [message_under], [message_over], [systems], [BusinessSegmentID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_C7D0F923
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_csta_contact_saletype_CT] c with (nolock)
			where  ( (c.[saletype_code] = t.[saletype_code]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_C7D0F923, __$count_C7D0F923, t.[saletype_code], t.[description], t.[active], t.[frame], t.[price], t.[select_size_flag], t.[size_sets_price], t.[length_sets_price], t.[base_is_init_pay], t.[percentage], t.[message_under], t.[message_over], t.[systems], t.[BusinessSegmentID]
		from [cdc].[dbo_csta_contact_saletype_CT] t with (nolock) inner join
		(	select  r.[saletype_code], max(r.__$seqval) as __$max_seqval_C7D0F923,
		    count(*) as __$count_C7D0F923
			from [cdc].[dbo_csta_contact_saletype_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[saletype_code]) m
		on t.__$seqval = m.__$max_seqval_C7D0F923 and
		    ( (t.[saletype_code] = m.[saletype_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_csta_contact_saletype_CT] c with (nolock)
							where  ( (c.[saletype_code] = t.[saletype_code]) )
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
	    case __$count_C7D0F923
	    when 1 then __$operation
	    else
			case __$min_op_C7D0F923
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
		case __$count_C7D0F923
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_C7D0F923
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [saletype_code], [description], [active], [frame], [price], [select_size_flag], [size_sets_price], [length_sets_price], [base_is_init_pay], [percentage], [message_under], [message_over], [systems], [BusinessSegmentID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_C7D0F923
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_csta_contact_saletype_CT] c with (nolock)
			where  ( (c.[saletype_code] = t.[saletype_code]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_C7D0F923, __$count_C7D0F923,
		m.__$update_mask , t.[saletype_code], t.[description], t.[active], t.[frame], t.[price], t.[select_size_flag], t.[size_sets_price], t.[length_sets_price], t.[base_is_init_pay], t.[percentage], t.[message_under], t.[message_over], t.[systems], t.[BusinessSegmentID]
		from [cdc].[dbo_csta_contact_saletype_CT] t with (nolock) inner join
		(	select  r.[saletype_code], max(r.__$seqval) as __$max_seqval_C7D0F923,
		    count(*) as __$count_C7D0F923,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_csta_contact_saletype_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[saletype_code]) m
		on t.__$seqval = m.__$max_seqval_C7D0F923 and
		    ( (t.[saletype_code] = m.[saletype_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_csta_contact_saletype_CT] c with (nolock)
							where  ( (c.[saletype_code] = t.[saletype_code]) )
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
		null as __$update_mask , t.[saletype_code], t.[description], t.[active], t.[frame], t.[price], t.[select_size_flag], t.[size_sets_price], t.[length_sets_price], t.[base_is_init_pay], t.[percentage], t.[message_under], t.[message_over], t.[systems], t.[BusinessSegmentID]
		from [cdc].[dbo_csta_contact_saletype_CT] t  with (nolock) inner join
		(	select  r.[saletype_code], max(r.__$seqval) as __$max_seqval_C7D0F923
			from [cdc].[dbo_csta_contact_saletype_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[saletype_code]) m
		on t.__$seqval = m.__$max_seqval_C7D0F923 and
		    ( (t.[saletype_code] = m.[saletype_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_csta_contact_saletype', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_csta_contact_saletype_CT] c with (nolock)
							where  ( (c.[saletype_code] = t.[saletype_code]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
