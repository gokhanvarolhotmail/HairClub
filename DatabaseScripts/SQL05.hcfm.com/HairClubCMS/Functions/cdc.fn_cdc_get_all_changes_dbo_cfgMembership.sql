/* CreateDate: 05/05/2020 18:40:58.977 , ModifyDate: 05/05/2020 18:40:58.977 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cfgMembership]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [MembershipID], NULL as [MembershipSortOrder], NULL as [MembershipDescription], NULL as [MembershipDescriptionShort], NULL as [BusinessSegmentID], NULL as [RevenueGroupID], NULL as [GenderID], NULL as [DurationMonths], NULL as [ContractPrice], NULL as [MonthlyFee], NULL as [IsTaxableFlag], NULL as [IsDefaultMembershipFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsHairSystemOrderRushFlag], NULL as [HairSystemGeneralLedgerID], NULL as [DefaultPaymentSalesCodeID], NULL as [NumRenewalDays], NULL as [NumDaysAfterCancelBeforeNew], NULL as [CanCheckinForConsultation], NULL as [MaximumHairSystemHairLengthValue], NULL as [ExpectedConversionDays], NULL as [MinimumAge], NULL as [MaximumAge], NULL as [MaximumLongHairAddOnHairLengthValue], NULL as [BOSSalesTypeCode]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MembershipID], t.[MembershipSortOrder], t.[MembershipDescription], t.[MembershipDescriptionShort], t.[BusinessSegmentID], t.[RevenueGroupID], t.[GenderID], t.[DurationMonths], t.[ContractPrice], t.[MonthlyFee], t.[IsTaxableFlag], t.[IsDefaultMembershipFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemOrderRushFlag], t.[HairSystemGeneralLedgerID], t.[DefaultPaymentSalesCodeID], t.[NumRenewalDays], t.[NumDaysAfterCancelBeforeNew], t.[CanCheckinForConsultation], t.[MaximumHairSystemHairLengthValue], t.[ExpectedConversionDays], t.[MinimumAge], t.[MaximumAge], t.[MaximumLongHairAddOnHairLengthValue], t.[BOSSalesTypeCode]
	from [cdc].[dbo_cfgMembership_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[MembershipID], t.[MembershipSortOrder], t.[MembershipDescription], t.[MembershipDescriptionShort], t.[BusinessSegmentID], t.[RevenueGroupID], t.[GenderID], t.[DurationMonths], t.[ContractPrice], t.[MonthlyFee], t.[IsTaxableFlag], t.[IsDefaultMembershipFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemOrderRushFlag], t.[HairSystemGeneralLedgerID], t.[DefaultPaymentSalesCodeID], t.[NumRenewalDays], t.[NumDaysAfterCancelBeforeNew], t.[CanCheckinForConsultation], t.[MaximumHairSystemHairLengthValue], t.[ExpectedConversionDays], t.[MinimumAge], t.[MaximumAge], t.[MaximumLongHairAddOnHairLengthValue], t.[BOSSalesTypeCode]
	from [cdc].[dbo_cfgMembership_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
