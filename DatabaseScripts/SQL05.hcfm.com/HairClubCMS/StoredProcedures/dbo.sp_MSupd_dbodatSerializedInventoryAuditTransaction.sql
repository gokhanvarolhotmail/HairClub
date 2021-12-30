/* CreateDate: 05/05/2020 17:42:55.733 , ModifyDate: 05/05/2020 17:42:55.733 */
GO
create procedure [dbo].[sp_MSupd_dbodatSerializedInventoryAuditTransaction]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 bit = NULL,
		@c6 nvarchar(200) = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datSerializedInventoryAuditTransaction] set
		[SerializedInventoryAuditTransactionID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SerializedInventoryAuditTransactionID] end,
		[SerializedInventoryAuditBatchID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SerializedInventoryAuditBatchID] end,
		[SalesCodeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesCodeID] end,
		[QuantityExpected] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [QuantityExpected] end,
		[IsExcludedFromCorrections] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsExcludedFromCorrections] end,
		[ExclusionReason] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ExclusionReason] end,
		[CreateDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [UpdateStamp] end
	where [SerializedInventoryAuditTransactionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SerializedInventoryAuditTransactionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSerializedInventoryAuditTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datSerializedInventoryAuditTransaction] set
		[SerializedInventoryAuditBatchID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SerializedInventoryAuditBatchID] end,
		[SalesCodeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesCodeID] end,
		[QuantityExpected] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [QuantityExpected] end,
		[IsExcludedFromCorrections] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsExcludedFromCorrections] end,
		[ExclusionReason] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ExclusionReason] end,
		[CreateDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [UpdateStamp] end
	where [SerializedInventoryAuditTransactionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SerializedInventoryAuditTransactionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSerializedInventoryAuditTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
