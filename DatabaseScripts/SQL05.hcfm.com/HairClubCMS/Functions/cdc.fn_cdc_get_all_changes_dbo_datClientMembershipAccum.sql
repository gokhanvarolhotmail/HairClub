/* CreateDate: 05/05/2020 18:41:04.180 , ModifyDate: 05/05/2020 18:41:04.180 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datClientMembershipAccum]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ClientMembershipAccumGUID], NULL as [ClientMembershipGUID], NULL as [AccumulatorID], NULL as [UsedAccumQuantity], NULL as [AccumMoney], NULL as [AccumDate], NULL as [TotalAccumQuantity], NULL as [AccumQuantityRemainingCalc], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [ClientMembershipAddOnID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembershipAccum', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientMembershipAccumGUID], t.[ClientMembershipGUID], t.[AccumulatorID], t.[UsedAccumQuantity], t.[AccumMoney], t.[AccumDate], t.[TotalAccumQuantity], t.[AccumQuantityRemainingCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipAddOnID]
	from [cdc].[dbo_datClientMembershipAccum_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembershipAccum', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientMembershipAccumGUID], t.[ClientMembershipGUID], t.[AccumulatorID], t.[UsedAccumQuantity], t.[AccumMoney], t.[AccumDate], t.[TotalAccumQuantity], t.[AccumQuantityRemainingCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipAddOnID]
	from [cdc].[dbo_datClientMembershipAccum_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembershipAccum', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
