/* CreateDate: 05/05/2020 18:40:58.693 , ModifyDate: 05/05/2020 18:40:58.693 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cfgCenter]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [CenterID], NULL as [CountryID], NULL as [RegionID], NULL as [CenterPayGroupID], NULL as [CenterDescription], NULL as [CenterTypeID], NULL as [CenterOwnershipID], NULL as [SurgeryHubCenterID], NULL as [ReportingCenterID], NULL as [AliasSurgeryCenterID], NULL as [EmployeeDoctorGUID], NULL as [DoctorRegionID], NULL as [TimeZoneID], NULL as [InvoiceCounter], NULL as [Address1], NULL as [Address2], NULL as [Address3], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [Phone1], NULL as [Phone2], NULL as [Phone3], NULL as [Phone1TypeID], NULL as [Phone2TypeID], NULL as [Phone3TypeID], NULL as [IsPhone1PrimaryFlag], NULL as [IsPhone2PrimaryFlag], NULL as [IsPhone3PrimaryFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsCorporateHeadquartersFlag], NULL as [RegionRSMNBConsultantGuid], NULL as [RegionRSMMembershipAdvisorGuid], NULL as [RegionRTMTechnicalManagerGuid], NULL as [CenterManagementAreaID], NULL as [CenterNumber], NULL as [BusinessUnitBrandID], NULL as [CenterDescriptionFullAlt1Calc], NULL as [CenterDescriptionFullCalc]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_8070B147
	    when 1 then __$operation
	    else
			case __$min_op_8070B147
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
		null as __$update_mask , [CenterID], [CountryID], [RegionID], [CenterPayGroupID], [CenterDescription], [CenterTypeID], [CenterOwnershipID], [SurgeryHubCenterID], [ReportingCenterID], [AliasSurgeryCenterID], [EmployeeDoctorGUID], [DoctorRegionID], [TimeZoneID], [InvoiceCounter], [Address1], [Address2], [Address3], [City], [StateID], [PostalCode], [Phone1], [Phone2], [Phone3], [Phone1TypeID], [Phone2TypeID], [Phone3TypeID], [IsPhone1PrimaryFlag], [IsPhone2PrimaryFlag], [IsPhone3PrimaryFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsCorporateHeadquartersFlag], [RegionRSMNBConsultantGuid], [RegionRSMMembershipAdvisorGuid], [RegionRTMTechnicalManagerGuid], [CenterManagementAreaID], [CenterNumber], [BusinessUnitBrandID], [CenterDescriptionFullAlt1Calc], [CenterDescriptionFullCalc]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_8070B147
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgCenter_CT] c with (nolock)
			where  ( (c.[CenterID] = t.[CenterID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_8070B147, __$count_8070B147, t.[CenterID], t.[CountryID], t.[RegionID], t.[CenterPayGroupID], t.[CenterDescription], t.[CenterTypeID], t.[CenterOwnershipID], t.[SurgeryHubCenterID], t.[ReportingCenterID], t.[AliasSurgeryCenterID], t.[EmployeeDoctorGUID], t.[DoctorRegionID], t.[TimeZoneID], t.[InvoiceCounter], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsCorporateHeadquartersFlag], t.[RegionRSMNBConsultantGuid], t.[RegionRSMMembershipAdvisorGuid], t.[RegionRTMTechnicalManagerGuid], t.[CenterManagementAreaID], t.[CenterNumber], t.[BusinessUnitBrandID], t.[CenterDescriptionFullAlt1Calc], t.[CenterDescriptionFullCalc]
		from [cdc].[dbo_cfgCenter_CT] t with (nolock) inner join
		(	select  r.[CenterID], max(r.__$seqval) as __$max_seqval_8070B147,
		    count(*) as __$count_8070B147
			from [cdc].[dbo_cfgCenter_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CenterID]) m
		on t.__$seqval = m.__$max_seqval_8070B147 and
		    ( (t.[CenterID] = m.[CenterID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgCenter_CT] c with (nolock)
							where  ( (c.[CenterID] = t.[CenterID]) )
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
	    case __$count_8070B147
	    when 1 then __$operation
	    else
			case __$min_op_8070B147
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
		case __$count_8070B147
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_8070B147
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [CenterID], [CountryID], [RegionID], [CenterPayGroupID], [CenterDescription], [CenterTypeID], [CenterOwnershipID], [SurgeryHubCenterID], [ReportingCenterID], [AliasSurgeryCenterID], [EmployeeDoctorGUID], [DoctorRegionID], [TimeZoneID], [InvoiceCounter], [Address1], [Address2], [Address3], [City], [StateID], [PostalCode], [Phone1], [Phone2], [Phone3], [Phone1TypeID], [Phone2TypeID], [Phone3TypeID], [IsPhone1PrimaryFlag], [IsPhone2PrimaryFlag], [IsPhone3PrimaryFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsCorporateHeadquartersFlag], [RegionRSMNBConsultantGuid], [RegionRSMMembershipAdvisorGuid], [RegionRTMTechnicalManagerGuid], [CenterManagementAreaID], [CenterNumber], [BusinessUnitBrandID], [CenterDescriptionFullAlt1Calc], [CenterDescriptionFullCalc]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_8070B147
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgCenter_CT] c with (nolock)
			where  ( (c.[CenterID] = t.[CenterID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_8070B147, __$count_8070B147,
		m.__$update_mask , t.[CenterID], t.[CountryID], t.[RegionID], t.[CenterPayGroupID], t.[CenterDescription], t.[CenterTypeID], t.[CenterOwnershipID], t.[SurgeryHubCenterID], t.[ReportingCenterID], t.[AliasSurgeryCenterID], t.[EmployeeDoctorGUID], t.[DoctorRegionID], t.[TimeZoneID], t.[InvoiceCounter], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsCorporateHeadquartersFlag], t.[RegionRSMNBConsultantGuid], t.[RegionRSMMembershipAdvisorGuid], t.[RegionRTMTechnicalManagerGuid], t.[CenterManagementAreaID], t.[CenterNumber], t.[BusinessUnitBrandID], t.[CenterDescriptionFullAlt1Calc], t.[CenterDescriptionFullCalc]
		from [cdc].[dbo_cfgCenter_CT] t with (nolock) inner join
		(	select  r.[CenterID], max(r.__$seqval) as __$max_seqval_8070B147,
		    count(*) as __$count_8070B147,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cfgCenter_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CenterID]) m
		on t.__$seqval = m.__$max_seqval_8070B147 and
		    ( (t.[CenterID] = m.[CenterID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgCenter_CT] c with (nolock)
							where  ( (c.[CenterID] = t.[CenterID]) )
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
		null as __$update_mask , t.[CenterID], t.[CountryID], t.[RegionID], t.[CenterPayGroupID], t.[CenterDescription], t.[CenterTypeID], t.[CenterOwnershipID], t.[SurgeryHubCenterID], t.[ReportingCenterID], t.[AliasSurgeryCenterID], t.[EmployeeDoctorGUID], t.[DoctorRegionID], t.[TimeZoneID], t.[InvoiceCounter], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsCorporateHeadquartersFlag], t.[RegionRSMNBConsultantGuid], t.[RegionRSMMembershipAdvisorGuid], t.[RegionRTMTechnicalManagerGuid], t.[CenterManagementAreaID], t.[CenterNumber], t.[BusinessUnitBrandID], t.[CenterDescriptionFullAlt1Calc], t.[CenterDescriptionFullCalc]
		from [cdc].[dbo_cfgCenter_CT] t  with (nolock) inner join
		(	select  r.[CenterID], max(r.__$seqval) as __$max_seqval_8070B147
			from [cdc].[dbo_cfgCenter_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[CenterID]) m
		on t.__$seqval = m.__$max_seqval_8070B147 and
		    ( (t.[CenterID] = m.[CenterID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgCenter', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgCenter_CT] c with (nolock)
							where  ( (c.[CenterID] = t.[CenterID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
