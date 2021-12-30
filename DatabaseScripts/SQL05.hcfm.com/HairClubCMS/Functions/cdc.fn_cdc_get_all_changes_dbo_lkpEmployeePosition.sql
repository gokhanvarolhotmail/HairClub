/* CreateDate: 05/05/2020 18:41:10.223 , ModifyDate: 05/05/2020 18:41:10.223 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_lkpEmployeePosition]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [EmployeePositionID], NULL as [EmployeePositionSortOrder], NULL as [EmployeePositionDescription], NULL as [EmployeePositionDescriptionShort], NULL as [ActiveDirectoryGroup], NULL as [IsAdministratorFlag], NULL as [CanScheduleFlag], NULL as [IsEmployeeOneFlag], NULL as [IsEmployeeTwoFlag], NULL as [IsEmployeeThreeFlag], NULL as [IsEmployeeFourFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [ApplicationTimeoutMinutes], NULL as [UseDefaultCenterFlag], NULL as [IsSurgeryCenterEmployeeFlag], NULL as [IsNonSurgeryCenterEmployeeFlag], NULL as [IsMeasurementsBy], NULL as [IsConsultant], NULL as [IsTechnician], NULL as [IsStylist], NULL as [IsConsultationSchedule], NULL as [IsMembershipConsultant], NULL as [IsMembershipStylist], NULL as [CanScheduleStylist], NULL as [IsMembershipTechnician], NULL as [CanAssignActivityTo], NULL as [EmployeePositionTrainingGroupID], NULL as [IsCommissionable]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[EmployeePositionID], t.[EmployeePositionSortOrder], t.[EmployeePositionDescription], t.[EmployeePositionDescriptionShort], t.[ActiveDirectoryGroup], t.[IsAdministratorFlag], t.[CanScheduleFlag], t.[IsEmployeeOneFlag], t.[IsEmployeeTwoFlag], t.[IsEmployeeThreeFlag], t.[IsEmployeeFourFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ApplicationTimeoutMinutes], t.[UseDefaultCenterFlag], t.[IsSurgeryCenterEmployeeFlag], t.[IsNonSurgeryCenterEmployeeFlag], t.[IsMeasurementsBy], t.[IsConsultant], t.[IsTechnician], t.[IsStylist], t.[IsConsultationSchedule], t.[IsMembershipConsultant], t.[IsMembershipStylist], t.[CanScheduleStylist], t.[IsMembershipTechnician], t.[CanAssignActivityTo], t.[EmployeePositionTrainingGroupID], t.[IsCommissionable]
	from [cdc].[dbo_lkpEmployeePosition_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[EmployeePositionID], t.[EmployeePositionSortOrder], t.[EmployeePositionDescription], t.[EmployeePositionDescriptionShort], t.[ActiveDirectoryGroup], t.[IsAdministratorFlag], t.[CanScheduleFlag], t.[IsEmployeeOneFlag], t.[IsEmployeeTwoFlag], t.[IsEmployeeThreeFlag], t.[IsEmployeeFourFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ApplicationTimeoutMinutes], t.[UseDefaultCenterFlag], t.[IsSurgeryCenterEmployeeFlag], t.[IsNonSurgeryCenterEmployeeFlag], t.[IsMeasurementsBy], t.[IsConsultant], t.[IsTechnician], t.[IsStylist], t.[IsConsultationSchedule], t.[IsMembershipConsultant], t.[IsMembershipStylist], t.[CanScheduleStylist], t.[IsMembershipTechnician], t.[CanAssignActivityTo], t.[EmployeePositionTrainingGroupID], t.[IsCommissionable]
	from [cdc].[dbo_lkpEmployeePosition_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
