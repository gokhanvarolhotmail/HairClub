/* CreateDate: 05/05/2020 17:42:40.387 , ModifyDate: 05/05/2020 17:42:40.387 */
GO
create procedure [dbo].[sp_MSupd_dbocfgMembership]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 money = NULL,
		@c10 money = NULL,
		@c11 bit = NULL,
		@c12 bit = NULL,
		@c13 bit = NULL,
		@c14 datetime = NULL,
		@c15 nvarchar(25) = NULL,
		@c16 datetime = NULL,
		@c17 nvarchar(25) = NULL,
		@c18 binary(8) = NULL,
		@c19 bit = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 bit = NULL,
		@c25 int = NULL,
		@c26 int = NULL,
		@c27 int = NULL,
		@c28 int = NULL,
		@c29 int = NULL,
		@c30 nvarchar(10) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cfgMembership] set
		[MembershipID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [MembershipID] end,
		[MembershipSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipSortOrder] end,
		[MembershipDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipDescription] end,
		[MembershipDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MembershipDescriptionShort] end,
		[BusinessSegmentID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BusinessSegmentID] end,
		[RevenueGroupID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RevenueGroupID] end,
		[GenderID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [GenderID] end,
		[DurationMonths] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [DurationMonths] end,
		[ContractPrice] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ContractPrice] end,
		[MonthlyFee] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [MonthlyFee] end,
		[IsTaxableFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsTaxableFlag] end,
		[IsDefaultMembershipFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsDefaultMembershipFlag] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [UpdateStamp] end,
		[IsHairSystemOrderRushFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsHairSystemOrderRushFlag] end,
		[HairSystemGeneralLedgerID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [HairSystemGeneralLedgerID] end,
		[DefaultPaymentSalesCodeID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [DefaultPaymentSalesCodeID] end,
		[NumRenewalDays] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [NumRenewalDays] end,
		[NumDaysAfterCancelBeforeNew] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [NumDaysAfterCancelBeforeNew] end,
		[CanCheckinForConsultation] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CanCheckinForConsultation] end,
		[MaximumHairSystemHairLengthValue] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MaximumHairSystemHairLengthValue] end,
		[ExpectedConversionDays] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ExpectedConversionDays] end,
		[MinimumAge] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [MinimumAge] end,
		[MaximumAge] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [MaximumAge] end,
		[MaximumLongHairAddOnHairLengthValue] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [MaximumLongHairAddOnHairLengthValue] end,
		[BOSSalesTypeCode] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [BOSSalesTypeCode] end
	where [MembershipID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[cfgMembership] set
		[MembershipSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipSortOrder] end,
		[MembershipDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipDescription] end,
		[MembershipDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MembershipDescriptionShort] end,
		[BusinessSegmentID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BusinessSegmentID] end,
		[RevenueGroupID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RevenueGroupID] end,
		[GenderID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [GenderID] end,
		[DurationMonths] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [DurationMonths] end,
		[ContractPrice] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ContractPrice] end,
		[MonthlyFee] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [MonthlyFee] end,
		[IsTaxableFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsTaxableFlag] end,
		[IsDefaultMembershipFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsDefaultMembershipFlag] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [UpdateStamp] end,
		[IsHairSystemOrderRushFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsHairSystemOrderRushFlag] end,
		[HairSystemGeneralLedgerID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [HairSystemGeneralLedgerID] end,
		[DefaultPaymentSalesCodeID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [DefaultPaymentSalesCodeID] end,
		[NumRenewalDays] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [NumRenewalDays] end,
		[NumDaysAfterCancelBeforeNew] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [NumDaysAfterCancelBeforeNew] end,
		[CanCheckinForConsultation] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CanCheckinForConsultation] end,
		[MaximumHairSystemHairLengthValue] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MaximumHairSystemHairLengthValue] end,
		[ExpectedConversionDays] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ExpectedConversionDays] end,
		[MinimumAge] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [MinimumAge] end,
		[MaximumAge] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [MaximumAge] end,
		[MaximumLongHairAddOnHairLengthValue] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [MaximumLongHairAddOnHairLengthValue] end,
		[BOSSalesTypeCode] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [BOSSalesTypeCode] end
	where [MembershipID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
