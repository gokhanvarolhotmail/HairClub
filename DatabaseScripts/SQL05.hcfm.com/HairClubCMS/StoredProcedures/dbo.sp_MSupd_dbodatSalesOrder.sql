/* CreateDate: 05/05/2020 17:42:47.817 , ModifyDate: 05/05/2020 17:42:47.817 */
GO
create procedure [sp_MSupd_dbodatSalesOrder]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 uniqueidentifier = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 uniqueidentifier = NULL,
		@c10 uniqueidentifier = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 bit = NULL,
		@c14 bit = NULL,
		@c15 bit = NULL,
		@c16 uniqueidentifier = NULL,
		@c17 uniqueidentifier = NULL,
		@c18 nvarchar(15) = NULL,
		@c19 bit = NULL,
		@c20 bit = NULL,
		@c21 uniqueidentifier = NULL,
		@c22 datetime = NULL,
		@c23 nvarchar(25) = NULL,
		@c24 datetime = NULL,
		@c25 nvarchar(25) = NULL,
		@c26 uniqueidentifier = NULL,
		@c27 bit = NULL,
		@c28 bit = NULL,
		@c29 varchar(10) = NULL,
		@c30 datetime = NULL,
		@c31 uniqueidentifier = NULL,
		@c32 uniqueidentifier = NULL,
		@c33 int = NULL,
		@c34 uniqueidentifier = NULL,
		@c35 int = NULL,
		@c36 uniqueidentifier = NULL,
		@c37 uniqueidentifier = NULL,
		@c38 uniqueidentifier = NULL,
		@c39 int = NULL,
		@c40 int = NULL,
		@c41 nvarchar(100) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(6)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datSalesOrder] set
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SalesOrderGUID] end,
		[TenderTransactionNumber_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TenderTransactionNumber_Temp] end,
		[TicketNumber_Temp] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TicketNumber_Temp] end,
		[CenterID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterID] end,
		[ClientHomeCenterID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientHomeCenterID] end,
		[SalesOrderTypeID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesOrderTypeID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientMembershipGUID] end,
		[AppointmentGUID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [AppointmentGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HairSystemOrderGUID] end,
		[OrderDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [OrderDate] end,
		[InvoiceNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InvoiceNumber] end,
		[IsTaxExemptFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsTaxExemptFlag] end,
		[IsVoidedFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsVoidedFlag] end,
		[IsClosedFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsClosedFlag] end,
		[RegisterCloseGUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RegisterCloseGUID] end,
		[EmployeeGUID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [EmployeeGUID] end,
		[FulfillmentNumber] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [FulfillmentNumber] end,
		[IsWrittenOffFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsWrittenOffFlag] end,
		[IsRefundedFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsRefundedFlag] end,
		[RefundedSalesOrderGUID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RefundedSalesOrderGUID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[ParentSalesOrderGUID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ParentSalesOrderGUID] end,
		[IsSurgeryReversalFlag] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [IsSurgeryReversalFlag] end,
		[IsGuaranteeFlag] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsGuaranteeFlag] end,
		[cashier_temp] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [cashier_temp] end,
		[ctrOrderDate] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [ctrOrderDate] end,
		[CenterFeeBatchGUID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CenterFeeBatchGUID] end,
		[CenterDeclineBatchGUID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CenterDeclineBatchGUID] end,
		[RegisterID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [RegisterID] end,
		[EndOfDayGUID] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [EndOfDayGUID] end,
		[IncomingRequestID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [IncomingRequestID] end,
		[WriteOffSalesOrderGUID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [WriteOffSalesOrderGUID] end,
		[NSFSalesOrderGUID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [NSFSalesOrderGUID] end,
		[ChargeBackSalesOrderGUID] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [ChargeBackSalesOrderGUID] end,
		[ChargebackReasonID] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [ChargebackReasonID] end,
		[InterCompanyTransactionID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [InterCompanyTransactionID] end,
		[WriteOffReasonDescription] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [WriteOffReasonDescription] end
	where [SalesOrderGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSalesOrder]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datSalesOrder] set
		[TenderTransactionNumber_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TenderTransactionNumber_Temp] end,
		[TicketNumber_Temp] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TicketNumber_Temp] end,
		[CenterID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterID] end,
		[ClientHomeCenterID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientHomeCenterID] end,
		[SalesOrderTypeID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesOrderTypeID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientMembershipGUID] end,
		[AppointmentGUID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [AppointmentGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HairSystemOrderGUID] end,
		[OrderDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [OrderDate] end,
		[InvoiceNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InvoiceNumber] end,
		[IsTaxExemptFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsTaxExemptFlag] end,
		[IsVoidedFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsVoidedFlag] end,
		[IsClosedFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsClosedFlag] end,
		[RegisterCloseGUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RegisterCloseGUID] end,
		[EmployeeGUID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [EmployeeGUID] end,
		[FulfillmentNumber] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [FulfillmentNumber] end,
		[IsWrittenOffFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsWrittenOffFlag] end,
		[IsRefundedFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsRefundedFlag] end,
		[RefundedSalesOrderGUID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RefundedSalesOrderGUID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[ParentSalesOrderGUID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ParentSalesOrderGUID] end,
		[IsSurgeryReversalFlag] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [IsSurgeryReversalFlag] end,
		[IsGuaranteeFlag] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsGuaranteeFlag] end,
		[cashier_temp] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [cashier_temp] end,
		[ctrOrderDate] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [ctrOrderDate] end,
		[CenterFeeBatchGUID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CenterFeeBatchGUID] end,
		[CenterDeclineBatchGUID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CenterDeclineBatchGUID] end,
		[RegisterID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [RegisterID] end,
		[EndOfDayGUID] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [EndOfDayGUID] end,
		[IncomingRequestID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [IncomingRequestID] end,
		[WriteOffSalesOrderGUID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [WriteOffSalesOrderGUID] end,
		[NSFSalesOrderGUID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [NSFSalesOrderGUID] end,
		[ChargeBackSalesOrderGUID] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [ChargeBackSalesOrderGUID] end,
		[ChargebackReasonID] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [ChargebackReasonID] end,
		[InterCompanyTransactionID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [InterCompanyTransactionID] end,
		[WriteOffReasonDescription] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [WriteOffReasonDescription] end
	where [SalesOrderGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSalesOrder]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
