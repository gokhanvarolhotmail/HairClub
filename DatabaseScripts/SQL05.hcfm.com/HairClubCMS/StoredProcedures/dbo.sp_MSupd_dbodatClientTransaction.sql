/* CreateDate: 05/05/2020 17:42:49.467 , ModifyDate: 05/05/2020 17:42:49.467 */
GO
create procedure [sp_MSupd_dbodatClientTransaction]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 datetime = NULL,
		@c10 datetime = NULL,
		@c11 datetime = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(4) = NULL,
		@c14 nvarchar(4) = NULL,
		@c15 date = NULL,
		@c16 date = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 datetime = NULL,
		@c22 nvarchar(25) = NULL,
		@c23 money = NULL,
		@c24 money = NULL,
		@c25 nvarchar(100) = NULL,
		@c26 nvarchar(100) = NULL,
		@c27 nvarchar(4) = NULL,
		@c28 nvarchar(4) = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datClientTransaction] set
		[ClientTransactionGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ClientTransactionGUID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[TransactionDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TransactionDate] end,
		[ClientProcessID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientProcessID] end,
		[EFTFreezeStartDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EFTFreezeStartDate] end,
		[PreviousEFTFreezeStartDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PreviousEFTFreezeStartDate] end,
		[EFTFreezeEndDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EFTFreezeEndDate] end,
		[PreviousEFTFreezeEndDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [PreviousEFTFreezeEndDate] end,
		[EFTHoldStartDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EFTHoldStartDate] end,
		[PreviousEFTHoldStartDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PreviousEFTHoldStartDate] end,
		[EFTHoldEndDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EFTHoldEndDate] end,
		[PreviousEFTHoldEndDate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PreviousEFTHoldEndDate] end,
		[CCNumber] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CCNumber] end,
		[PreviousCCNumber] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PreviousCCNumber] end,
		[CCExpirationDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CCExpirationDate] end,
		[PreviousCCExpirationDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PreviousCCExpirationDate] end,
		[FeePayCycleId] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [FeePayCycleId] end,
		[PreviousFeePayCycleId] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [PreviousFeePayCycleId] end,
		[CreateDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdateUser] end,
		[MonthlyFeeAmount] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MonthlyFeeAmount] end,
		[PreviousMonthlyFeeAmount] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [PreviousMonthlyFeeAmount] end,
		[PreviousFeeFreezeReasonDescription] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [PreviousFeeFreezeReasonDescription] end,
		[FeeFreezeReasonDescription] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [FeeFreezeReasonDescription] end,
		[BankAccountNumber] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [BankAccountNumber] end,
		[PreviousBankAccountNumber] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [PreviousBankAccountNumber] end,
		[FeeFreezeReasonID] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [FeeFreezeReasonID] end,
		[PreviousFeeFreezeReasonID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [PreviousFeeFreezeReasonID] end
	where [ClientTransactionGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientTransactionGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datClientTransaction] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[TransactionDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TransactionDate] end,
		[ClientProcessID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientProcessID] end,
		[EFTFreezeStartDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EFTFreezeStartDate] end,
		[PreviousEFTFreezeStartDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PreviousEFTFreezeStartDate] end,
		[EFTFreezeEndDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EFTFreezeEndDate] end,
		[PreviousEFTFreezeEndDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [PreviousEFTFreezeEndDate] end,
		[EFTHoldStartDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EFTHoldStartDate] end,
		[PreviousEFTHoldStartDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PreviousEFTHoldStartDate] end,
		[EFTHoldEndDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EFTHoldEndDate] end,
		[PreviousEFTHoldEndDate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PreviousEFTHoldEndDate] end,
		[CCNumber] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CCNumber] end,
		[PreviousCCNumber] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PreviousCCNumber] end,
		[CCExpirationDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CCExpirationDate] end,
		[PreviousCCExpirationDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PreviousCCExpirationDate] end,
		[FeePayCycleId] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [FeePayCycleId] end,
		[PreviousFeePayCycleId] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [PreviousFeePayCycleId] end,
		[CreateDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdateUser] end,
		[MonthlyFeeAmount] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MonthlyFeeAmount] end,
		[PreviousMonthlyFeeAmount] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [PreviousMonthlyFeeAmount] end,
		[PreviousFeeFreezeReasonDescription] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [PreviousFeeFreezeReasonDescription] end,
		[FeeFreezeReasonDescription] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [FeeFreezeReasonDescription] end,
		[BankAccountNumber] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [BankAccountNumber] end,
		[PreviousBankAccountNumber] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [PreviousBankAccountNumber] end,
		[FeeFreezeReasonID] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [FeeFreezeReasonID] end,
		[PreviousFeeFreezeReasonID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [PreviousFeeFreezeReasonID] end
	where [ClientTransactionGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientTransactionGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
