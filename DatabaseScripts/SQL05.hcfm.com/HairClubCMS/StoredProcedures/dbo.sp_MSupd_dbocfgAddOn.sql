/* CreateDate: 05/05/2020 17:42:38.550 , ModifyDate: 05/05/2020 17:42:38.550 */
GO
create procedure [dbo].[sp_MSupd_dbocfgAddOn]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 money = NULL,
		@c7 money = NULL,
		@c8 money = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 bit = NULL,
		@c12 bit = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 binary(8) = NULL,
		@c18 bit = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 bit = NULL,
		@c22 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgAddOn] set
		[AddOnSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AddOnSortOrder] end,
		[AddOnDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AddOnDescription] end,
		[AddOnDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AddOnDescriptionShort] end,
		[AddOnTypeID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AddOnTypeID] end,
		[PriceDefault] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PriceDefault] end,
		[PriceMinimum] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PriceMinimum] end,
		[PriceMaximum] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [PriceMaximum] end,
		[QuantityMinimum] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [QuantityMinimum] end,
		[QuantityMaximum] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [QuantityMaximum] end,
		[CarryOverToNewMembership] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CarryOverToNewMembership] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [UpdateStamp] end,
		[IsMultipleAddAllowed] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsMultipleAddAllowed] end,
		[PaymentSalesCodeID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [PaymentSalesCodeID] end,
		[MonthlyFeeSalesCodeID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [MonthlyFeeSalesCodeID] end,
		[CarryOverRemainingBenefitsToNewMembership] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CarryOverRemainingBenefitsToNewMembership] end,
		[QuantityIntervalMultiplier] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [QuantityIntervalMultiplier] end
	where [AddOnID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AddOnID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgAddOn]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
