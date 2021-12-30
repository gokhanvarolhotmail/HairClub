/* CreateDate: 05/05/2020 17:42:55.683 , ModifyDate: 05/05/2020 17:42:55.683 */
GO
create procedure [dbo].[sp_MSupd_dbodatSerializedInventoryAuditBatch]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 datetime = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 bit = NULL,
		@c8 datetime = NULL,
		@c9 uniqueidentifier = NULL,
		@c10 bit = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datSerializedInventoryAuditBatch] set
		[SerializedInventoryAuditBatchID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SerializedInventoryAuditBatchID] end,
		[SerializedInventoryAuditSnapshotID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SerializedInventoryAuditSnapshotID] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[InventoryAuditBatchStatusID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InventoryAuditBatchStatusID] end,
		[CompleteDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CompleteDate] end,
		[CompletedByEmployeeGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CompletedByEmployeeGUID] end,
		[IsReviewCompleted] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsReviewCompleted] end,
		[ReviewCompleteDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ReviewCompleteDate] end,
		[ReviewCompletedByEmployeeGUID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ReviewCompletedByEmployeeGUID] end,
		[IsAdjustmentCompleted] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsAdjustmentCompleted] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [UpdateStamp] end
	where [SerializedInventoryAuditBatchID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SerializedInventoryAuditBatchID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSerializedInventoryAuditBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datSerializedInventoryAuditBatch] set
		[SerializedInventoryAuditSnapshotID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SerializedInventoryAuditSnapshotID] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[InventoryAuditBatchStatusID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InventoryAuditBatchStatusID] end,
		[CompleteDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CompleteDate] end,
		[CompletedByEmployeeGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CompletedByEmployeeGUID] end,
		[IsReviewCompleted] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsReviewCompleted] end,
		[ReviewCompleteDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ReviewCompleteDate] end,
		[ReviewCompletedByEmployeeGUID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ReviewCompletedByEmployeeGUID] end,
		[IsAdjustmentCompleted] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsAdjustmentCompleted] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [UpdateStamp] end
	where [SerializedInventoryAuditBatchID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SerializedInventoryAuditBatchID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSerializedInventoryAuditBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
