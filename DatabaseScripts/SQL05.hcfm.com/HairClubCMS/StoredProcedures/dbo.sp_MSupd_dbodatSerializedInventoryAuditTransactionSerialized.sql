/* CreateDate: 05/05/2020 17:42:55.783 , ModifyDate: 05/05/2020 17:42:55.783 */
GO
create procedure [dbo].[sp_MSupd_dbodatSerializedInventoryAuditTransactionSerialized]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 bit = NULL,
		@c5 int = NULL,
		@c6 nvarchar(200) = NULL,
		@c7 int = NULL,
		@c8 nvarchar(200) = NULL,
		@c9 bit = NULL,
		@c10 datetime = NULL,
		@c11 uniqueidentifier = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 bit = NULL,
		@c15 int = NULL,
		@c16 bit = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datSerializedInventoryAuditTransactionSerialized] set
		[SerializedInventoryAuditTransactionSerializedID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SerializedInventoryAuditTransactionSerializedID] end,
		[SerializedInventoryAuditTransactionID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SerializedInventoryAuditTransactionID] end,
		[SerialNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SerialNumber] end,
		[IsInTransit] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsInTransit] end,
		[SerializedInventoryStatusID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SerializedInventoryStatusID] end,
		[ExclusionReason] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ExclusionReason] end,
		[InventoryNotScannedReasonID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [InventoryNotScannedReasonID] end,
		[InventoryNotScannedNote] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [InventoryNotScannedNote] end,
		[IsScannedEntry] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsScannedEntry] end,
		[ScannedDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ScannedDate] end,
		[ScannedEmployeeGUID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ScannedEmployeeGUID] end,
		[ScannedCenterID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ScannedCenterID] end,
		[ScannedSerializedInventoryAuditBatchID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ScannedSerializedInventoryAuditBatchID] end,
		[DeviceAddedAfterSnapshotTaken] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [DeviceAddedAfterSnapshotTaken] end,
		[InventoryAdjustmentIdAtTimeOfSnapshot] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [InventoryAdjustmentIdAtTimeOfSnapshot] end,
		[IsExcludedFromCorrections] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsExcludedFromCorrections] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [UpdateStamp] end
	where [SerializedInventoryAuditTransactionSerializedID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SerializedInventoryAuditTransactionSerializedID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSerializedInventoryAuditTransactionSerialized]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datSerializedInventoryAuditTransactionSerialized] set
		[SerializedInventoryAuditTransactionID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SerializedInventoryAuditTransactionID] end,
		[SerialNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SerialNumber] end,
		[IsInTransit] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsInTransit] end,
		[SerializedInventoryStatusID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SerializedInventoryStatusID] end,
		[ExclusionReason] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ExclusionReason] end,
		[InventoryNotScannedReasonID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [InventoryNotScannedReasonID] end,
		[InventoryNotScannedNote] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [InventoryNotScannedNote] end,
		[IsScannedEntry] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsScannedEntry] end,
		[ScannedDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ScannedDate] end,
		[ScannedEmployeeGUID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ScannedEmployeeGUID] end,
		[ScannedCenterID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ScannedCenterID] end,
		[ScannedSerializedInventoryAuditBatchID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ScannedSerializedInventoryAuditBatchID] end,
		[DeviceAddedAfterSnapshotTaken] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [DeviceAddedAfterSnapshotTaken] end,
		[InventoryAdjustmentIdAtTimeOfSnapshot] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [InventoryAdjustmentIdAtTimeOfSnapshot] end,
		[IsExcludedFromCorrections] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsExcludedFromCorrections] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [UpdateStamp] end
	where [SerializedInventoryAuditTransactionSerializedID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SerializedInventoryAuditTransactionSerializedID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSerializedInventoryAuditTransactionSerialized]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
