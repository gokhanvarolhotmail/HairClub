/* CreateDate: 05/05/2020 17:42:42.583 , ModifyDate: 05/05/2020 17:42:42.583 */
GO
create procedure [sp_MSupd_dbocfgHairSystemCenterContractPricing]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 money = NULL,
		@c6 bit = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 money = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@c16 money = NULL,
		@c17 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgHairSystemCenterContractPricing] set
		[HairSystemCenterContractID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemCenterContractID] end,
		[HairSystemID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemID] end,
		[HairSystemHairLengthID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemHairLengthID] end,
		[HairSystemPrice] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemPrice] end,
		[IsContractPriceInActive] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsContractPriceInActive] end,
		[CreateDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdateUser] end,
		[HairSystemAreaRangeBegin] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [HairSystemAreaRangeBegin] end,
		[HairSystemAreaRangeEnd] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [HairSystemAreaRangeEnd] end,
		[AddOnSignatureHairlinePrice] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [AddOnSignatureHairlinePrice] end,
		[AddOnExtendedLacePrice] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [AddOnExtendedLacePrice] end,
		[AddOnOmbrePrice] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [AddOnOmbrePrice] end,
		[AddOnCuticleIntactHairPrice] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AddOnCuticleIntactHairPrice] end,
		[AddOnRootShadowingPrice] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AddOnRootShadowingPrice] end
	where [HairSystemCenterContractPricingID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemCenterContractPricingID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgHairSystemCenterContractPricing]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
