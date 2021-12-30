/* CreateDate: 05/05/2020 18:41:04.017 , ModifyDate: 05/05/2020 18:41:04.017 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datAccumulatorAdjustment]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [AccumulatorAdjustmentGUID], NULL as [ClientMembershipGUID], NULL as [SalesOrderDetailGUID], NULL as [AppointmentGUID], NULL as [AccumulatorID], NULL as [AccumulatorActionTypeID], NULL as [QuantityUsedOriginal], NULL as [QuantityUsedAdjustment], NULL as [QuantityTotalOriginal], NULL as [QuantityTotalAdjustment], NULL as [MoneyOriginal], NULL as [MoneyAdjustment], NULL as [DateOriginal], NULL as [DateAdjustment], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [QuantityUsedNewCalc], NULL as [QuantityUsedChangeCalc], NULL as [QuantityTotalNewCalc], NULL as [QuantityTotalChangeCalc], NULL as [MoneyNewCalc], NULL as [MoneyChangeCalc], NULL as [SalesOrderTenderGuid], NULL as [ClientMembershipAddOnID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datAccumulatorAdjustment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_5B45BCF8
	    when 1 then __$operation
	    else
			case __$min_op_5B45BCF8
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
		null as __$update_mask , [AccumulatorAdjustmentGUID], [ClientMembershipGUID], [SalesOrderDetailGUID], [AppointmentGUID], [AccumulatorID], [AccumulatorActionTypeID], [QuantityUsedOriginal], [QuantityUsedAdjustment], [QuantityTotalOriginal], [QuantityTotalAdjustment], [MoneyOriginal], [MoneyAdjustment], [DateOriginal], [DateAdjustment], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [QuantityUsedNewCalc], [QuantityUsedChangeCalc], [QuantityTotalNewCalc], [QuantityTotalChangeCalc], [MoneyNewCalc], [MoneyChangeCalc], [SalesOrderTenderGuid], [ClientMembershipAddOnID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5B45BCF8
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datAccumulatorAdjustment_CT] c with (nolock)
			where  ( (c.[AccumulatorAdjustmentGUID] = t.[AccumulatorAdjustmentGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_5B45BCF8, __$count_5B45BCF8, t.[AccumulatorAdjustmentGUID], t.[ClientMembershipGUID], t.[SalesOrderDetailGUID], t.[AppointmentGUID], t.[AccumulatorID], t.[AccumulatorActionTypeID], t.[QuantityUsedOriginal], t.[QuantityUsedAdjustment], t.[QuantityTotalOriginal], t.[QuantityTotalAdjustment], t.[MoneyOriginal], t.[MoneyAdjustment], t.[DateOriginal], t.[DateAdjustment], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[QuantityUsedNewCalc], t.[QuantityUsedChangeCalc], t.[QuantityTotalNewCalc], t.[QuantityTotalChangeCalc], t.[MoneyNewCalc], t.[MoneyChangeCalc], t.[SalesOrderTenderGuid], t.[ClientMembershipAddOnID]
		from [cdc].[dbo_datAccumulatorAdjustment_CT] t with (nolock) inner join
		(	select  r.[AccumulatorAdjustmentGUID], max(r.__$seqval) as __$max_seqval_5B45BCF8,
		    count(*) as __$count_5B45BCF8
			from [cdc].[dbo_datAccumulatorAdjustment_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AccumulatorAdjustmentGUID]) m
		on t.__$seqval = m.__$max_seqval_5B45BCF8 and
		    ( (t.[AccumulatorAdjustmentGUID] = m.[AccumulatorAdjustmentGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAccumulatorAdjustment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datAccumulatorAdjustment_CT] c with (nolock)
							where  ( (c.[AccumulatorAdjustmentGUID] = t.[AccumulatorAdjustmentGUID]) )
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
	    case __$count_5B45BCF8
	    when 1 then __$operation
	    else
			case __$min_op_5B45BCF8
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
		case __$count_5B45BCF8
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_5B45BCF8
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [AccumulatorAdjustmentGUID], [ClientMembershipGUID], [SalesOrderDetailGUID], [AppointmentGUID], [AccumulatorID], [AccumulatorActionTypeID], [QuantityUsedOriginal], [QuantityUsedAdjustment], [QuantityTotalOriginal], [QuantityTotalAdjustment], [MoneyOriginal], [MoneyAdjustment], [DateOriginal], [DateAdjustment], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [QuantityUsedNewCalc], [QuantityUsedChangeCalc], [QuantityTotalNewCalc], [QuantityTotalChangeCalc], [MoneyNewCalc], [MoneyChangeCalc], [SalesOrderTenderGuid], [ClientMembershipAddOnID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5B45BCF8
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datAccumulatorAdjustment_CT] c with (nolock)
			where  ( (c.[AccumulatorAdjustmentGUID] = t.[AccumulatorAdjustmentGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_5B45BCF8, __$count_5B45BCF8,
		m.__$update_mask , t.[AccumulatorAdjustmentGUID], t.[ClientMembershipGUID], t.[SalesOrderDetailGUID], t.[AppointmentGUID], t.[AccumulatorID], t.[AccumulatorActionTypeID], t.[QuantityUsedOriginal], t.[QuantityUsedAdjustment], t.[QuantityTotalOriginal], t.[QuantityTotalAdjustment], t.[MoneyOriginal], t.[MoneyAdjustment], t.[DateOriginal], t.[DateAdjustment], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[QuantityUsedNewCalc], t.[QuantityUsedChangeCalc], t.[QuantityTotalNewCalc], t.[QuantityTotalChangeCalc], t.[MoneyNewCalc], t.[MoneyChangeCalc], t.[SalesOrderTenderGuid], t.[ClientMembershipAddOnID]
		from [cdc].[dbo_datAccumulatorAdjustment_CT] t with (nolock) inner join
		(	select  r.[AccumulatorAdjustmentGUID], max(r.__$seqval) as __$max_seqval_5B45BCF8,
		    count(*) as __$count_5B45BCF8,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datAccumulatorAdjustment_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AccumulatorAdjustmentGUID]) m
		on t.__$seqval = m.__$max_seqval_5B45BCF8 and
		    ( (t.[AccumulatorAdjustmentGUID] = m.[AccumulatorAdjustmentGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAccumulatorAdjustment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datAccumulatorAdjustment_CT] c with (nolock)
							where  ( (c.[AccumulatorAdjustmentGUID] = t.[AccumulatorAdjustmentGUID]) )
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
		null as __$update_mask , t.[AccumulatorAdjustmentGUID], t.[ClientMembershipGUID], t.[SalesOrderDetailGUID], t.[AppointmentGUID], t.[AccumulatorID], t.[AccumulatorActionTypeID], t.[QuantityUsedOriginal], t.[QuantityUsedAdjustment], t.[QuantityTotalOriginal], t.[QuantityTotalAdjustment], t.[MoneyOriginal], t.[MoneyAdjustment], t.[DateOriginal], t.[DateAdjustment], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[QuantityUsedNewCalc], t.[QuantityUsedChangeCalc], t.[QuantityTotalNewCalc], t.[QuantityTotalChangeCalc], t.[MoneyNewCalc], t.[MoneyChangeCalc], t.[SalesOrderTenderGuid], t.[ClientMembershipAddOnID]
		from [cdc].[dbo_datAccumulatorAdjustment_CT] t  with (nolock) inner join
		(	select  r.[AccumulatorAdjustmentGUID], max(r.__$seqval) as __$max_seqval_5B45BCF8
			from [cdc].[dbo_datAccumulatorAdjustment_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AccumulatorAdjustmentGUID]) m
		on t.__$seqval = m.__$max_seqval_5B45BCF8 and
		    ( (t.[AccumulatorAdjustmentGUID] = m.[AccumulatorAdjustmentGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAccumulatorAdjustment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datAccumulatorAdjustment_CT] c with (nolock)
							where  ( (c.[AccumulatorAdjustmentGUID] = t.[AccumulatorAdjustmentGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
