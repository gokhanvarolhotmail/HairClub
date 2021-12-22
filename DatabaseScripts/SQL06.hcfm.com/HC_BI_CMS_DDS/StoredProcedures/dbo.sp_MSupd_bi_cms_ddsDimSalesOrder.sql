create procedure [sp_MSupd_bi_cms_ddsDimSalesOrder]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 uniqueidentifier = NULL,
		@c13 int = NULL,
		@c14 uniqueidentifier = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(50) = NULL,
		@c17 bit = NULL,
		@c18 bit = NULL,
		@c19 bit = NULL,
		@c20 int = NULL,
		@c21 uniqueidentifier = NULL,
		@c22 nvarchar(15) = NULL,
		@c23 bit = NULL,
		@c24 bit = NULL,
		@c25 int = NULL,
		@c26 uniqueidentifier = NULL,
		@c27 tinyint = NULL,
		@c28 datetime = NULL,
		@c29 datetime = NULL,
		@c30 varchar(200) = NULL,
		@c31 tinyint = NULL,
		@c32 int = NULL,
		@c33 int = NULL,
		@c34 uniqueidentifier = NULL,
		@c35 bit = NULL,
		@c36 bit = NULL,
		@c37 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimSalesOrder] set
		[SalesOrderSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderSSID] end,
		[TenderTransactionNumber_Temp] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TenderTransactionNumber_Temp] end,
		[TicketNumber_Temp] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [TicketNumber_Temp] end,
		[CenterKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CenterKey] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterSSID] end,
		[ClientHomeCenterKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientHomeCenterKey] end,
		[ClientHomeCenterSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientHomeCenterSSID] end,
		[SalesOrderTypeKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SalesOrderTypeKey] end,
		[SalesOrderTypeSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [SalesOrderTypeSSID] end,
		[ClientKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ClientKey] end,
		[ClientSSID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ClientSSID] end,
		[ClientMembershipKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ClientMembershipKey] end,
		[ClientMembershipSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ClientMembershipSSID] end,
		[OrderDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [OrderDate] end,
		[InvoiceNumber] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [InvoiceNumber] end,
		[IsTaxExemptFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [IsTaxExemptFlag] end,
		[IsVoidedFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsVoidedFlag] end,
		[IsClosedFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsClosedFlag] end,
		[EmployeeKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [EmployeeKey] end,
		[EmployeeSSID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [EmployeeSSID] end,
		[FulfillmentNumber] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [FulfillmentNumber] end,
		[IsWrittenOffFlag] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsWrittenOffFlag] end,
		[IsRefundedFlag] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [IsRefundedFlag] end,
		[RefundedSalesOrderKey] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [RefundedSalesOrderKey] end,
		[RefundedSalesOrderSSID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RefundedSalesOrderSSID] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [msrepl_tran_version] end,
		[IsSurgeryReversalFlag] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [IsSurgeryReversalFlag] end,
		[IsGuaranteeFlag] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [IsGuaranteeFlag] end,
		[IncomingRequestID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [IncomingRequestID] end
	where [SalesOrderKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimSalesOrder]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
