/* CreateDate: 05/05/2020 17:42:49.270 , ModifyDate: 05/05/2020 17:42:49.270 */
GO
create procedure [sp_MSupd_dbodatClientEFT]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 nvarchar(4) = NULL,
		@c9 date = NULL,
		@c10 nvarchar(100) = NULL,
		@c11 nvarchar(15) = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 nvarchar(50) = NULL,
		@c15 datetime = NULL,
		@c16 bit = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 datetime = NULL,
		@c22 datetime = NULL,
		@c23 datetime = NULL,
		@c24 int = NULL,
		@c25 nvarchar(50) = NULL,
		@c26 bit = NULL,
		@c27 int = NULL,
		@c28 nvarchar(100) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datClientEFT] set
		[ClientEFTGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ClientEFTGUID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientMembershipGUID] end,
		[EFTAccountTypeID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EFTAccountTypeID] end,
		[EFTStatusID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EFTStatusID] end,
		[FeePayCycleID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [FeePayCycleID] end,
		[CreditCardTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreditCardTypeID] end,
		[AccountNumberLast4Digits] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AccountNumberLast4Digits] end,
		[AccountExpiration] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [AccountExpiration] end,
		[BankName] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [BankName] end,
		[BankPhone] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BankPhone] end,
		[BankRoutingNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [BankRoutingNumber] end,
		[BankAccountNumber] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [BankAccountNumber] end,
		[EFTProcessorToken] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [EFTProcessorToken] end,
		[LastRun] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastRun] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[Freeze_Start] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Freeze_Start] end,
		[Freeze_End] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [Freeze_End] end,
		[LastPaymentDate] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [LastPaymentDate] end,
		[FeeFreezeReasonId] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [FeeFreezeReasonId] end,
		[CardHolderName] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CardHolderName] end,
		[IsEFTTokenValidFlag] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [IsEFTTokenValidFlag] end,
		[BankCountryID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [BankCountryID] end,
		[FeeFreezeReasonDescription] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [FeeFreezeReasonDescription] end
	where [ClientEFTGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientEFTGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientEFT]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datClientEFT] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientMembershipGUID] end,
		[EFTAccountTypeID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EFTAccountTypeID] end,
		[EFTStatusID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EFTStatusID] end,
		[FeePayCycleID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [FeePayCycleID] end,
		[CreditCardTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreditCardTypeID] end,
		[AccountNumberLast4Digits] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AccountNumberLast4Digits] end,
		[AccountExpiration] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [AccountExpiration] end,
		[BankName] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [BankName] end,
		[BankPhone] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BankPhone] end,
		[BankRoutingNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [BankRoutingNumber] end,
		[BankAccountNumber] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [BankAccountNumber] end,
		[EFTProcessorToken] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [EFTProcessorToken] end,
		[LastRun] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastRun] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[Freeze_Start] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Freeze_Start] end,
		[Freeze_End] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [Freeze_End] end,
		[LastPaymentDate] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [LastPaymentDate] end,
		[FeeFreezeReasonId] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [FeeFreezeReasonId] end,
		[CardHolderName] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CardHolderName] end,
		[IsEFTTokenValidFlag] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [IsEFTTokenValidFlag] end,
		[BankCountryID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [BankCountryID] end,
		[FeeFreezeReasonDescription] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [FeeFreezeReasonDescription] end
	where [ClientEFTGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientEFTGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientEFT]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
