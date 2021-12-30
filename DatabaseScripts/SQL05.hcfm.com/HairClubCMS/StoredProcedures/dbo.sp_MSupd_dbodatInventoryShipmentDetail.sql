/* CreateDate: 05/05/2020 17:42:50.593 , ModifyDate: 05/05/2020 17:42:50.593 */
GO
create procedure [sp_MSupd_dbodatInventoryShipmentDetail]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 int = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(25) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 int = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datInventoryShipmentDetail] set
		[InventoryShipmentDetailGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [InventoryShipmentDetailGUID] end,
		[InventoryShipmentGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [InventoryShipmentGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderGUID] end,
		[InventoryShipmentDetailStatusID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InventoryShipmentDetailStatusID] end,
		[InventoryTransferRequestGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [InventoryTransferRequestGUID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[InventoryShipmentReasonID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InventoryShipmentReasonID] end,
		[PriorityTransferFee] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PriorityTransferFee] end,
		[PriorityHairSystemCenterContractPricingID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PriorityHairSystemCenterContractPricingID] end
	where [InventoryShipmentDetailGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[InventoryShipmentDetailGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datInventoryShipmentDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datInventoryShipmentDetail] set
		[InventoryShipmentGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [InventoryShipmentGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderGUID] end,
		[InventoryShipmentDetailStatusID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InventoryShipmentDetailStatusID] end,
		[InventoryTransferRequestGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [InventoryTransferRequestGUID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[InventoryShipmentReasonID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InventoryShipmentReasonID] end,
		[PriorityTransferFee] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PriorityTransferFee] end,
		[PriorityHairSystemCenterContractPricingID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PriorityHairSystemCenterContractPricingID] end
	where [InventoryShipmentDetailGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[InventoryShipmentDetailGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datInventoryShipmentDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
