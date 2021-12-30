/* CreateDate: 05/05/2020 17:42:45.650 , ModifyDate: 05/05/2020 17:42:45.650 */
GO
create procedure [dbo].[sp_MSupd_dbocfgHairSystemVendorContractPricing]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 decimal(23,8) = NULL,
		@c6 decimal(23,8) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 binary(8) = NULL,
		@c13 bit = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@c16 money = NULL,
		@c17 money = NULL,
		@c18 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cfgHairSystemVendorContractPricing] set
		[HairSystemVendorContractPricingID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemVendorContractPricingID] end,
		[HairSystemVendorContractID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemVendorContractID] end,
		[HairSystemHairLengthID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemHairLengthID] end,
		[HairSystemHairCapID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemHairCapID] end,
		[HairSystemAreaRangeBegin] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemAreaRangeBegin] end,
		[HairSystemAreaRangeEnd] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairSystemAreaRangeEnd] end,
		[HairSystemCost] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemCost] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateStamp] end,
		[IsContractPriceInActive] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsContractPriceInActive] end,
		[AddOnSignatureHairlineCost] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [AddOnSignatureHairlineCost] end,
		[AddOnExtendedLaceCost] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [AddOnExtendedLaceCost] end,
		[AddOnOmbreCost] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AddOnOmbreCost] end,
		[AddOnCuticleIntactHairCost] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AddOnCuticleIntactHairCost] end,
		[AddOnRootShadowCost] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [AddOnRootShadowCost] end
	where [HairSystemVendorContractPricingID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemVendorContractPricingID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgHairSystemVendorContractPricing]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[cfgHairSystemVendorContractPricing] set
		[HairSystemVendorContractID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemVendorContractID] end,
		[HairSystemHairLengthID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemHairLengthID] end,
		[HairSystemHairCapID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemHairCapID] end,
		[HairSystemAreaRangeBegin] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemAreaRangeBegin] end,
		[HairSystemAreaRangeEnd] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairSystemAreaRangeEnd] end,
		[HairSystemCost] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemCost] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateStamp] end,
		[IsContractPriceInActive] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsContractPriceInActive] end,
		[AddOnSignatureHairlineCost] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [AddOnSignatureHairlineCost] end,
		[AddOnExtendedLaceCost] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [AddOnExtendedLaceCost] end,
		[AddOnOmbreCost] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AddOnOmbreCost] end,
		[AddOnCuticleIntactHairCost] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AddOnCuticleIntactHairCost] end,
		[AddOnRootShadowCost] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [AddOnRootShadowCost] end
	where [HairSystemVendorContractPricingID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemVendorContractPricingID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgHairSystemVendorContractPricing]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
