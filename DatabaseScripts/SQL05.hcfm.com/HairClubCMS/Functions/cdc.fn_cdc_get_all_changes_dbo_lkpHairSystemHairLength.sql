/* CreateDate: 05/05/2020 18:41:05.397 , ModifyDate: 05/05/2020 18:41:05.397 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_lkpHairSystemHairLength]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HairSystemHairLengthID], NULL as [HairSystemHairLengthSortOrder], NULL as [HairSystemHairLengthDescription], NULL as [HairSystemHairLengthDescriptionShort], NULL as [HairSystemHairLengthValue], NULL as [IsHumanHairAvailableFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsAllowHumanGreyPercentageFlag], NULL as [IsAllowSyntheticGreyPercentageFlag], NULL as [IsAvailableForSignatureHairlineFlag], NULL as [IsAvailableForOmbreFlag], NULL as [IsLongHairAddOnFlag], NULL as [IsCuticleIntactAvailableFlag], NULL as [IsRootShadowingAvailableFlag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemHairLength', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemHairLengthID], t.[HairSystemHairLengthSortOrder], t.[HairSystemHairLengthDescription], t.[HairSystemHairLengthDescriptionShort], t.[HairSystemHairLengthValue], t.[IsHumanHairAvailableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsAllowHumanGreyPercentageFlag], t.[IsAllowSyntheticGreyPercentageFlag], t.[IsAvailableForSignatureHairlineFlag], t.[IsAvailableForOmbreFlag], t.[IsLongHairAddOnFlag], t.[IsCuticleIntactAvailableFlag], t.[IsRootShadowingAvailableFlag]
	from [cdc].[dbo_lkpHairSystemHairLength_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemHairLength', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemHairLengthID], t.[HairSystemHairLengthSortOrder], t.[HairSystemHairLengthDescription], t.[HairSystemHairLengthDescriptionShort], t.[HairSystemHairLengthValue], t.[IsHumanHairAvailableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsAllowHumanGreyPercentageFlag], t.[IsAllowSyntheticGreyPercentageFlag], t.[IsAvailableForSignatureHairlineFlag], t.[IsAvailableForOmbreFlag], t.[IsLongHairAddOnFlag], t.[IsCuticleIntactAvailableFlag], t.[IsRootShadowingAvailableFlag]
	from [cdc].[dbo_lkpHairSystemHairLength_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemHairLength', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
