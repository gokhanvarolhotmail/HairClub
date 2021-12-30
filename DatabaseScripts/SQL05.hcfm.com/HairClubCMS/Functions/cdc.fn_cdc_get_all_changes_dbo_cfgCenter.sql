/* CreateDate: 05/05/2020 18:40:58.687 , ModifyDate: 05/05/2020 18:40:58.687 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cfgCenter]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CenterID], NULL as [CountryID], NULL as [RegionID], NULL as [CenterPayGroupID], NULL as [CenterDescription], NULL as [CenterTypeID], NULL as [CenterOwnershipID], NULL as [SurgeryHubCenterID], NULL as [ReportingCenterID], NULL as [AliasSurgeryCenterID], NULL as [EmployeeDoctorGUID], NULL as [DoctorRegionID], NULL as [TimeZoneID], NULL as [InvoiceCounter], NULL as [Address1], NULL as [Address2], NULL as [Address3], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [Phone1], NULL as [Phone2], NULL as [Phone3], NULL as [Phone1TypeID], NULL as [Phone2TypeID], NULL as [Phone3TypeID], NULL as [IsPhone1PrimaryFlag], NULL as [IsPhone2PrimaryFlag], NULL as [IsPhone3PrimaryFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsCorporateHeadquartersFlag], NULL as [RegionRSMNBConsultantGuid], NULL as [RegionRSMMembershipAdvisorGuid], NULL as [RegionRTMTechnicalManagerGuid], NULL as [CenterManagementAreaID], NULL as [CenterNumber], NULL as [BusinessUnitBrandID], NULL as [CenterDescriptionFullAlt1Calc], NULL as [CenterDescriptionFullCalc]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CenterID], t.[CountryID], t.[RegionID], t.[CenterPayGroupID], t.[CenterDescription], t.[CenterTypeID], t.[CenterOwnershipID], t.[SurgeryHubCenterID], t.[ReportingCenterID], t.[AliasSurgeryCenterID], t.[EmployeeDoctorGUID], t.[DoctorRegionID], t.[TimeZoneID], t.[InvoiceCounter], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsCorporateHeadquartersFlag], t.[RegionRSMNBConsultantGuid], t.[RegionRSMMembershipAdvisorGuid], t.[RegionRTMTechnicalManagerGuid], t.[CenterManagementAreaID], t.[CenterNumber], t.[BusinessUnitBrandID], t.[CenterDescriptionFullAlt1Calc], t.[CenterDescriptionFullCalc]
	from [cdc].[dbo_cfgCenter_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[CenterID], t.[CountryID], t.[RegionID], t.[CenterPayGroupID], t.[CenterDescription], t.[CenterTypeID], t.[CenterOwnershipID], t.[SurgeryHubCenterID], t.[ReportingCenterID], t.[AliasSurgeryCenterID], t.[EmployeeDoctorGUID], t.[DoctorRegionID], t.[TimeZoneID], t.[InvoiceCounter], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsCorporateHeadquartersFlag], t.[RegionRSMNBConsultantGuid], t.[RegionRSMMembershipAdvisorGuid], t.[RegionRTMTechnicalManagerGuid], t.[CenterManagementAreaID], t.[CenterNumber], t.[BusinessUnitBrandID], t.[CenterDescriptionFullAlt1Calc], t.[CenterDescriptionFullCalc]
	from [cdc].[dbo_cfgCenter_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
