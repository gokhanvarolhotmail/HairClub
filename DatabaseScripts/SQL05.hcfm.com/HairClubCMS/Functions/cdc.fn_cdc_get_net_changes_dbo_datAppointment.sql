/* CreateDate: 05/05/2020 18:41:08.043 , ModifyDate: 05/05/2020 18:41:08.043 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datAppointment]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [AppointmentGUID], NULL as [AppointmentID_Temp], NULL as [ClientGUID], NULL as [ClientMembershipGUID], NULL as [ParentAppointmentGUID], NULL as [CenterID], NULL as [ClientHomeCenterID], NULL as [ResourceID], NULL as [ConfirmationTypeID], NULL as [AppointmentTypeID], NULL as [AppointmentDate], NULL as [StartTime], NULL as [EndTime], NULL as [CheckinTime], NULL as [CheckoutTime], NULL as [AppointmentSubject], NULL as [CanPrintCommentFlag], NULL as [IsNonAppointmentFlag], NULL as [RecurrenceRule], NULL as [StartDateTimeCalc], NULL as [EndDateTimeCalc], NULL as [AppointmentDurationCalc], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [AppointmentStatusID], NULL as [IsDeletedFlag], NULL as [OnContactActivityID], NULL as [OnContactContactID], NULL as [CheckedInFlag], NULL as [IsAuthorizedFlag], NULL as [LastChangeUser], NULL as [LastChangeDate], NULL as [ScalpHealthID], NULL as [AppointmentPriorityColorID], NULL as [CompletedVisitTypeID], NULL as [IsFullTrichoView], NULL as [SalesforceContactID], NULL as [SalesforceTaskID], NULL as [KorvueID], NULL as [ServiceStartTime], NULL as [ServiceEndTime], NULL as [IsClientContactInformationConfirmed]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_CF70F18F
	    when 1 then __$operation
	    else
			case __$min_op_CF70F18F
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
		null as __$update_mask , [AppointmentGUID], [AppointmentID_Temp], [ClientGUID], [ClientMembershipGUID], [ParentAppointmentGUID], [CenterID], [ClientHomeCenterID], [ResourceID], [ConfirmationTypeID], [AppointmentTypeID], [AppointmentDate], [StartTime], [EndTime], [CheckinTime], [CheckoutTime], [AppointmentSubject], [CanPrintCommentFlag], [IsNonAppointmentFlag], [RecurrenceRule], [StartDateTimeCalc], [EndDateTimeCalc], [AppointmentDurationCalc], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [AppointmentStatusID], [IsDeletedFlag], [OnContactActivityID], [OnContactContactID], [CheckedInFlag], [IsAuthorizedFlag], [LastChangeUser], [LastChangeDate], [ScalpHealthID], [AppointmentPriorityColorID], [CompletedVisitTypeID], [IsFullTrichoView], [SalesforceContactID], [SalesforceTaskID], [KorvueID], [ServiceStartTime], [ServiceEndTime], [IsClientContactInformationConfirmed]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CF70F18F
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datAppointment_CT] c with (nolock)
			where  ( (c.[AppointmentGUID] = t.[AppointmentGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CF70F18F, __$count_CF70F18F, t.[AppointmentGUID], t.[AppointmentID_Temp], t.[ClientGUID], t.[ClientMembershipGUID], t.[ParentAppointmentGUID], t.[CenterID], t.[ClientHomeCenterID], t.[ResourceID], t.[ConfirmationTypeID], t.[AppointmentTypeID], t.[AppointmentDate], t.[StartTime], t.[EndTime], t.[CheckinTime], t.[CheckoutTime], t.[AppointmentSubject], t.[CanPrintCommentFlag], t.[IsNonAppointmentFlag], t.[RecurrenceRule], t.[StartDateTimeCalc], t.[EndDateTimeCalc], t.[AppointmentDurationCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AppointmentStatusID], t.[IsDeletedFlag], t.[OnContactActivityID], t.[OnContactContactID], t.[CheckedInFlag], t.[IsAuthorizedFlag], t.[LastChangeUser], t.[LastChangeDate], t.[ScalpHealthID], t.[AppointmentPriorityColorID], t.[CompletedVisitTypeID], t.[IsFullTrichoView], t.[SalesforceContactID], t.[SalesforceTaskID], t.[KorvueID], t.[ServiceStartTime], t.[ServiceEndTime], t.[IsClientContactInformationConfirmed]
		from [cdc].[dbo_datAppointment_CT] t with (nolock) inner join
		(	select  r.[AppointmentGUID], max(r.__$seqval) as __$max_seqval_CF70F18F,
		    count(*) as __$count_CF70F18F
			from [cdc].[dbo_datAppointment_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AppointmentGUID]) m
		on t.__$seqval = m.__$max_seqval_CF70F18F and
		    ( (t.[AppointmentGUID] = m.[AppointmentGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datAppointment_CT] c with (nolock)
							where  ( (c.[AppointmentGUID] = t.[AppointmentGUID]) )
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
	    case __$count_CF70F18F
	    when 1 then __$operation
	    else
			case __$min_op_CF70F18F
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
		case __$count_CF70F18F
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_CF70F18F
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [AppointmentGUID], [AppointmentID_Temp], [ClientGUID], [ClientMembershipGUID], [ParentAppointmentGUID], [CenterID], [ClientHomeCenterID], [ResourceID], [ConfirmationTypeID], [AppointmentTypeID], [AppointmentDate], [StartTime], [EndTime], [CheckinTime], [CheckoutTime], [AppointmentSubject], [CanPrintCommentFlag], [IsNonAppointmentFlag], [RecurrenceRule], [StartDateTimeCalc], [EndDateTimeCalc], [AppointmentDurationCalc], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [AppointmentStatusID], [IsDeletedFlag], [OnContactActivityID], [OnContactContactID], [CheckedInFlag], [IsAuthorizedFlag], [LastChangeUser], [LastChangeDate], [ScalpHealthID], [AppointmentPriorityColorID], [CompletedVisitTypeID], [IsFullTrichoView], [SalesforceContactID], [SalesforceTaskID], [KorvueID], [ServiceStartTime], [ServiceEndTime], [IsClientContactInformationConfirmed]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CF70F18F
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datAppointment_CT] c with (nolock)
			where  ( (c.[AppointmentGUID] = t.[AppointmentGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CF70F18F, __$count_CF70F18F,
		m.__$update_mask , t.[AppointmentGUID], t.[AppointmentID_Temp], t.[ClientGUID], t.[ClientMembershipGUID], t.[ParentAppointmentGUID], t.[CenterID], t.[ClientHomeCenterID], t.[ResourceID], t.[ConfirmationTypeID], t.[AppointmentTypeID], t.[AppointmentDate], t.[StartTime], t.[EndTime], t.[CheckinTime], t.[CheckoutTime], t.[AppointmentSubject], t.[CanPrintCommentFlag], t.[IsNonAppointmentFlag], t.[RecurrenceRule], t.[StartDateTimeCalc], t.[EndDateTimeCalc], t.[AppointmentDurationCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AppointmentStatusID], t.[IsDeletedFlag], t.[OnContactActivityID], t.[OnContactContactID], t.[CheckedInFlag], t.[IsAuthorizedFlag], t.[LastChangeUser], t.[LastChangeDate], t.[ScalpHealthID], t.[AppointmentPriorityColorID], t.[CompletedVisitTypeID], t.[IsFullTrichoView], t.[SalesforceContactID], t.[SalesforceTaskID], t.[KorvueID], t.[ServiceStartTime], t.[ServiceEndTime], t.[IsClientContactInformationConfirmed]
		from [cdc].[dbo_datAppointment_CT] t with (nolock) inner join
		(	select  r.[AppointmentGUID], max(r.__$seqval) as __$max_seqval_CF70F18F,
		    count(*) as __$count_CF70F18F,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datAppointment_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AppointmentGUID]) m
		on t.__$seqval = m.__$max_seqval_CF70F18F and
		    ( (t.[AppointmentGUID] = m.[AppointmentGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datAppointment_CT] c with (nolock)
							where  ( (c.[AppointmentGUID] = t.[AppointmentGUID]) )
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
		null as __$update_mask , t.[AppointmentGUID], t.[AppointmentID_Temp], t.[ClientGUID], t.[ClientMembershipGUID], t.[ParentAppointmentGUID], t.[CenterID], t.[ClientHomeCenterID], t.[ResourceID], t.[ConfirmationTypeID], t.[AppointmentTypeID], t.[AppointmentDate], t.[StartTime], t.[EndTime], t.[CheckinTime], t.[CheckoutTime], t.[AppointmentSubject], t.[CanPrintCommentFlag], t.[IsNonAppointmentFlag], t.[RecurrenceRule], t.[StartDateTimeCalc], t.[EndDateTimeCalc], t.[AppointmentDurationCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AppointmentStatusID], t.[IsDeletedFlag], t.[OnContactActivityID], t.[OnContactContactID], t.[CheckedInFlag], t.[IsAuthorizedFlag], t.[LastChangeUser], t.[LastChangeDate], t.[ScalpHealthID], t.[AppointmentPriorityColorID], t.[CompletedVisitTypeID], t.[IsFullTrichoView], t.[SalesforceContactID], t.[SalesforceTaskID], t.[KorvueID], t.[ServiceStartTime], t.[ServiceEndTime], t.[IsClientContactInformationConfirmed]
		from [cdc].[dbo_datAppointment_CT] t  with (nolock) inner join
		(	select  r.[AppointmentGUID], max(r.__$seqval) as __$max_seqval_CF70F18F
			from [cdc].[dbo_datAppointment_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[AppointmentGUID]) m
		on t.__$seqval = m.__$max_seqval_CF70F18F and
		    ( (t.[AppointmentGUID] = m.[AppointmentGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datAppointment_CT] c with (nolock)
							where  ( (c.[AppointmentGUID] = t.[AppointmentGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
