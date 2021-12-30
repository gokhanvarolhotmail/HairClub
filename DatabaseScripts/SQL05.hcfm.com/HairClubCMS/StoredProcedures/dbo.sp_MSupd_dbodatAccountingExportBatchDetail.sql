/* CreateDate: 05/05/2020 17:42:46.743 , ModifyDate: 05/05/2020 17:42:46.743 */
GO
create procedure [sp_MSupd_dbodatAccountingExportBatchDetail]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 money = NULL,
		@c10 uniqueidentifier = NULL,
		@c11 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datAccountingExportBatchDetail] set
		[AccountingExportBatchDetailGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AccountingExportBatchDetailGUID] end,
		[AccountingExportBatchGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccountingExportBatchGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderGUID] end,
		[HairSystemOrderTransactionGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderTransactionGUID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end,
		[FreightAmount] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [FreightAmount] end,
		[InventoryShipmentGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InventoryShipmentGUID] end,
		[CenterID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CenterID] end
	where [AccountingExportBatchDetailGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountingExportBatchDetailGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccountingExportBatchDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datAccountingExportBatchDetail] set
		[AccountingExportBatchGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccountingExportBatchGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderGUID] end,
		[HairSystemOrderTransactionGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderTransactionGUID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end,
		[FreightAmount] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [FreightAmount] end,
		[InventoryShipmentGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InventoryShipmentGUID] end,
		[CenterID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CenterID] end
	where [AccountingExportBatchDetailGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountingExportBatchDetailGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccountingExportBatchDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
