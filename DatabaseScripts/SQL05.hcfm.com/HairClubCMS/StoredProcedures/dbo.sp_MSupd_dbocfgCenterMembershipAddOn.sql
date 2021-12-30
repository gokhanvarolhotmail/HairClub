/* CreateDate: 05/05/2020 17:42:40.490 , ModifyDate: 05/05/2020 17:42:40.490 */
GO
create procedure [dbo].[sp_MSupd_dbocfgCenterMembershipAddOn]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 bit = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 binary(8) = NULL,
		@c10 money = NULL,
		@c11 money = NULL,
		@c12 money = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgCenterMembershipAddOn] set
		[CenterMembershipID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterMembershipID] end,
		[AddOnID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AddOnID] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UpdateStamp] end,
		[PriceDefault] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PriceDefault] end,
		[PriceMinimum] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PriceMinimum] end,
		[PriceMaximum] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PriceMaximum] end,
		[QuantityMinimum] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [QuantityMinimum] end,
		[QuantityMaximum] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [QuantityMaximum] end,
		[PaymentSalesCodeID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PaymentSalesCodeID] end,
		[MonthlyFeeSalesCodeID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [MonthlyFeeSalesCodeID] end,
		[AgreementID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AgreementID] end,
		[QuantityIntervalMultiplier] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [QuantityIntervalMultiplier] end,
		[ValuationPrice] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ValuationPrice] end
	where [CenterMembershipAddOnID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterMembershipAddOnID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgCenterMembershipAddOn]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
