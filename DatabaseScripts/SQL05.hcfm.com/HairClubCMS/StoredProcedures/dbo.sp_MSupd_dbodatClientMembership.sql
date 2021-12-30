/* CreateDate: 05/05/2020 17:42:45.840 , ModifyDate: 05/05/2020 17:42:45.840 */
GO
create procedure [sp_MSupd_dbodatClientMembership]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 money = NULL,
		@c8 money = NULL,
		@c9 money = NULL,
		@c10 date = NULL,
		@c11 date = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 bit = NULL,
		@c15 bit = NULL,
		@c16 bit = NULL,
		@c17 int = NULL,
		@c18 bit = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 datetime = NULL,
		@c22 nvarchar(25) = NULL,
		@c23 nvarchar(50) = NULL,
		@c24 nvarchar(100) = NULL,
		@c25 bit = NULL,
		@c26 money = NULL,
		@c27 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datClientMembership] set
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ClientMembershipGUID] end,
		[Member1_ID_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Member1_ID_Temp] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterID] end,
		[MembershipID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MembershipID] end,
		[ClientMembershipStatusID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientMembershipStatusID] end,
		[ContractPrice] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ContractPrice] end,
		[ContractPaidAmount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ContractPaidAmount] end,
		[MonthlyFee] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MonthlyFee] end,
		[BeginDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [BeginDate] end,
		[EndDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EndDate] end,
		[MembershipCancelReasonID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MembershipCancelReasonID] end,
		[CancelDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CancelDate] end,
		[IsGuaranteeFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsGuaranteeFlag] end,
		[IsRenewalFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsRenewalFlag] end,
		[IsMultipleSurgeryFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsMultipleSurgeryFlag] end,
		[RenewalCount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RenewalCount] end,
		[IsActiveFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdateUser] end,
		[ClientMembershipIdentifier] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [ClientMembershipIdentifier] end,
		[MembershipCancelReasonDescription] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [MembershipCancelReasonDescription] end,
		[HasInHousePaymentPlan] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [HasInHousePaymentPlan] end,
		[NationalMonthlyFee] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [NationalMonthlyFee] end,
		[MembershipProfileTypeID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [MembershipProfileTypeID] end
	where [ClientMembershipGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datClientMembership] set
		[Member1_ID_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Member1_ID_Temp] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterID] end,
		[MembershipID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MembershipID] end,
		[ClientMembershipStatusID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientMembershipStatusID] end,
		[ContractPrice] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ContractPrice] end,
		[ContractPaidAmount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ContractPaidAmount] end,
		[MonthlyFee] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MonthlyFee] end,
		[BeginDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [BeginDate] end,
		[EndDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EndDate] end,
		[MembershipCancelReasonID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MembershipCancelReasonID] end,
		[CancelDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CancelDate] end,
		[IsGuaranteeFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsGuaranteeFlag] end,
		[IsRenewalFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsRenewalFlag] end,
		[IsMultipleSurgeryFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsMultipleSurgeryFlag] end,
		[RenewalCount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RenewalCount] end,
		[IsActiveFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdateUser] end,
		[ClientMembershipIdentifier] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [ClientMembershipIdentifier] end,
		[MembershipCancelReasonDescription] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [MembershipCancelReasonDescription] end,
		[HasInHousePaymentPlan] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [HasInHousePaymentPlan] end,
		[NationalMonthlyFee] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [NationalMonthlyFee] end,
		[MembershipProfileTypeID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [MembershipProfileTypeID] end
	where [ClientMembershipGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
