/* CreateDate: 05/05/2020 17:42:40.433 , ModifyDate: 05/05/2020 17:42:40.433 */
GO
create procedure [sp_MSupd_dbocfgCenterMembership]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 bit = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 money = NULL,
		@c10 money = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 bit = NULL,
		@c14 money = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 money = NULL,
		@c18 bit = NULL,
		@c19 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgCenterMembership] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[MembershipID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipID] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end,
		[ContractPriceMale] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ContractPriceMale] end,
		[ContractPriceFemale] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ContractPriceFemale] end,
		[NumRenewalDays] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [NumRenewalDays] end,
		[AgreementID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AgreementID] end,
		[CanUseInHousePaymentPlan] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CanUseInHousePaymentPlan] end,
		[DownpaymentMinimumAmount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [DownpaymentMinimumAmount] end,
		[MinNumberOfPayments] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [MinNumberOfPayments] end,
		[MaxNumberOfPayments] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [MaxNumberOfPayments] end,
		[MinimumPaymentPlanAmount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [MinimumPaymentPlanAmount] end,
		[DoesNewBusinessHairOrderRestrictionsApply] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [DoesNewBusinessHairOrderRestrictionsApply] end,
		[ValuationPrice] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ValuationPrice] end
	where [CenterMembershipID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterMembershipID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgCenterMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
