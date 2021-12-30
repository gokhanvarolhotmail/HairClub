/* CreateDate: 05/05/2020 18:41:00.440 , ModifyDate: 05/05/2020 18:41:00.440 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datEmployee]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [EmployeeGUID], NULL as [CenterID], NULL as [TrainingExerciseID], NULL as [ResourceID], NULL as [SalutationID], NULL as [FirstName], NULL as [LastName], NULL as [EmployeeInitials], NULL as [UserLogin], NULL as [Address1], NULL as [Address2], NULL as [Address3], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [PhoneMain], NULL as [PhoneAlternate], NULL as [EmergencyContact], NULL as [PayrollNumber], NULL as [TimeClockNumber], NULL as [LastLogin], NULL as [IsSchedulerViewOnlyFlag], NULL as [EmployeeFullNameCalc], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [AbbreviatedNameCalc], NULL as [ActiveDirectorySID], NULL as [EmployeePayrollID], NULL as [EmployeeTitleID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datEmployee', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_55350B5F
	    when 1 then __$operation
	    else
			case __$min_op_55350B5F
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
		null as __$update_mask , [EmployeeGUID], [CenterID], [TrainingExerciseID], [ResourceID], [SalutationID], [FirstName], [LastName], [EmployeeInitials], [UserLogin], [Address1], [Address2], [Address3], [City], [StateID], [PostalCode], [PhoneMain], [PhoneAlternate], [EmergencyContact], [PayrollNumber], [TimeClockNumber], [LastLogin], [IsSchedulerViewOnlyFlag], [EmployeeFullNameCalc], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [AbbreviatedNameCalc], [ActiveDirectorySID], [EmployeePayrollID], [EmployeeTitleID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_55350B5F
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datEmployee_CT] c with (nolock)
			where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_55350B5F, __$count_55350B5F, t.[EmployeeGUID], t.[CenterID], t.[TrainingExerciseID], t.[ResourceID], t.[SalutationID], t.[FirstName], t.[LastName], t.[EmployeeInitials], t.[UserLogin], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[PhoneMain], t.[PhoneAlternate], t.[EmergencyContact], t.[PayrollNumber], t.[TimeClockNumber], t.[LastLogin], t.[IsSchedulerViewOnlyFlag], t.[EmployeeFullNameCalc], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AbbreviatedNameCalc], t.[ActiveDirectorySID], t.[EmployeePayrollID], t.[EmployeeTitleID]
		from [cdc].[dbo_datEmployee_CT] t with (nolock) inner join
		(	select  r.[EmployeeGUID], max(r.__$seqval) as __$max_seqval_55350B5F,
		    count(*) as __$count_55350B5F
			from [cdc].[dbo_datEmployee_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeeGUID]) m
		on t.__$seqval = m.__$max_seqval_55350B5F and
		    ( (t.[EmployeeGUID] = m.[EmployeeGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datEmployee', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datEmployee_CT] c with (nolock)
							where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) )
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
	    case __$count_55350B5F
	    when 1 then __$operation
	    else
			case __$min_op_55350B5F
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
		case __$count_55350B5F
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_55350B5F
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [EmployeeGUID], [CenterID], [TrainingExerciseID], [ResourceID], [SalutationID], [FirstName], [LastName], [EmployeeInitials], [UserLogin], [Address1], [Address2], [Address3], [City], [StateID], [PostalCode], [PhoneMain], [PhoneAlternate], [EmergencyContact], [PayrollNumber], [TimeClockNumber], [LastLogin], [IsSchedulerViewOnlyFlag], [EmployeeFullNameCalc], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [AbbreviatedNameCalc], [ActiveDirectorySID], [EmployeePayrollID], [EmployeeTitleID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_55350B5F
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datEmployee_CT] c with (nolock)
			where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_55350B5F, __$count_55350B5F,
		m.__$update_mask , t.[EmployeeGUID], t.[CenterID], t.[TrainingExerciseID], t.[ResourceID], t.[SalutationID], t.[FirstName], t.[LastName], t.[EmployeeInitials], t.[UserLogin], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[PhoneMain], t.[PhoneAlternate], t.[EmergencyContact], t.[PayrollNumber], t.[TimeClockNumber], t.[LastLogin], t.[IsSchedulerViewOnlyFlag], t.[EmployeeFullNameCalc], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AbbreviatedNameCalc], t.[ActiveDirectorySID], t.[EmployeePayrollID], t.[EmployeeTitleID]
		from [cdc].[dbo_datEmployee_CT] t with (nolock) inner join
		(	select  r.[EmployeeGUID], max(r.__$seqval) as __$max_seqval_55350B5F,
		    count(*) as __$count_55350B5F,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datEmployee_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeeGUID]) m
		on t.__$seqval = m.__$max_seqval_55350B5F and
		    ( (t.[EmployeeGUID] = m.[EmployeeGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datEmployee', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datEmployee_CT] c with (nolock)
							where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) )
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
		null as __$update_mask , t.[EmployeeGUID], t.[CenterID], t.[TrainingExerciseID], t.[ResourceID], t.[SalutationID], t.[FirstName], t.[LastName], t.[EmployeeInitials], t.[UserLogin], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[PhoneMain], t.[PhoneAlternate], t.[EmergencyContact], t.[PayrollNumber], t.[TimeClockNumber], t.[LastLogin], t.[IsSchedulerViewOnlyFlag], t.[EmployeeFullNameCalc], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AbbreviatedNameCalc], t.[ActiveDirectorySID], t.[EmployeePayrollID], t.[EmployeeTitleID]
		from [cdc].[dbo_datEmployee_CT] t  with (nolock) inner join
		(	select  r.[EmployeeGUID], max(r.__$seqval) as __$max_seqval_55350B5F
			from [cdc].[dbo_datEmployee_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[EmployeeGUID]) m
		on t.__$seqval = m.__$max_seqval_55350B5F and
		    ( (t.[EmployeeGUID] = m.[EmployeeGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datEmployee', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datEmployee_CT] c with (nolock)
							where  ( (c.[EmployeeGUID] = t.[EmployeeGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
