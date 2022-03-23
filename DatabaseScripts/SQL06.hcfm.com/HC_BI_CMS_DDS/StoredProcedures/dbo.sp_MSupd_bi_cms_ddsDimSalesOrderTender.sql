/* CreateDate: 03/17/2022 11:57:07.070 , ModifyDate: 03/17/2022 11:57:07.070 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimSalesOrderTender]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 datetime = NULL,
		@c6 int = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(10) = NULL,
		@c9 bit = NULL,
		@c10 bit = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 nvarchar(4) = NULL,
		@c14 nvarchar(100) = NULL,
		@c15 int = NULL,
		@c16 nvarchar(50) = NULL,
		@c17 nvarchar(10) = NULL,
		@c18 int = NULL,
		@c19 nvarchar(50) = NULL,
		@c20 nvarchar(10) = NULL,
		@c21 int = NULL,
		@c22 nvarchar(50) = NULL,
		@c23 nvarchar(10) = NULL,
		@c24 tinyint = NULL,
		@c25 datetime = NULL,
		@c26 datetime = NULL,
		@c27 varchar(200) = NULL,
		@c28 tinyint = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimSalesOrderTender] set
		[SalesOrderTenderSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderTenderSSID] end,
		[SalesOrderKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderKey] end,
		[SalesOrderSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesOrderSSID] end,
		[OrderDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [OrderDate] end,
		[TenderTypeSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [TenderTypeSSID] end,
		[TenderTypeDescription] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [TenderTypeDescription] end,
		[TenderTypeDescriptionShort] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [TenderTypeDescriptionShort] end,
		[IsVoidedFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsVoidedFlag] end,
		[IsClosedFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsClosedFlag] end,
		[Amount] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Amount] end,
		[CheckNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CheckNumber] end,
		[CreditCardLast4Digits] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreditCardLast4Digits] end,
		[ApprovalCode] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ApprovalCode] end,
		[CreditCardTypeSSID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreditCardTypeSSID] end,
		[CreditCardTypeDescription] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreditCardTypeDescription] end,
		[CreditCardTypeDescriptionShort] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreditCardTypeDescriptionShort] end,
		[FinanceCompanySSID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [FinanceCompanySSID] end,
		[FinanceCompanyDescription] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [FinanceCompanyDescription] end,
		[FinanceCompanyDescriptionShort] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [FinanceCompanyDescriptionShort] end,
		[InterCompanyReasonSSID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [InterCompanyReasonSSID] end,
		[InterCompanyReasonDescription] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InterCompanyReasonDescription] end,
		[InterCompanyReasonDescriptionShort] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [InterCompanyReasonDescriptionShort] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [msrepl_tran_version] end
	where [SalesOrderTenderKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderTenderKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimSalesOrderTender]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
