/* CreateDate: 05/05/2020 18:41:07.360 , ModifyDate: 05/05/2020 18:41:07.360 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_lkpHairSystemOrderStatus]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HairSystemOrderStatusID], NULL as [HairSystemOrderStatusSortOrder], NULL as [HairSystemOrderStatusDescription], NULL as [HairSystemOrderStatusDescriptionShort], NULL as [CanApplyFlag], NULL as [CanTransferFlag], NULL as [CanEditFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [CanCancelFlag], NULL as [IsPreallocationFlag], NULL as [CanRedoFlag], NULL as [CanRepairFlag], NULL as [ShowInHistoryFlag], NULL as [CanAddToStockFlag], NULL as [IncludeInMembershipCountFlag], NULL as [CanRequestCreditFlag], NULL as [IncludeInInventorySnapshotFlag], NULL as [IsInTransitFlag], NULL as [DescriptionResourceKey]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemOrderStatus', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_A9EE565D
	    when 1 then __$operation
	    else
			case __$min_op_A9EE565D
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
		null as __$update_mask , [HairSystemOrderStatusID], [HairSystemOrderStatusSortOrder], [HairSystemOrderStatusDescription], [HairSystemOrderStatusDescriptionShort], [CanApplyFlag], [CanTransferFlag], [CanEditFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [CanCancelFlag], [IsPreallocationFlag], [CanRedoFlag], [CanRepairFlag], [ShowInHistoryFlag], [CanAddToStockFlag], [IncludeInMembershipCountFlag], [CanRequestCreditFlag], [IncludeInInventorySnapshotFlag], [IsInTransitFlag], [DescriptionResourceKey]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_A9EE565D
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpHairSystemOrderStatus_CT] c with (nolock)
			where  ( (c.[HairSystemOrderStatusID] = t.[HairSystemOrderStatusID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_A9EE565D, __$count_A9EE565D, t.[HairSystemOrderStatusID], t.[HairSystemOrderStatusSortOrder], t.[HairSystemOrderStatusDescription], t.[HairSystemOrderStatusDescriptionShort], t.[CanApplyFlag], t.[CanTransferFlag], t.[CanEditFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[CanCancelFlag], t.[IsPreallocationFlag], t.[CanRedoFlag], t.[CanRepairFlag], t.[ShowInHistoryFlag], t.[CanAddToStockFlag], t.[IncludeInMembershipCountFlag], t.[CanRequestCreditFlag], t.[IncludeInInventorySnapshotFlag], t.[IsInTransitFlag], t.[DescriptionResourceKey]
		from [cdc].[dbo_lkpHairSystemOrderStatus_CT] t with (nolock) inner join
		(	select  r.[HairSystemOrderStatusID], max(r.__$seqval) as __$max_seqval_A9EE565D,
		    count(*) as __$count_A9EE565D
			from [cdc].[dbo_lkpHairSystemOrderStatus_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HairSystemOrderStatusID]) m
		on t.__$seqval = m.__$max_seqval_A9EE565D and
		    ( (t.[HairSystemOrderStatusID] = m.[HairSystemOrderStatusID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemOrderStatus', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpHairSystemOrderStatus_CT] c with (nolock)
							where  ( (c.[HairSystemOrderStatusID] = t.[HairSystemOrderStatusID]) )
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
	    case __$count_A9EE565D
	    when 1 then __$operation
	    else
			case __$min_op_A9EE565D
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
		case __$count_A9EE565D
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_A9EE565D
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [HairSystemOrderStatusID], [HairSystemOrderStatusSortOrder], [HairSystemOrderStatusDescription], [HairSystemOrderStatusDescriptionShort], [CanApplyFlag], [CanTransferFlag], [CanEditFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [CanCancelFlag], [IsPreallocationFlag], [CanRedoFlag], [CanRepairFlag], [ShowInHistoryFlag], [CanAddToStockFlag], [IncludeInMembershipCountFlag], [CanRequestCreditFlag], [IncludeInInventorySnapshotFlag], [IsInTransitFlag], [DescriptionResourceKey]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_A9EE565D
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpHairSystemOrderStatus_CT] c with (nolock)
			where  ( (c.[HairSystemOrderStatusID] = t.[HairSystemOrderStatusID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_A9EE565D, __$count_A9EE565D,
		m.__$update_mask , t.[HairSystemOrderStatusID], t.[HairSystemOrderStatusSortOrder], t.[HairSystemOrderStatusDescription], t.[HairSystemOrderStatusDescriptionShort], t.[CanApplyFlag], t.[CanTransferFlag], t.[CanEditFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[CanCancelFlag], t.[IsPreallocationFlag], t.[CanRedoFlag], t.[CanRepairFlag], t.[ShowInHistoryFlag], t.[CanAddToStockFlag], t.[IncludeInMembershipCountFlag], t.[CanRequestCreditFlag], t.[IncludeInInventorySnapshotFlag], t.[IsInTransitFlag], t.[DescriptionResourceKey]
		from [cdc].[dbo_lkpHairSystemOrderStatus_CT] t with (nolock) inner join
		(	select  r.[HairSystemOrderStatusID], max(r.__$seqval) as __$max_seqval_A9EE565D,
		    count(*) as __$count_A9EE565D,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_lkpHairSystemOrderStatus_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HairSystemOrderStatusID]) m
		on t.__$seqval = m.__$max_seqval_A9EE565D and
		    ( (t.[HairSystemOrderStatusID] = m.[HairSystemOrderStatusID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemOrderStatus', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpHairSystemOrderStatus_CT] c with (nolock)
							where  ( (c.[HairSystemOrderStatusID] = t.[HairSystemOrderStatusID]) )
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
		null as __$update_mask , t.[HairSystemOrderStatusID], t.[HairSystemOrderStatusSortOrder], t.[HairSystemOrderStatusDescription], t.[HairSystemOrderStatusDescriptionShort], t.[CanApplyFlag], t.[CanTransferFlag], t.[CanEditFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[CanCancelFlag], t.[IsPreallocationFlag], t.[CanRedoFlag], t.[CanRepairFlag], t.[ShowInHistoryFlag], t.[CanAddToStockFlag], t.[IncludeInMembershipCountFlag], t.[CanRequestCreditFlag], t.[IncludeInInventorySnapshotFlag], t.[IsInTransitFlag], t.[DescriptionResourceKey]
		from [cdc].[dbo_lkpHairSystemOrderStatus_CT] t  with (nolock) inner join
		(	select  r.[HairSystemOrderStatusID], max(r.__$seqval) as __$max_seqval_A9EE565D
			from [cdc].[dbo_lkpHairSystemOrderStatus_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[HairSystemOrderStatusID]) m
		on t.__$seqval = m.__$max_seqval_A9EE565D and
		    ( (t.[HairSystemOrderStatusID] = m.[HairSystemOrderStatusID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemOrderStatus', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpHairSystemOrderStatus_CT] c with (nolock)
							where  ( (c.[HairSystemOrderStatusID] = t.[HairSystemOrderStatusID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
