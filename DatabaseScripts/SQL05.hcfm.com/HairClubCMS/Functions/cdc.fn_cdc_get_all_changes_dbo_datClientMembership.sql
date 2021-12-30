/* CreateDate: 05/05/2020 18:40:59.830 , ModifyDate: 05/05/2020 18:40:59.830 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datClientMembership]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ClientMembershipGUID], NULL as [Member1_ID_Temp], NULL as [ClientGUID], NULL as [CenterID], NULL as [MembershipID], NULL as [ClientMembershipStatusID], NULL as [ContractPrice], NULL as [ContractPaidAmount], NULL as [MonthlyFee], NULL as [BeginDate], NULL as [EndDate], NULL as [MembershipCancelReasonID], NULL as [CancelDate], NULL as [IsGuaranteeFlag], NULL as [IsRenewalFlag], NULL as [IsMultipleSurgeryFlag], NULL as [RenewalCount], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [ClientMembershipIdentifier], NULL as [MembershipCancelReasonDescription], NULL as [HasInHousePaymentPlan], NULL as [NationalMonthlyFee], NULL as [MembershipProfileTypeID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientMembershipGUID], t.[Member1_ID_Temp], t.[ClientGUID], t.[CenterID], t.[MembershipID], t.[ClientMembershipStatusID], t.[ContractPrice], t.[ContractPaidAmount], t.[MonthlyFee], t.[BeginDate], t.[EndDate], t.[MembershipCancelReasonID], t.[CancelDate], t.[IsGuaranteeFlag], t.[IsRenewalFlag], t.[IsMultipleSurgeryFlag], t.[RenewalCount], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipIdentifier], t.[MembershipCancelReasonDescription], t.[HasInHousePaymentPlan], t.[NationalMonthlyFee], t.[MembershipProfileTypeID]
	from [cdc].[dbo_datClientMembership_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientMembershipGUID], t.[Member1_ID_Temp], t.[ClientGUID], t.[CenterID], t.[MembershipID], t.[ClientMembershipStatusID], t.[ContractPrice], t.[ContractPaidAmount], t.[MonthlyFee], t.[BeginDate], t.[EndDate], t.[MembershipCancelReasonID], t.[CancelDate], t.[IsGuaranteeFlag], t.[IsRenewalFlag], t.[IsMultipleSurgeryFlag], t.[RenewalCount], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipIdentifier], t.[MembershipCancelReasonDescription], t.[HasInHousePaymentPlan], t.[NationalMonthlyFee], t.[MembershipProfileTypeID]
	from [cdc].[dbo_datClientMembership_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
