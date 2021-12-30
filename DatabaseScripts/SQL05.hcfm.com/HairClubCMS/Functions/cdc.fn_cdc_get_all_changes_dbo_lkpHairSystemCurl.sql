/* CreateDate: 05/05/2020 18:41:06.320 , ModifyDate: 05/05/2020 18:41:06.320 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_lkpHairSystemCurl]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HairSystemCurlID], NULL as [HairSystemCurlSortOrder], NULL as [HairSystemCurlDescription], NULL as [HairSystemCurlDescriptionShort], NULL as [HumanHairLengthMinimum], NULL as [HumanHairLengthMaximum], NULL as [SyntheticHairLengthMinimum], NULL as [SyntheticHairLengthMaximum], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsAllowHumanGreyPercentageFlag], NULL as [IsAllowSyntheticGreyPercentageFlag], NULL as [HairSystemCurlGroupID], NULL as [IsCuticleIntactAvailableFlag], NULL as [IsRootShadowingAvailableFlag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemCurl', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemCurlID], t.[HairSystemCurlSortOrder], t.[HairSystemCurlDescription], t.[HairSystemCurlDescriptionShort], t.[HumanHairLengthMinimum], t.[HumanHairLengthMaximum], t.[SyntheticHairLengthMinimum], t.[SyntheticHairLengthMaximum], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsAllowHumanGreyPercentageFlag], t.[IsAllowSyntheticGreyPercentageFlag], t.[HairSystemCurlGroupID], t.[IsCuticleIntactAvailableFlag], t.[IsRootShadowingAvailableFlag]
	from [cdc].[dbo_lkpHairSystemCurl_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemCurl', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemCurlID], t.[HairSystemCurlSortOrder], t.[HairSystemCurlDescription], t.[HairSystemCurlDescriptionShort], t.[HumanHairLengthMinimum], t.[HumanHairLengthMaximum], t.[SyntheticHairLengthMinimum], t.[SyntheticHairLengthMaximum], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsAllowHumanGreyPercentageFlag], t.[IsAllowSyntheticGreyPercentageFlag], t.[HairSystemCurlGroupID], t.[IsCuticleIntactAvailableFlag], t.[IsRootShadowingAvailableFlag]
	from [cdc].[dbo_lkpHairSystemCurl_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemCurl', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
