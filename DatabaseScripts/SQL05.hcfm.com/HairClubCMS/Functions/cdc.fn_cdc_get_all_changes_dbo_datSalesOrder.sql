/* CreateDate: 05/05/2020 18:41:00.637 , ModifyDate: 05/05/2020 18:41:00.637 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datSalesOrder]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesOrderGUID], NULL as [TenderTransactionNumber_Temp], NULL as [TicketNumber_Temp], NULL as [CenterID], NULL as [ClientHomeCenterID], NULL as [SalesOrderTypeID], NULL as [ClientGUID], NULL as [ClientMembershipGUID], NULL as [AppointmentGUID], NULL as [HairSystemOrderGUID], NULL as [OrderDate], NULL as [InvoiceNumber], NULL as [IsTaxExemptFlag], NULL as [IsVoidedFlag], NULL as [IsClosedFlag], NULL as [RegisterCloseGUID], NULL as [EmployeeGUID], NULL as [FulfillmentNumber], NULL as [IsWrittenOffFlag], NULL as [IsRefundedFlag], NULL as [RefundedSalesOrderGUID], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [ParentSalesOrderGUID], NULL as [IsSurgeryReversalFlag], NULL as [IsGuaranteeFlag], NULL as [cashier_temp], NULL as [ctrOrderDate], NULL as [CenterFeeBatchGUID], NULL as [CenterDeclineBatchGUID], NULL as [RegisterID], NULL as [EndOfDayGUID], NULL as [IncomingRequestID], NULL as [WriteOffSalesOrderGUID], NULL as [NSFSalesOrderGUID], NULL as [ChargeBackSalesOrderGUID], NULL as [ChargebackReasonID], NULL as [InterCompanyTransactionID], NULL as [WriteOffReasonDescription]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrder', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesOrderGUID], t.[TenderTransactionNumber_Temp], t.[TicketNumber_Temp], t.[CenterID], t.[ClientHomeCenterID], t.[SalesOrderTypeID], t.[ClientGUID], t.[ClientMembershipGUID], t.[AppointmentGUID], t.[HairSystemOrderGUID], t.[OrderDate], t.[InvoiceNumber], t.[IsTaxExemptFlag], t.[IsVoidedFlag], t.[IsClosedFlag], t.[RegisterCloseGUID], t.[EmployeeGUID], t.[FulfillmentNumber], t.[IsWrittenOffFlag], t.[IsRefundedFlag], t.[RefundedSalesOrderGUID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ParentSalesOrderGUID], t.[IsSurgeryReversalFlag], t.[IsGuaranteeFlag], t.[cashier_temp], t.[ctrOrderDate], t.[CenterFeeBatchGUID], t.[CenterDeclineBatchGUID], t.[RegisterID], t.[EndOfDayGUID], t.[IncomingRequestID], t.[WriteOffSalesOrderGUID], t.[NSFSalesOrderGUID], t.[ChargeBackSalesOrderGUID], t.[ChargebackReasonID], t.[InterCompanyTransactionID], t.[WriteOffReasonDescription]
	from [cdc].[dbo_datSalesOrder_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrder', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesOrderGUID], t.[TenderTransactionNumber_Temp], t.[TicketNumber_Temp], t.[CenterID], t.[ClientHomeCenterID], t.[SalesOrderTypeID], t.[ClientGUID], t.[ClientMembershipGUID], t.[AppointmentGUID], t.[HairSystemOrderGUID], t.[OrderDate], t.[InvoiceNumber], t.[IsTaxExemptFlag], t.[IsVoidedFlag], t.[IsClosedFlag], t.[RegisterCloseGUID], t.[EmployeeGUID], t.[FulfillmentNumber], t.[IsWrittenOffFlag], t.[IsRefundedFlag], t.[RefundedSalesOrderGUID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[ParentSalesOrderGUID], t.[IsSurgeryReversalFlag], t.[IsGuaranteeFlag], t.[cashier_temp], t.[ctrOrderDate], t.[CenterFeeBatchGUID], t.[CenterDeclineBatchGUID], t.[RegisterID], t.[EndOfDayGUID], t.[IncomingRequestID], t.[WriteOffSalesOrderGUID], t.[NSFSalesOrderGUID], t.[ChargeBackSalesOrderGUID], t.[ChargebackReasonID], t.[InterCompanyTransactionID], t.[WriteOffReasonDescription]
	from [cdc].[dbo_datSalesOrder_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrder', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
