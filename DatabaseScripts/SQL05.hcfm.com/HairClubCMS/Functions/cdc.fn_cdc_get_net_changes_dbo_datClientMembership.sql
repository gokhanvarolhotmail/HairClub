/* CreateDate: 05/05/2020 18:40:59.837 , ModifyDate: 05/05/2020 18:40:59.837 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datClientMembership]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ClientMembershipGUID], NULL as [Member1_ID_Temp], NULL as [ClientGUID], NULL as [CenterID], NULL as [MembershipID], NULL as [ClientMembershipStatusID], NULL as [ContractPrice], NULL as [ContractPaidAmount], NULL as [MonthlyFee], NULL as [BeginDate], NULL as [EndDate], NULL as [MembershipCancelReasonID], NULL as [CancelDate], NULL as [IsGuaranteeFlag], NULL as [IsRenewalFlag], NULL as [IsMultipleSurgeryFlag], NULL as [RenewalCount], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [ClientMembershipIdentifier], NULL as [MembershipCancelReasonDescription], NULL as [HasInHousePaymentPlan], NULL as [NationalMonthlyFee], NULL as [MembershipProfileTypeID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_E30A72A6
	    when 1 then __$operation
	    else
			case __$min_op_E30A72A6
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
		null as __$update_mask , [ClientMembershipGUID], [Member1_ID_Temp], [ClientGUID], [CenterID], [MembershipID], [ClientMembershipStatusID], [ContractPrice], [ContractPaidAmount], [MonthlyFee], [BeginDate], [EndDate], [MembershipCancelReasonID], [CancelDate], [IsGuaranteeFlag], [IsRenewalFlag], [IsMultipleSurgeryFlag], [RenewalCount], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [ClientMembershipIdentifier], [MembershipCancelReasonDescription], [HasInHousePaymentPlan], [NationalMonthlyFee], [MembershipProfileTypeID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_E30A72A6
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datClientMembership_CT] c with (nolock)
			where  ( (c.[ClientMembershipGUID] = t.[ClientMembershipGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_E30A72A6, __$count_E30A72A6, t.[ClientMembershipGUID], t.[Member1_ID_Temp], t.[ClientGUID], t.[CenterID], t.[MembershipID], t.[ClientMembershipStatusID], t.[ContractPrice], t.[ContractPaidAmount], t.[MonthlyFee], t.[BeginDate], t.[EndDate], t.[MembershipCancelReasonID], t.[CancelDate], t.[IsGuaranteeFlag], t.[IsRenewalFlag], t.[IsMultipleSurgeryFlag], t.[RenewalCount], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipIdentifier], t.[MembershipCancelReasonDescription], t.[HasInHousePaymentPlan], t.[NationalMonthlyFee], t.[MembershipProfileTypeID]
		from [cdc].[dbo_datClientMembership_CT] t with (nolock) inner join
		(	select  r.[ClientMembershipGUID], max(r.__$seqval) as __$max_seqval_E30A72A6,
		    count(*) as __$count_E30A72A6
			from [cdc].[dbo_datClientMembership_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ClientMembershipGUID]) m
		on t.__$seqval = m.__$max_seqval_E30A72A6 and
		    ( (t.[ClientMembershipGUID] = m.[ClientMembershipGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datClientMembership_CT] c with (nolock)
							where  ( (c.[ClientMembershipGUID] = t.[ClientMembershipGUID]) )
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
	    case __$count_E30A72A6
	    when 1 then __$operation
	    else
			case __$min_op_E30A72A6
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
		case __$count_E30A72A6
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_E30A72A6
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [ClientMembershipGUID], [Member1_ID_Temp], [ClientGUID], [CenterID], [MembershipID], [ClientMembershipStatusID], [ContractPrice], [ContractPaidAmount], [MonthlyFee], [BeginDate], [EndDate], [MembershipCancelReasonID], [CancelDate], [IsGuaranteeFlag], [IsRenewalFlag], [IsMultipleSurgeryFlag], [RenewalCount], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [ClientMembershipIdentifier], [MembershipCancelReasonDescription], [HasInHousePaymentPlan], [NationalMonthlyFee], [MembershipProfileTypeID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_E30A72A6
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datClientMembership_CT] c with (nolock)
			where  ( (c.[ClientMembershipGUID] = t.[ClientMembershipGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_E30A72A6, __$count_E30A72A6,
		m.__$update_mask , t.[ClientMembershipGUID], t.[Member1_ID_Temp], t.[ClientGUID], t.[CenterID], t.[MembershipID], t.[ClientMembershipStatusID], t.[ContractPrice], t.[ContractPaidAmount], t.[MonthlyFee], t.[BeginDate], t.[EndDate], t.[MembershipCancelReasonID], t.[CancelDate], t.[IsGuaranteeFlag], t.[IsRenewalFlag], t.[IsMultipleSurgeryFlag], t.[RenewalCount], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipIdentifier], t.[MembershipCancelReasonDescription], t.[HasInHousePaymentPlan], t.[NationalMonthlyFee], t.[MembershipProfileTypeID]
		from [cdc].[dbo_datClientMembership_CT] t with (nolock) inner join
		(	select  r.[ClientMembershipGUID], max(r.__$seqval) as __$max_seqval_E30A72A6,
		    count(*) as __$count_E30A72A6,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datClientMembership_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ClientMembershipGUID]) m
		on t.__$seqval = m.__$max_seqval_E30A72A6 and
		    ( (t.[ClientMembershipGUID] = m.[ClientMembershipGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datClientMembership_CT] c with (nolock)
							where  ( (c.[ClientMembershipGUID] = t.[ClientMembershipGUID]) )
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
		null as __$update_mask , t.[ClientMembershipGUID], t.[Member1_ID_Temp], t.[ClientGUID], t.[CenterID], t.[MembershipID], t.[ClientMembershipStatusID], t.[ContractPrice], t.[ContractPaidAmount], t.[MonthlyFee], t.[BeginDate], t.[EndDate], t.[MembershipCancelReasonID], t.[CancelDate], t.[IsGuaranteeFlag], t.[IsRenewalFlag], t.[IsMultipleSurgeryFlag], t.[RenewalCount], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ClientMembershipIdentifier], t.[MembershipCancelReasonDescription], t.[HasInHousePaymentPlan], t.[NationalMonthlyFee], t.[MembershipProfileTypeID]
		from [cdc].[dbo_datClientMembership_CT] t  with (nolock) inner join
		(	select  r.[ClientMembershipGUID], max(r.__$seqval) as __$max_seqval_E30A72A6
			from [cdc].[dbo_datClientMembership_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ClientMembershipGUID]) m
		on t.__$seqval = m.__$max_seqval_E30A72A6 and
		    ( (t.[ClientMembershipGUID] = m.[ClientMembershipGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClientMembership', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datClientMembership_CT] c with (nolock)
							where  ( (c.[ClientMembershipGUID] = t.[ClientMembershipGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
