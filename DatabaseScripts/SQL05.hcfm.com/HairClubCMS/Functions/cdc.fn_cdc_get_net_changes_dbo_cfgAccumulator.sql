/* CreateDate: 05/05/2020 18:40:52.440 , ModifyDate: 05/05/2020 18:40:52.440 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cfgAccumulator]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [AccumulatorID], NULL as [AccumulatorSortOrder], NULL as [AccumulatorDescription], NULL as [AccumulatorDescriptionShort], NULL as [AccumulatorDataTypeID], NULL as [SalesOrderProcessFlag], NULL as [SchedulerProcessFlag], NULL as [SchedulerActionTypeID], NULL as [SchedulerAdjustmentTypeID], NULL as [AdjustARBalanceFlag], NULL as [AdjustContractPriceFlag], NULL as [AdjustContractPaidFlag], NULL as [IsVisibleFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsVisibleToClient], NULL as [ClientDescription]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_F5EACE07
	    when 1 then __$operation
	    else
			case __$min_op_F5EACE07
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
		null as __$update_mask , [AccumulatorID], [AccumulatorSortOrder], [AccumulatorDescription], [AccumulatorDescriptionShort], [AccumulatorDataTypeID], [SalesOrderProcessFlag], [SchedulerProcessFlag], [SchedulerActionTypeID], [SchedulerAdjustmentTypeID], [AdjustARBalanceFlag], [AdjustContractPriceFlag], [AdjustContractPaidFlag], [IsVisibleFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsVisibleToClient], [ClientDescription]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_F5EACE07
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgAccumulator_CT] c with (nolock)
			where  ( (c.[AccumulatorID] = t.[AccumulatorID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_F5EACE07, __$count_F5EACE07, t.[AccumulatorID], t.[AccumulatorSortOrder], t.[AccumulatorDescription], t.[AccumulatorDescriptionShort], t.[AccumulatorDataTypeID], t.[SalesOrderProcessFlag], t.[SchedulerProcessFlag], t.[SchedulerActionTypeID], t.[SchedulerAdjustmentTypeID], t.[AdjustARBalanceFlag], t.[AdjustContractPriceFlag], t.[AdjustContractPaidFlag], t.[IsVisibleFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsVisibleToClient], t.[ClientDescription]
		from [cdc].[dbo_cfgAccumulator_CT] t with (nolock) inner join
		(	select  r.[AccumulatorID], max(r.__$seqval) as __$max_seqval_F5EACE07,
		    count(*) as __$count_F5EACE07
			from [cdc].[dbo_cfgAccumulator_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AccumulatorID]) m
		on t.__$seqval = m.__$max_seqval_F5EACE07 and
		    ( (t.[AccumulatorID] = m.[AccumulatorID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgAccumulator_CT] c with (nolock)
							where  ( (c.[AccumulatorID] = t.[AccumulatorID]) )
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
	    case __$count_F5EACE07
	    when 1 then __$operation
	    else
			case __$min_op_F5EACE07
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
		case __$count_F5EACE07
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_F5EACE07
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [AccumulatorID], [AccumulatorSortOrder], [AccumulatorDescription], [AccumulatorDescriptionShort], [AccumulatorDataTypeID], [SalesOrderProcessFlag], [SchedulerProcessFlag], [SchedulerActionTypeID], [SchedulerAdjustmentTypeID], [AdjustARBalanceFlag], [AdjustContractPriceFlag], [AdjustContractPaidFlag], [IsVisibleFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsVisibleToClient], [ClientDescription]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_F5EACE07
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgAccumulator_CT] c with (nolock)
			where  ( (c.[AccumulatorID] = t.[AccumulatorID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_F5EACE07, __$count_F5EACE07,
		m.__$update_mask , t.[AccumulatorID], t.[AccumulatorSortOrder], t.[AccumulatorDescription], t.[AccumulatorDescriptionShort], t.[AccumulatorDataTypeID], t.[SalesOrderProcessFlag], t.[SchedulerProcessFlag], t.[SchedulerActionTypeID], t.[SchedulerAdjustmentTypeID], t.[AdjustARBalanceFlag], t.[AdjustContractPriceFlag], t.[AdjustContractPaidFlag], t.[IsVisibleFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsVisibleToClient], t.[ClientDescription]
		from [cdc].[dbo_cfgAccumulator_CT] t with (nolock) inner join
		(	select  r.[AccumulatorID], max(r.__$seqval) as __$max_seqval_F5EACE07,
		    count(*) as __$count_F5EACE07,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cfgAccumulator_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AccumulatorID]) m
		on t.__$seqval = m.__$max_seqval_F5EACE07 and
		    ( (t.[AccumulatorID] = m.[AccumulatorID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgAccumulator_CT] c with (nolock)
							where  ( (c.[AccumulatorID] = t.[AccumulatorID]) )
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
		null as __$update_mask , t.[AccumulatorID], t.[AccumulatorSortOrder], t.[AccumulatorDescription], t.[AccumulatorDescriptionShort], t.[AccumulatorDataTypeID], t.[SalesOrderProcessFlag], t.[SchedulerProcessFlag], t.[SchedulerActionTypeID], t.[SchedulerAdjustmentTypeID], t.[AdjustARBalanceFlag], t.[AdjustContractPriceFlag], t.[AdjustContractPaidFlag], t.[IsVisibleFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsVisibleToClient], t.[ClientDescription]
		from [cdc].[dbo_cfgAccumulator_CT] t  with (nolock) inner join
		(	select  r.[AccumulatorID], max(r.__$seqval) as __$max_seqval_F5EACE07
			from [cdc].[dbo_cfgAccumulator_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AccumulatorID]) m
		on t.__$seqval = m.__$max_seqval_F5EACE07 and
		    ( (t.[AccumulatorID] = m.[AccumulatorID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgAccumulator_CT] c with (nolock)
							where  ( (c.[AccumulatorID] = t.[AccumulatorID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
