/* CreateDate: 05/05/2020 18:41:08.037 , ModifyDate: 05/05/2020 18:41:08.037 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datAppointment]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [AppointmentGUID], NULL as [AppointmentID_Temp], NULL as [ClientGUID], NULL as [ClientMembershipGUID], NULL as [ParentAppointmentGUID], NULL as [CenterID], NULL as [ClientHomeCenterID], NULL as [ResourceID], NULL as [ConfirmationTypeID], NULL as [AppointmentTypeID], NULL as [AppointmentDate], NULL as [StartTime], NULL as [EndTime], NULL as [CheckinTime], NULL as [CheckoutTime], NULL as [AppointmentSubject], NULL as [CanPrintCommentFlag], NULL as [IsNonAppointmentFlag], NULL as [RecurrenceRule], NULL as [StartDateTimeCalc], NULL as [EndDateTimeCalc], NULL as [AppointmentDurationCalc], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [AppointmentStatusID], NULL as [IsDeletedFlag], NULL as [OnContactActivityID], NULL as [OnContactContactID], NULL as [CheckedInFlag], NULL as [IsAuthorizedFlag], NULL as [LastChangeUser], NULL as [LastChangeDate], NULL as [ScalpHealthID], NULL as [AppointmentPriorityColorID], NULL as [CompletedVisitTypeID], NULL as [IsFullTrichoView], NULL as [SalesforceContactID], NULL as [SalesforceTaskID], NULL as [KorvueID], NULL as [ServiceStartTime], NULL as [ServiceEndTime], NULL as [IsClientContactInformationConfirmed]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[AppointmentGUID], t.[AppointmentID_Temp], t.[ClientGUID], t.[ClientMembershipGUID], t.[ParentAppointmentGUID], t.[CenterID], t.[ClientHomeCenterID], t.[ResourceID], t.[ConfirmationTypeID], t.[AppointmentTypeID], t.[AppointmentDate], t.[StartTime], t.[EndTime], t.[CheckinTime], t.[CheckoutTime], t.[AppointmentSubject], t.[CanPrintCommentFlag], t.[IsNonAppointmentFlag], t.[RecurrenceRule], t.[StartDateTimeCalc], t.[EndDateTimeCalc], t.[AppointmentDurationCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AppointmentStatusID], t.[IsDeletedFlag], t.[OnContactActivityID], t.[OnContactContactID], t.[CheckedInFlag], t.[IsAuthorizedFlag], t.[LastChangeUser], t.[LastChangeDate], t.[ScalpHealthID], t.[AppointmentPriorityColorID], t.[CompletedVisitTypeID], t.[IsFullTrichoView], t.[SalesforceContactID], t.[SalesforceTaskID], t.[KorvueID], t.[ServiceStartTime], t.[ServiceEndTime], t.[IsClientContactInformationConfirmed]
	from [cdc].[dbo_datAppointment_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[AppointmentGUID], t.[AppointmentID_Temp], t.[ClientGUID], t.[ClientMembershipGUID], t.[ParentAppointmentGUID], t.[CenterID], t.[ClientHomeCenterID], t.[ResourceID], t.[ConfirmationTypeID], t.[AppointmentTypeID], t.[AppointmentDate], t.[StartTime], t.[EndTime], t.[CheckinTime], t.[CheckoutTime], t.[AppointmentSubject], t.[CanPrintCommentFlag], t.[IsNonAppointmentFlag], t.[RecurrenceRule], t.[StartDateTimeCalc], t.[EndDateTimeCalc], t.[AppointmentDurationCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[AppointmentStatusID], t.[IsDeletedFlag], t.[OnContactActivityID], t.[OnContactContactID], t.[CheckedInFlag], t.[IsAuthorizedFlag], t.[LastChangeUser], t.[LastChangeDate], t.[ScalpHealthID], t.[AppointmentPriorityColorID], t.[CompletedVisitTypeID], t.[IsFullTrichoView], t.[SalesforceContactID], t.[SalesforceTaskID], t.[KorvueID], t.[ServiceStartTime], t.[ServiceEndTime], t.[IsClientContactInformationConfirmed]
	from [cdc].[dbo_datAppointment_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datAppointment', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
