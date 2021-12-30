/* CreateDate: 05/05/2020 17:42:50.927 , ModifyDate: 05/05/2020 17:42:50.927 */
GO
create procedure [sp_MSupd_dbodatHairSystemOrderTransaction]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 datetime = NULL,
		@c7 int = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 int = NULL,
		@c10 uniqueidentifier = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 uniqueidentifier = NULL,
		@c14 uniqueidentifier = NULL,
		@c15 uniqueidentifier = NULL,
		@c16 money = NULL,
		@c17 money = NULL,
		@c18 money = NULL,
		@c19 money = NULL,
		@c20 money = NULL,
		@c21 money = NULL,
		@c22 uniqueidentifier = NULL,
		@c23 datetime = NULL,
		@c24 nvarchar(25) = NULL,
		@c25 datetime = NULL,
		@c26 nvarchar(25) = NULL,
		@c27 money = NULL,
		@c28 money = NULL,
		@c29 uniqueidentifier = NULL,
		@c30 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datHairSystemOrderTransaction] set
		[HairSystemOrderTransactionGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemOrderTransactionGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[ClientHomeCenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientHomeCenterID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientMembershipGUID] end,
		[HairSystemOrderTransactionDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairSystemOrderTransactionDate] end,
		[HairSystemOrderProcessID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemOrderProcessID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HairSystemOrderGUID] end,
		[PreviousCenterID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [PreviousCenterID] end,
		[PreviousClientMembershipGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PreviousClientMembershipGUID] end,
		[PreviousHairSystemOrderStatusID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PreviousHairSystemOrderStatusID] end,
		[NewHairSystemOrderStatusID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NewHairSystemOrderStatusID] end,
		[InventoryShipmentDetailGUID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [InventoryShipmentDetailGUID] end,
		[InventoryTransferRequestGUID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [InventoryTransferRequestGUID] end,
		[PurchaseOrderDetailGUID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PurchaseOrderDetailGUID] end,
		[CostContract] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CostContract] end,
		[PreviousCostContract] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PreviousCostContract] end,
		[CostActual] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CostActual] end,
		[PreviousCostActual] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [PreviousCostActual] end,
		[CenterPrice] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CenterPrice] end,
		[PreviousCenterPrice] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [PreviousCenterPrice] end,
		[EmployeeGUID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [EmployeeGUID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [LastUpdateUser] end,
		[CostFactoryShipped] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CostFactoryShipped] end,
		[PreviousCostFactoryShipped] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [PreviousCostFactoryShipped] end,
		[SalesOrderDetailGuid] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [SalesOrderDetailGuid] end,
		[HairSystemOrderPriorityReasonID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [HairSystemOrderPriorityReasonID] end
	where [HairSystemOrderTransactionGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderTransactionGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemOrderTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datHairSystemOrderTransaction] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[ClientHomeCenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientHomeCenterID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientMembershipGUID] end,
		[HairSystemOrderTransactionDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairSystemOrderTransactionDate] end,
		[HairSystemOrderProcessID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemOrderProcessID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HairSystemOrderGUID] end,
		[PreviousCenterID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [PreviousCenterID] end,
		[PreviousClientMembershipGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PreviousClientMembershipGUID] end,
		[PreviousHairSystemOrderStatusID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PreviousHairSystemOrderStatusID] end,
		[NewHairSystemOrderStatusID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NewHairSystemOrderStatusID] end,
		[InventoryShipmentDetailGUID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [InventoryShipmentDetailGUID] end,
		[InventoryTransferRequestGUID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [InventoryTransferRequestGUID] end,
		[PurchaseOrderDetailGUID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PurchaseOrderDetailGUID] end,
		[CostContract] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CostContract] end,
		[PreviousCostContract] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PreviousCostContract] end,
		[CostActual] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CostActual] end,
		[PreviousCostActual] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [PreviousCostActual] end,
		[CenterPrice] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CenterPrice] end,
		[PreviousCenterPrice] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [PreviousCenterPrice] end,
		[EmployeeGUID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [EmployeeGUID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [LastUpdateUser] end,
		[CostFactoryShipped] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CostFactoryShipped] end,
		[PreviousCostFactoryShipped] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [PreviousCostFactoryShipped] end,
		[SalesOrderDetailGuid] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [SalesOrderDetailGuid] end,
		[HairSystemOrderPriorityReasonID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [HairSystemOrderPriorityReasonID] end
	where [HairSystemOrderTransactionGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderTransactionGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemOrderTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
