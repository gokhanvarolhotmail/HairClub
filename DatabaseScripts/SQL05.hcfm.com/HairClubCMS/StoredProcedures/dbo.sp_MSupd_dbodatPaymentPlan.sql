/* CreateDate: 05/05/2020 17:42:51.743 , ModifyDate: 05/05/2020 17:42:51.743 */
GO
create procedure [dbo].[sp_MSupd_dbodatPaymentPlan]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 int = NULL,
		@c5 money = NULL,
		@c6 money = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 datetime = NULL,
		@c10 datetime = NULL,
		@c11 datetime = NULL,
		@c12 money = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datPaymentPlan] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientMembershipGUID] end,
		[PaymentPlanStatusID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [PaymentPlanStatusID] end,
		[ContractAmount] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ContractAmount] end,
		[DownpaymentAmount] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DownpaymentAmount] end,
		[TotalNumberOfPayments] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [TotalNumberOfPayments] end,
		[RemainingNumberOfPayments] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RemainingNumberOfPayments] end,
		[StartDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [StartDate] end,
		[SatisfactionDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [SatisfactionDate] end,
		[CancelDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CancelDate] end,
		[RemainingBalance] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [RemainingBalance] end,
		[CreateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [UpdateStamp] end
	where [PaymentPlanID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[PaymentPlanID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datPaymentPlan]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
