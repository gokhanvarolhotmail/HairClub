/* CreateDate: 05/05/2020 18:41:03.857 , ModifyDate: 05/05/2020 18:41:03.857 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_lkpTimeZone]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [TimeZoneID], NULL as [TimeZoneSortOrder], NULL as [TimeZoneDescription], NULL as [TimeZoneDescriptionShort], NULL as [UTCOffset], NULL as [UsesDayLightSavingsFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpTimeZone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_CF3344FB
	    when 1 then __$operation
	    else
			case __$min_op_CF3344FB
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
		null as __$update_mask , [TimeZoneID], [TimeZoneSortOrder], [TimeZoneDescription], [TimeZoneDescriptionShort], [UTCOffset], [UsesDayLightSavingsFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CF3344FB
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpTimeZone_CT] c with (nolock)
			where  ( (c.[TimeZoneID] = t.[TimeZoneID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CF3344FB, __$count_CF3344FB, t.[TimeZoneID], t.[TimeZoneSortOrder], t.[TimeZoneDescription], t.[TimeZoneDescriptionShort], t.[UTCOffset], t.[UsesDayLightSavingsFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
		from [cdc].[dbo_lkpTimeZone_CT] t with (nolock) inner join
		(	select  r.[TimeZoneID], max(r.__$seqval) as __$max_seqval_CF3344FB,
		    count(*) as __$count_CF3344FB
			from [cdc].[dbo_lkpTimeZone_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[TimeZoneID]) m
		on t.__$seqval = m.__$max_seqval_CF3344FB and
		    ( (t.[TimeZoneID] = m.[TimeZoneID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpTimeZone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpTimeZone_CT] c with (nolock)
							where  ( (c.[TimeZoneID] = t.[TimeZoneID]) )
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
	    case __$count_CF3344FB
	    when 1 then __$operation
	    else
			case __$min_op_CF3344FB
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
		case __$count_CF3344FB
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_CF3344FB
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [TimeZoneID], [TimeZoneSortOrder], [TimeZoneDescription], [TimeZoneDescriptionShort], [UTCOffset], [UsesDayLightSavingsFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CF3344FB
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpTimeZone_CT] c with (nolock)
			where  ( (c.[TimeZoneID] = t.[TimeZoneID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CF3344FB, __$count_CF3344FB,
		m.__$update_mask , t.[TimeZoneID], t.[TimeZoneSortOrder], t.[TimeZoneDescription], t.[TimeZoneDescriptionShort], t.[UTCOffset], t.[UsesDayLightSavingsFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
		from [cdc].[dbo_lkpTimeZone_CT] t with (nolock) inner join
		(	select  r.[TimeZoneID], max(r.__$seqval) as __$max_seqval_CF3344FB,
		    count(*) as __$count_CF3344FB,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_lkpTimeZone_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[TimeZoneID]) m
		on t.__$seqval = m.__$max_seqval_CF3344FB and
		    ( (t.[TimeZoneID] = m.[TimeZoneID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpTimeZone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpTimeZone_CT] c with (nolock)
							where  ( (c.[TimeZoneID] = t.[TimeZoneID]) )
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
		null as __$update_mask , t.[TimeZoneID], t.[TimeZoneSortOrder], t.[TimeZoneDescription], t.[TimeZoneDescriptionShort], t.[UTCOffset], t.[UsesDayLightSavingsFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
		from [cdc].[dbo_lkpTimeZone_CT] t  with (nolock) inner join
		(	select  r.[TimeZoneID], max(r.__$seqval) as __$max_seqval_CF3344FB
			from [cdc].[dbo_lkpTimeZone_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[TimeZoneID]) m
		on t.__$seqval = m.__$max_seqval_CF3344FB and
		    ( (t.[TimeZoneID] = m.[TimeZoneID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpTimeZone', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpTimeZone_CT] c with (nolock)
							where  ( (c.[TimeZoneID] = t.[TimeZoneID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
