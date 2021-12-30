/* CreateDate: 05/05/2020 17:42:44.607 , ModifyDate: 05/05/2020 17:42:44.607 */
GO
create procedure [sp_MSupd_dbocfgMembershipRule]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 bit = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 datetime = NULL,
		@c15 nvarchar(25) = NULL,
		@c16 datetime = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 int = NULL,
		@c26 int = NULL,
		@c27 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgMembershipRule] set
		[MembershipRuleSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipRuleSortOrder] end,
		[MembershipRuleTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipRuleTypeID] end,
		[CurrentMembershipID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CurrentMembershipID] end,
		[NewMembershipID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [NewMembershipID] end,
		[SalesCodeID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesCodeID] end,
		[Interval] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Interval] end,
		[UnitOfMeasureID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [UnitOfMeasureID] end,
		[MembershipScreen1ID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MembershipScreen1ID] end,
		[MembershipScreen2ID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [MembershipScreen2ID] end,
		[MembershipScreen3ID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MembershipScreen3ID] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsActiveFlag] end,
		[CreateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateUser] end,
		[CreateDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateDate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdate] end,
		[CurrentMembershipStatusID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CurrentMembershipStatusID] end,
		[NewMembershipStatusID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [NewMembershipStatusID] end,
		[MembershipCancelRuleID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [MembershipCancelRuleID] end,
		[MembershipCancelSalesCodeID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [MembershipCancelSalesCodeID] end,
		[AdditionalNewMembershipID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [AdditionalNewMembershipID] end,
		[CenterBusinessTypeID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CenterBusinessTypeID] end,
		[FromCancelledMembershipSalesCodeID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [FromCancelledMembershipSalesCodeID] end,
		[AddOnID] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [AddOnID] end,
		[ReplaceCurrentClientMembershipStatusID] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [ReplaceCurrentClientMembershipStatusID] end,
		[AssociatedAddOnSalesCodeID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [AssociatedAddOnSalesCodeID] end,
		[AssociatedAddOnNewClientMembershipAddOnStatusID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [AssociatedAddOnNewClientMembershipAddOnStatusID] end
	where [MembershipRuleID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipRuleID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgMembershipRule]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
