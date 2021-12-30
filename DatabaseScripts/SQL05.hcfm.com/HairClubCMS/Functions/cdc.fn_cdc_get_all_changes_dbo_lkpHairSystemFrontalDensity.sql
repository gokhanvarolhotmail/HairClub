/* CreateDate: 05/05/2020 18:41:05.117 , ModifyDate: 05/05/2020 18:41:05.117 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_lkpHairSystemFrontalDensity]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HairSystemFrontalDensityID], NULL as [HairSystemFrontalDensitySortOrder], NULL as [HairSystemFrontalDensityDescription], NULL as [HairSystemFrontalDensityDescriptionShort], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsAvailableForSignatureHairlineFlag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemFrontalDensity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemFrontalDensityID], t.[HairSystemFrontalDensitySortOrder], t.[HairSystemFrontalDensityDescription], t.[HairSystemFrontalDensityDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsAvailableForSignatureHairlineFlag]
	from [cdc].[dbo_lkpHairSystemFrontalDensity_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemFrontalDensity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemFrontalDensityID], t.[HairSystemFrontalDensitySortOrder], t.[HairSystemFrontalDensityDescription], t.[HairSystemFrontalDensityDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsAvailableForSignatureHairlineFlag]
	from [cdc].[dbo_lkpHairSystemFrontalDensity_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpHairSystemFrontalDensity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
