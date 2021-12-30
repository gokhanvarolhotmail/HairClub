/* CreateDate: 05/05/2020 18:41:08.753 , ModifyDate: 05/05/2020 18:41:08.753 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cfgEmployeePositionJoin]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [EmployeeGUID], NULL as [EmployeePositionID], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsActiveFlag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgEmployeePositionJoin', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_37F6738A
	    when 1 then __$operation
	    else
			case __$min_op_37F6738A
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
		null as __$update_mask , [EmployeeGUID], [EmployeePositionID], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsActiveFlag]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_37F6738A
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgEmployeePositionJoin_CT] c with (nolock)
			where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) and (c.[EmployeePositionID] = t.[EmployeePositionID])  )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_37F6738A, __$count_37F6738A, t.[EmployeeGUID], t.[EmployeePositionID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsActiveFlag]
		from [cdc].[dbo_cfgEmployeePositionJoin_CT] t with (nolock) inner join
		(	select  r.[EmployeeGUID], r.[EmployeePositionID], max(r.__$seqval) as __$max_seqval_37F6738A,
		    count(*) as __$count_37F6738A
			from [cdc].[dbo_cfgEmployeePositionJoin_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeeGUID], r.[EmployeePositionID]) m
		on t.__$seqval = m.__$max_seqval_37F6738A and
		    ( (t.[EmployeeGUID] = m.[EmployeeGUID]) and (t.[EmployeePositionID] = m.[EmployeePositionID])  )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgEmployeePositionJoin', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgEmployeePositionJoin_CT] c with (nolock)
							where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) and (c.[EmployeePositionID] = t.[EmployeePositionID])  )
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
	    case __$count_37F6738A
	    when 1 then __$operation
	    else
			case __$min_op_37F6738A
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
		case __$count_37F6738A
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_37F6738A
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [EmployeeGUID], [EmployeePositionID], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsActiveFlag]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_37F6738A
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgEmployeePositionJoin_CT] c with (nolock)
			where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) and (c.[EmployeePositionID] = t.[EmployeePositionID])  )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_37F6738A, __$count_37F6738A,
		m.__$update_mask , t.[EmployeeGUID], t.[EmployeePositionID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsActiveFlag]
		from [cdc].[dbo_cfgEmployeePositionJoin_CT] t with (nolock) inner join
		(	select  r.[EmployeeGUID], r.[EmployeePositionID], max(r.__$seqval) as __$max_seqval_37F6738A,
		    count(*) as __$count_37F6738A,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cfgEmployeePositionJoin_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeeGUID], r.[EmployeePositionID]) m
		on t.__$seqval = m.__$max_seqval_37F6738A and
		    ( (t.[EmployeeGUID] = m.[EmployeeGUID]) and (t.[EmployeePositionID] = m.[EmployeePositionID])  )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgEmployeePositionJoin', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgEmployeePositionJoin_CT] c with (nolock)
							where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) and (c.[EmployeePositionID] = t.[EmployeePositionID])  )
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
		null as __$update_mask , t.[EmployeeGUID], t.[EmployeePositionID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsActiveFlag]
		from [cdc].[dbo_cfgEmployeePositionJoin_CT] t  with (nolock) inner join
		(	select  r.[EmployeeGUID], r.[EmployeePositionID], max(r.__$seqval) as __$max_seqval_37F6738A
			from [cdc].[dbo_cfgEmployeePositionJoin_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeeGUID], r.[EmployeePositionID]) m
		on t.__$seqval = m.__$max_seqval_37F6738A and
		    ( (t.[EmployeeGUID] = m.[EmployeeGUID]) and (t.[EmployeePositionID] = m.[EmployeePositionID])  )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgEmployeePositionJoin', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgEmployeePositionJoin_CT] c with (nolock)
							where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) and (c.[EmployeePositionID] = t.[EmployeePositionID])  )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
