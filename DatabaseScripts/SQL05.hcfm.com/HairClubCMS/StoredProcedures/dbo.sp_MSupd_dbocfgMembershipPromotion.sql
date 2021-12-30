/* CreateDate: 05/05/2020 17:42:40.847 , ModifyDate: 05/05/2020 17:42:40.847 */
GO
create procedure [sp_MSupd_dbocfgMembershipPromotion]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 decimal(6,2) = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 bit = NULL,
		@c16 datetime = NULL,
		@c17 nvarchar(25) = NULL,
		@c18 datetime = NULL,
		@c19 nvarchar(25) = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgMembershipPromotion] set
		[MembershipPromotionSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipPromotionSortOrder] end,
		[MembershipPromotionDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipPromotionDescription] end,
		[MembershipPromotionDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MembershipPromotionDescriptionShort] end,
		[MembershipPromotionTypeID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MembershipPromotionTypeID] end,
		[BeginDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BeginDate] end,
		[EndDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EndDate] end,
		[Amount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Amount] end,
		[RevenueGroupID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RevenueGroupID] end,
		[BusinessSegmentID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [BusinessSegmentID] end,
		[AdditionalSystems] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AdditionalSystems] end,
		[AdditionalServices] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AdditionalServices] end,
		[AdditionalSolutions] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [AdditionalSolutions] end,
		[AdditionalProductKits] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [AdditionalProductKits] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdateUser] end,
		[AdditionalHCSL] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [AdditionalHCSL] end,
		[AdditionalStrands] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [AdditionalStrands] end,
		[MembershipPromotionGroupID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [MembershipPromotionGroupID] end,
		[MembershipPromotionAdjustmentTypeID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MembershipPromotionAdjustmentTypeID] end
	where [MembershipPromotionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipPromotionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgMembershipPromotion]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
