/* CreateDate: 05/05/2020 17:42:49.770 , ModifyDate: 05/05/2020 17:42:49.770 */
GO
create procedure [sp_MSupd_dbodatCreditCardTransactionLog]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 bigint = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 money = NULL,
		@c9 nvarchar(100) = NULL,
		@c10 nvarchar(30) = NULL,
		@c11 nvarchar(30) = NULL,
		@c12 nvarchar(4) = NULL,
		@c13 nvarchar(10) = NULL,
		@c14 bigint = NULL,
		@c15 bit = NULL,
		@c16 bit = NULL,
		@c17 nvarchar(20) = NULL,
		@c18 nvarchar(20) = NULL,
		@c19 nvarchar(20) = NULL,
		@c20 bit = NULL,
		@c21 nvarchar(max) = NULL,
		@c22 datetime = NULL,
		@c23 nvarchar(25) = NULL,
		@c24 datetime = NULL,
		@c25 nvarchar(25) = NULL,
		@c26 nvarchar(20) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datCreditCardTransactionLog] set
		[CreditCardTransactionLogGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CreditCardTransactionLogGUID] end,
		[SalesOrderTenderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderTenderGUID] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderGUID] end,
		[EFTTransactionID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EFTTransactionID] end,
		[SecureDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SecureDate] end,
		[SettleDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SettleDate] end,
		[ApprovalCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ApprovalCode] end,
		[Amount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Amount] end,
		[Verbiage] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Verbiage] end,
		[MSoftCode] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [MSoftCode] end,
		[PHardCode] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PHardCode] end,
		[Last4Digits] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Last4Digits] end,
		[ExpirationDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ExpirationDate] end,
		[MonetraTransactionId] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [MonetraTransactionId] end,
		[IsTokenUsedFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsTokenUsedFlag] end,
		[IsCardPresentFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsCardPresentFlag] end,
		[EmployeeID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [EmployeeID] end,
		[MachineTerminalID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [MachineTerminalID] end,
		[IpAddress] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IpAddress] end,
		[IsSuccessfulFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsSuccessfulFlag] end,
		[TransactionErrorMessage] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [TransactionErrorMessage] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[AVSResult] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [AVSResult] end
	where [CreditCardTransactionLogGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CreditCardTransactionLogGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCreditCardTransactionLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datCreditCardTransactionLog] set
		[SalesOrderTenderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderTenderGUID] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderGUID] end,
		[EFTTransactionID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EFTTransactionID] end,
		[SecureDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SecureDate] end,
		[SettleDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SettleDate] end,
		[ApprovalCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ApprovalCode] end,
		[Amount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Amount] end,
		[Verbiage] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Verbiage] end,
		[MSoftCode] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [MSoftCode] end,
		[PHardCode] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PHardCode] end,
		[Last4Digits] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Last4Digits] end,
		[ExpirationDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ExpirationDate] end,
		[MonetraTransactionId] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [MonetraTransactionId] end,
		[IsTokenUsedFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsTokenUsedFlag] end,
		[IsCardPresentFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsCardPresentFlag] end,
		[EmployeeID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [EmployeeID] end,
		[MachineTerminalID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [MachineTerminalID] end,
		[IpAddress] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IpAddress] end,
		[IsSuccessfulFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsSuccessfulFlag] end,
		[TransactionErrorMessage] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [TransactionErrorMessage] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[AVSResult] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [AVSResult] end
	where [CreditCardTransactionLogGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CreditCardTransactionLogGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCreditCardTransactionLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
