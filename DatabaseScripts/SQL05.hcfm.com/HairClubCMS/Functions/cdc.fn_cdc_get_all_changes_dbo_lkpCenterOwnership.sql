/* CreateDate: 05/05/2020 18:41:01.950 , ModifyDate: 05/05/2020 18:41:01.950 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_lkpCenterOwnership]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CenterOwnershipID], NULL as [CenterOwnershipSortOrder], NULL as [CenterOwnershipDescription], NULL as [CenterOwnershipDescriptionShort], NULL as [OwnerLastName], NULL as [OwnerFirstName], NULL as [CorporateName], NULL as [Address1], NULL as [Address2], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [CountryID], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [IsClientExperienceSurveyEnabled], NULL as [ClientExperienceSurveyDelayDays]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpCenterOwnership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CenterOwnershipID], t.[CenterOwnershipSortOrder], t.[CenterOwnershipDescription], t.[CenterOwnershipDescriptionShort], t.[OwnerLastName], t.[OwnerFirstName], t.[CorporateName], t.[Address1], t.[Address2], t.[City], t.[StateID], t.[PostalCode], t.[CountryID], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[IsClientExperienceSurveyEnabled], t.[ClientExperienceSurveyDelayDays]
	from [cdc].[dbo_lkpCenterOwnership_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpCenterOwnership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CenterOwnershipID], t.[CenterOwnershipSortOrder], t.[CenterOwnershipDescription], t.[CenterOwnershipDescriptionShort], t.[OwnerLastName], t.[OwnerFirstName], t.[CorporateName], t.[Address1], t.[Address2], t.[City], t.[StateID], t.[PostalCode], t.[CountryID], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[IsClientExperienceSurveyEnabled], t.[ClientExperienceSurveyDelayDays]
	from [cdc].[dbo_lkpCenterOwnership_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpCenterOwnership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
