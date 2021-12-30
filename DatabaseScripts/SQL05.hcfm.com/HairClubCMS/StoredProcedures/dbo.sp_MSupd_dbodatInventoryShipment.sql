/* CreateDate: 05/05/2020 17:42:46.687 , ModifyDate: 05/05/2020 17:42:46.687 */
GO
create procedure [sp_MSupd_dbodatInventoryShipment]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 datetime = NULL,
		@c10 datetime = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 money = NULL,
		@c14 int = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 int = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 money = NULL,
		@c22 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datInventoryShipment] set
		[InventoryShipmentGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [InventoryShipmentGUID] end,
		[InventoryShipmentTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [InventoryShipmentTypeID] end,
		[InventoryShipmentStatusID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [InventoryShipmentStatusID] end,
		[ShipFromVendorID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ShipFromVendorID] end,
		[ShipFromCenterID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ShipFromCenterID] end,
		[ShipToVendorID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ShipToVendorID] end,
		[ShipToCenterID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ShipToCenterID] end,
		[ShipDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ShipDate] end,
		[ReceiveDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ReceiveDate] end,
		[CloseDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CloseDate] end,
		[InvoiceNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InvoiceNumber] end,
		[InvoiceTotal] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [InvoiceTotal] end,
		[InvoiceCount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [InvoiceCount] end,
		[TrackingNumber] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [TrackingNumber] end,
		[ShipmentMethodID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ShipmentMethodID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[InvoiceActualTotal] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [InvoiceActualTotal] end,
		[InvoiceActualCount] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InvoiceActualCount] end
	where [InventoryShipmentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[InventoryShipmentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datInventoryShipment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datInventoryShipment] set
		[InventoryShipmentTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [InventoryShipmentTypeID] end,
		[InventoryShipmentStatusID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [InventoryShipmentStatusID] end,
		[ShipFromVendorID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ShipFromVendorID] end,
		[ShipFromCenterID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ShipFromCenterID] end,
		[ShipToVendorID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ShipToVendorID] end,
		[ShipToCenterID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ShipToCenterID] end,
		[ShipDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ShipDate] end,
		[ReceiveDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ReceiveDate] end,
		[CloseDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CloseDate] end,
		[InvoiceNumber] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InvoiceNumber] end,
		[InvoiceTotal] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [InvoiceTotal] end,
		[InvoiceCount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [InvoiceCount] end,
		[TrackingNumber] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [TrackingNumber] end,
		[ShipmentMethodID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ShipmentMethodID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[InvoiceActualTotal] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [InvoiceActualTotal] end,
		[InvoiceActualCount] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InvoiceActualCount] end
	where [InventoryShipmentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[InventoryShipmentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datInventoryShipment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
