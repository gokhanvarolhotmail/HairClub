/* CreateDate: 05/05/2020 18:41:00.150 , ModifyDate: 05/05/2020 18:41:00.150 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datClientAddress]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ClientAddressGUID], NULL as [ClientAddressTypeID], NULL as [ClientGUID], NULL as [CountryID], NULL as [Address1], NULL as [Address2], NULL as [Address3], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientAddress', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientAddressGUID], t.[ClientAddressTypeID], t.[ClientGUID], t.[CountryID], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
	from [cdc].[dbo_datClientAddress_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientAddress', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientAddressGUID], t.[ClientAddressTypeID], t.[ClientGUID], t.[CountryID], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp]
	from [cdc].[dbo_datClientAddress_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientAddress', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
