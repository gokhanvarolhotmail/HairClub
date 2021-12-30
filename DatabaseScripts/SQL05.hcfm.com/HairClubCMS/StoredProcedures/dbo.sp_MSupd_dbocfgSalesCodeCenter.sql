/* CreateDate: 05/05/2020 17:42:44.750 , ModifyDate: 05/05/2020 17:42:44.750 */
GO
create procedure [sp_MSupd_dbocfgSalesCodeCenter]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 money = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 bit = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 int = NULL,
		@c15 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgSalesCodeCenter] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[SalesCodeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesCodeID] end,
		[PriceRetail] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [PriceRetail] end,
		[TaxRate1ID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [TaxRate1ID] end,
		[TaxRate2ID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [TaxRate2ID] end,
		[QuantityMaxLevel] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [QuantityMaxLevel] end,
		[QuantityMinLevel] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [QuantityMinLevel] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[AgreementID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [AgreementID] end,
		[CenterCost] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CenterCost] end
	where [SalesCodeCenterID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesCodeCenterID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgSalesCodeCenter]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
