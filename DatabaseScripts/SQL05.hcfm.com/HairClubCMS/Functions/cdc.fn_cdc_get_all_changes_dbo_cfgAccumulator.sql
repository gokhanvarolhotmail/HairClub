/* CreateDate: 05/05/2020 18:40:52.437 , ModifyDate: 05/05/2020 18:40:52.437 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cfgAccumulator]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [AccumulatorID], NULL as [AccumulatorSortOrder], NULL as [AccumulatorDescription], NULL as [AccumulatorDescriptionShort], NULL as [AccumulatorDataTypeID], NULL as [SalesOrderProcessFlag], NULL as [SchedulerProcessFlag], NULL as [SchedulerActionTypeID], NULL as [SchedulerAdjustmentTypeID], NULL as [AdjustARBalanceFlag], NULL as [AdjustContractPriceFlag], NULL as [AdjustContractPaidFlag], NULL as [IsVisibleFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsVisibleToClient], NULL as [ClientDescription]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[AccumulatorID], t.[AccumulatorSortOrder], t.[AccumulatorDescription], t.[AccumulatorDescriptionShort], t.[AccumulatorDataTypeID], t.[SalesOrderProcessFlag], t.[SchedulerProcessFlag], t.[SchedulerActionTypeID], t.[SchedulerAdjustmentTypeID], t.[AdjustARBalanceFlag], t.[AdjustContractPriceFlag], t.[AdjustContractPaidFlag], t.[IsVisibleFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsVisibleToClient], t.[ClientDescription]
	from [cdc].[dbo_cfgAccumulator_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[AccumulatorID], t.[AccumulatorSortOrder], t.[AccumulatorDescription], t.[AccumulatorDescriptionShort], t.[AccumulatorDataTypeID], t.[SalesOrderProcessFlag], t.[SchedulerProcessFlag], t.[SchedulerActionTypeID], t.[SchedulerAdjustmentTypeID], t.[AdjustARBalanceFlag], t.[AdjustContractPriceFlag], t.[AdjustContractPaidFlag], t.[IsVisibleFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsVisibleToClient], t.[ClientDescription]
	from [cdc].[dbo_cfgAccumulator_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgAccumulator', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
