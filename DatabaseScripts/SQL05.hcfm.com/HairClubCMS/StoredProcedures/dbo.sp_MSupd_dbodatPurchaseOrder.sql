/* CreateDate: 05/05/2020 17:42:50.733 , ModifyDate: 05/05/2020 17:42:50.733 */
GO
create procedure [sp_MSupd_dbodatPurchaseOrder]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 money = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datPurchaseOrder] set
		[PurchaseOrderGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [PurchaseOrderGUID] end,
		[VendorID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VendorID] end,
		[PurchaseOrderDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PurchaseOrderDate] end,
		[PurchaseOrderTotal] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [PurchaseOrderTotal] end,
		[PurchaseOrderCount] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PurchaseOrderCount] end,
		[PurchaseOrderStatusID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PurchaseOrderStatusID] end,
		[HairSystemAllocationGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HairSystemAllocationGUID] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end,
		[PurchaseOrderTypeID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PurchaseOrderTypeID] end,
		[PurchaseOrderNumberOriginal] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PurchaseOrderNumberOriginal] end
	where [PurchaseOrderGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[PurchaseOrderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datPurchaseOrder]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datPurchaseOrder] set
		[VendorID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VendorID] end,
		[PurchaseOrderDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PurchaseOrderDate] end,
		[PurchaseOrderTotal] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [PurchaseOrderTotal] end,
		[PurchaseOrderCount] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PurchaseOrderCount] end,
		[PurchaseOrderStatusID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PurchaseOrderStatusID] end,
		[HairSystemAllocationGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HairSystemAllocationGUID] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end,
		[PurchaseOrderTypeID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PurchaseOrderTypeID] end,
		[PurchaseOrderNumberOriginal] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PurchaseOrderNumberOriginal] end
	where [PurchaseOrderGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[PurchaseOrderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datPurchaseOrder]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
