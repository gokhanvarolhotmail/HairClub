/* CreateDate: 05/05/2020 18:41:10.230 , ModifyDate: 05/05/2020 18:41:10.230 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_lkpEmployeePosition]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [EmployeePositionID], NULL as [EmployeePositionSortOrder], NULL as [EmployeePositionDescription], NULL as [EmployeePositionDescriptionShort], NULL as [ActiveDirectoryGroup], NULL as [IsAdministratorFlag], NULL as [CanScheduleFlag], NULL as [IsEmployeeOneFlag], NULL as [IsEmployeeTwoFlag], NULL as [IsEmployeeThreeFlag], NULL as [IsEmployeeFourFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [ApplicationTimeoutMinutes], NULL as [UseDefaultCenterFlag], NULL as [IsSurgeryCenterEmployeeFlag], NULL as [IsNonSurgeryCenterEmployeeFlag], NULL as [IsMeasurementsBy], NULL as [IsConsultant], NULL as [IsTechnician], NULL as [IsStylist], NULL as [IsConsultationSchedule], NULL as [IsMembershipConsultant], NULL as [IsMembershipStylist], NULL as [CanScheduleStylist], NULL as [IsMembershipTechnician], NULL as [CanAssignActivityTo], NULL as [EmployeePositionTrainingGroupID], NULL as [IsCommissionable]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_F32677B1
	    when 1 then __$operation
	    else
			case __$min_op_F32677B1
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		null as __$update_mask , [EmployeePositionID], [EmployeePositionSortOrder], [EmployeePositionDescription], [EmployeePositionDescriptionShort], [ActiveDirectoryGroup], [IsAdministratorFlag], [CanScheduleFlag], [IsEmployeeOneFlag], [IsEmployeeTwoFlag], [IsEmployeeThreeFlag], [IsEmployeeFourFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [ApplicationTimeoutMinutes], [UseDefaultCenterFlag], [IsSurgeryCenterEmployeeFlag], [IsNonSurgeryCenterEmployeeFlag], [IsMeasurementsBy], [IsConsultant], [IsTechnician], [IsStylist], [IsConsultationSchedule], [IsMembershipConsultant], [IsMembershipStylist], [CanScheduleStylist], [IsMembershipTechnician], [CanAssignActivityTo], [EmployeePositionTrainingGroupID], [IsCommissionable]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_F32677B1
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpEmployeePosition_CT] c with (nolock)
			where  ( (c.[EmployeePositionID] = t.[EmployeePositionID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_F32677B1, __$count_F32677B1, t.[EmployeePositionID], t.[EmployeePositionSortOrder], t.[EmployeePositionDescription], t.[EmployeePositionDescriptionShort], t.[ActiveDirectoryGroup], t.[IsAdministratorFlag], t.[CanScheduleFlag], t.[IsEmployeeOneFlag], t.[IsEmployeeTwoFlag], t.[IsEmployeeThreeFlag], t.[IsEmployeeFourFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ApplicationTimeoutMinutes], t.[UseDefaultCenterFlag], t.[IsSurgeryCenterEmployeeFlag], t.[IsNonSurgeryCenterEmployeeFlag], t.[IsMeasurementsBy], t.[IsConsultant], t.[IsTechnician], t.[IsStylist], t.[IsConsultationSchedule], t.[IsMembershipConsultant], t.[IsMembershipStylist], t.[CanScheduleStylist], t.[IsMembershipTechnician], t.[CanAssignActivityTo], t.[EmployeePositionTrainingGroupID], t.[IsCommissionable]
		from [cdc].[dbo_lkpEmployeePosition_CT] t with (nolock) inner join
		(	select  r.[EmployeePositionID], max(r.__$seqval) as __$max_seqval_F32677B1,
		    count(*) as __$count_F32677B1
			from [cdc].[dbo_lkpEmployeePosition_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeePositionID]) m
		on t.__$seqval = m.__$max_seqval_F32677B1 and
		    ( (t.[EmployeePositionID] = m.[EmployeePositionID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpEmployeePosition_CT] c with (nolock)
							where  ( (c.[EmployeePositionID] = t.[EmployeePositionID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

	select __$start_lsn,
	    case __$count_F32677B1
	    when 1 then __$operation
	    else
			case __$min_op_F32677B1
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		case __$count_F32677B1
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_F32677B1
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [EmployeePositionID], [EmployeePositionSortOrder], [EmployeePositionDescription], [EmployeePositionDescriptionShort], [ActiveDirectoryGroup], [IsAdministratorFlag], [CanScheduleFlag], [IsEmployeeOneFlag], [IsEmployeeTwoFlag], [IsEmployeeThreeFlag], [IsEmployeeFourFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [ApplicationTimeoutMinutes], [UseDefaultCenterFlag], [IsSurgeryCenterEmployeeFlag], [IsNonSurgeryCenterEmployeeFlag], [IsMeasurementsBy], [IsConsultant], [IsTechnician], [IsStylist], [IsConsultationSchedule], [IsMembershipConsultant], [IsMembershipStylist], [CanScheduleStylist], [IsMembershipTechnician], [CanAssignActivityTo], [EmployeePositionTrainingGroupID], [IsCommissionable]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_F32677B1
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_lkpEmployeePosition_CT] c with (nolock)
			where  ( (c.[EmployeePositionID] = t.[EmployeePositionID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_F32677B1, __$count_F32677B1,
		m.__$update_mask , t.[EmployeePositionID], t.[EmployeePositionSortOrder], t.[EmployeePositionDescription], t.[EmployeePositionDescriptionShort], t.[ActiveDirectoryGroup], t.[IsAdministratorFlag], t.[CanScheduleFlag], t.[IsEmployeeOneFlag], t.[IsEmployeeTwoFlag], t.[IsEmployeeThreeFlag], t.[IsEmployeeFourFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ApplicationTimeoutMinutes], t.[UseDefaultCenterFlag], t.[IsSurgeryCenterEmployeeFlag], t.[IsNonSurgeryCenterEmployeeFlag], t.[IsMeasurementsBy], t.[IsConsultant], t.[IsTechnician], t.[IsStylist], t.[IsConsultationSchedule], t.[IsMembershipConsultant], t.[IsMembershipStylist], t.[CanScheduleStylist], t.[IsMembershipTechnician], t.[CanAssignActivityTo], t.[EmployeePositionTrainingGroupID], t.[IsCommissionable]
		from [cdc].[dbo_lkpEmployeePosition_CT] t with (nolock) inner join
		(	select  r.[EmployeePositionID], max(r.__$seqval) as __$max_seqval_F32677B1,
		    count(*) as __$count_F32677B1,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_lkpEmployeePosition_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeePositionID]) m
		on t.__$seqval = m.__$max_seqval_F32677B1 and
		    ( (t.[EmployeePositionID] = m.[EmployeePositionID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpEmployeePosition_CT] c with (nolock)
							where  ( (c.[EmployeePositionID] = t.[EmployeePositionID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

		select t.__$start_lsn as __$start_lsn,
		case t.__$operation
			when 1 then 1
			else 5
		end as __$operation,
		null as __$update_mask , t.[EmployeePositionID], t.[EmployeePositionSortOrder], t.[EmployeePositionDescription], t.[EmployeePositionDescriptionShort], t.[ActiveDirectoryGroup], t.[IsAdministratorFlag], t.[CanScheduleFlag], t.[IsEmployeeOneFlag], t.[IsEmployeeTwoFlag], t.[IsEmployeeThreeFlag], t.[IsEmployeeFourFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ApplicationTimeoutMinutes], t.[UseDefaultCenterFlag], t.[IsSurgeryCenterEmployeeFlag], t.[IsNonSurgeryCenterEmployeeFlag], t.[IsMeasurementsBy], t.[IsConsultant], t.[IsTechnician], t.[IsStylist], t.[IsConsultationSchedule], t.[IsMembershipConsultant], t.[IsMembershipStylist], t.[CanScheduleStylist], t.[IsMembershipTechnician], t.[CanAssignActivityTo], t.[EmployeePositionTrainingGroupID], t.[IsCommissionable]
		from [cdc].[dbo_lkpEmployeePosition_CT] t  with (nolock) inner join
		(	select  r.[EmployeePositionID], max(r.__$seqval) as __$max_seqval_F32677B1
			from [cdc].[dbo_lkpEmployeePosition_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeePositionID]) m
		on t.__$seqval = m.__$max_seqval_F32677B1 and
		    ( (t.[EmployeePositionID] = m.[EmployeePositionID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_lkpEmployeePosition', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_lkpEmployeePosition_CT] c with (nolock)
							where  ( (c.[EmployeePositionID] = t.[EmployeePositionID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
