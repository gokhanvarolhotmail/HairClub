/* CreateDate: 05/05/2020 18:41:10.410 , ModifyDate: 05/05/2020 18:41:10.410 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_lkpSecurityElement]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SecurityElementID], NULL as [SecurityElementSortOrder], NULL as [SecurityElementDescription], NULL as [SecurityElementDescriptionShort], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [SecurityElementDescriptionFull], NULL as [IsTabletElement]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSecurityElement', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SecurityElementID], t.[SecurityElementSortOrder], t.[SecurityElementDescription], t.[SecurityElementDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[SecurityElementDescriptionFull], t.[IsTabletElement]
	from [cdc].[dbo_lkpSecurityElement_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSecurityElement', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SecurityElementID], t.[SecurityElementSortOrder], t.[SecurityElementDescription], t.[SecurityElementDescriptionShort], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[SecurityElementDescriptionFull], t.[IsTabletElement]
	from [cdc].[dbo_lkpSecurityElement_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpSecurityElement', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
