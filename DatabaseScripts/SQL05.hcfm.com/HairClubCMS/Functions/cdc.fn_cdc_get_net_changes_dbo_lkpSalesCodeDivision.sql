/* CreateDate: 05/05/2020 18:41:03.413 , ModifyDate: 05/05/2020 18:41:03.413 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_lkpSalesCodeDivision]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesCodeDivisionID], NULL as [SalesCodeDivisionSortOrder], NULL as [SalesCodeDivisionDescription], NULL as [SalesCodeDivisionDescriptionShort], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSalesCodeDivision', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_3EBF6B18
	    when 1 then __$operation
	    else
			case __$min_op_3EBF6B18
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
		null as __$update_mask , [SalesCodeDivisionID], [SalesCodeDivisionSortOrder], [SalesCodeDivisionDescription], [SalesCodeDivisionDescriptionShort], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_3EBF6B18
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpSalesCodeDivision_CT] c with (nolock)
			where  ( (c.[SalesCodeDivisionID] = t.[SalesCodeDivisionID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_3EBF6B18, __$count_3EBF6B18, t.[SalesCodeDivisionID], t.[SalesCodeDivisionSortOrder], t.[SalesCodeDivisionDescription], t.[SalesCodeDivisionDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
		from [cdc].[dbo_lkpSalesCodeDivision_CT] t with (nolock) inner join
		(	select  r.[SalesCodeDivisionID], max(r.__$seqval) as __$max_seqval_3EBF6B18,
		    count(*) as __$count_3EBF6B18
			from [cdc].[dbo_lkpSalesCodeDivision_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesCodeDivisionID]) m
		on t.__$seqval = m.__$max_seqval_3EBF6B18 and
		    ( (t.[SalesCodeDivisionID] = m.[SalesCodeDivisionID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSalesCodeDivision', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpSalesCodeDivision_CT] c with (nolock)
							where  ( (c.[SalesCodeDivisionID] = t.[SalesCodeDivisionID]) )
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
	    case __$count_3EBF6B18
	    when 1 then __$operation
	    else
			case __$min_op_3EBF6B18
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
		case __$count_3EBF6B18
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_3EBF6B18
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [SalesCodeDivisionID], [SalesCodeDivisionSortOrder], [SalesCodeDivisionDescription], [SalesCodeDivisionDescriptionShort], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_3EBF6B18
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpSalesCodeDivision_CT] c with (nolock)
			where  ( (c.[SalesCodeDivisionID] = t.[SalesCodeDivisionID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_3EBF6B18, __$count_3EBF6B18,
		m.__$update_mask , t.[SalesCodeDivisionID], t.[SalesCodeDivisionSortOrder], t.[SalesCodeDivisionDescription], t.[SalesCodeDivisionDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
		from [cdc].[dbo_lkpSalesCodeDivision_CT] t with (nolock) inner join
		(	select  r.[SalesCodeDivisionID], max(r.__$seqval) as __$max_seqval_3EBF6B18,
		    count(*) as __$count_3EBF6B18,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_lkpSalesCodeDivision_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesCodeDivisionID]) m
		on t.__$seqval = m.__$max_seqval_3EBF6B18 and
		    ( (t.[SalesCodeDivisionID] = m.[SalesCodeDivisionID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSalesCodeDivision', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpSalesCodeDivision_CT] c with (nolock)
							where  ( (c.[SalesCodeDivisionID] = t.[SalesCodeDivisionID]) )
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
		null as __$update_mask , t.[SalesCodeDivisionID], t.[SalesCodeDivisionSortOrder], t.[SalesCodeDivisionDescription], t.[SalesCodeDivisionDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
		from [cdc].[dbo_lkpSalesCodeDivision_CT] t  with (nolock) inner join
		(	select  r.[SalesCodeDivisionID], max(r.__$seqval) as __$max_seqval_3EBF6B18
			from [cdc].[dbo_lkpSalesCodeDivision_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesCodeDivisionID]) m
		on t.__$seqval = m.__$max_seqval_3EBF6B18 and
		    ( (t.[SalesCodeDivisionID] = m.[SalesCodeDivisionID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSalesCodeDivision', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpSalesCodeDivision_CT] c with (nolock)
							where  ( (c.[SalesCodeDivisionID] = t.[SalesCodeDivisionID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
