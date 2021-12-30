/* CreateDate: 05/05/2020 17:42:45.523 , ModifyDate: 05/05/2020 17:42:45.523 */
GO
create procedure [sp_MSupd_dbodatAccountingExportBatch]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 datetime = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(200) = NULL,
		@c9 money = NULL,
		@c10 money = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datAccountingExportBatch] set
		[AccountingExportBatchGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AccountingExportBatchGUID] end,
		[AccountingExportBatchTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccountingExportBatchTypeID] end,
		[AccountingExportBatchNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccountingExportBatchNumber] end,
		[BatchRunDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [BatchRunDate] end,
		[BatchBeginDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BatchBeginDate] end,
		[BatchEndDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BatchEndDate] end,
		[BatchInvoiceDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [BatchInvoiceDate] end,
		[ExportFileName] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ExportFileName] end,
		[InvoiceAmount] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [InvoiceAmount] end,
		[FreightAmount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [FreightAmount] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end
	where [AccountingExportBatchGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountingExportBatchGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccountingExportBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datAccountingExportBatch] set
		[AccountingExportBatchTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccountingExportBatchTypeID] end,
		[AccountingExportBatchNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccountingExportBatchNumber] end,
		[BatchRunDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [BatchRunDate] end,
		[BatchBeginDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BatchBeginDate] end,
		[BatchEndDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BatchEndDate] end,
		[BatchInvoiceDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [BatchInvoiceDate] end,
		[ExportFileName] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ExportFileName] end,
		[InvoiceAmount] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [InvoiceAmount] end,
		[FreightAmount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [FreightAmount] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end
	where [AccountingExportBatchGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountingExportBatchGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccountingExportBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
