/* CreateDate: 05/05/2020 17:42:48.403 , ModifyDate: 05/05/2020 17:42:48.403 */
GO
create procedure [sp_MSupd_dbodatSalesOrderTender]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 money = NULL,
		@c5 int = NULL,
		@c6 nvarchar(4) = NULL,
		@c7 nvarchar(100) = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 money = NULL,
		@c16 bigint = NULL,
		@c17 int = NULL,
		@c18 money = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datSalesOrderTender] set
		[SalesOrderTenderGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SalesOrderTenderGUID] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderGUID] end,
		[TenderTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TenderTypeID] end,
		[Amount] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Amount] end,
		[CheckNumber] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CheckNumber] end,
		[CreditCardLast4Digits] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreditCardLast4Digits] end,
		[ApprovalCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ApprovalCode] end,
		[CreditCardTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreditCardTypeID] end,
		[FinanceCompanyID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [FinanceCompanyID] end,
		[InterCompanyReasonID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InterCompanyReasonID] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end,
		[RefundAmount] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RefundAmount] end,
		[MonetraTransactionId] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [MonetraTransactionId] end,
		[EntrySortOrder] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [EntrySortOrder] end,
		[CashCollected] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CashCollected] end
	where [SalesOrderTenderGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderTenderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSalesOrderTender]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datSalesOrderTender] set
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderGUID] end,
		[TenderTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TenderTypeID] end,
		[Amount] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Amount] end,
		[CheckNumber] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CheckNumber] end,
		[CreditCardLast4Digits] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreditCardLast4Digits] end,
		[ApprovalCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ApprovalCode] end,
		[CreditCardTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreditCardTypeID] end,
		[FinanceCompanyID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [FinanceCompanyID] end,
		[InterCompanyReasonID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InterCompanyReasonID] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end,
		[RefundAmount] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RefundAmount] end,
		[MonetraTransactionId] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [MonetraTransactionId] end,
		[EntrySortOrder] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [EntrySortOrder] end,
		[CashCollected] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CashCollected] end
	where [SalesOrderTenderGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderTenderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSalesOrderTender]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
