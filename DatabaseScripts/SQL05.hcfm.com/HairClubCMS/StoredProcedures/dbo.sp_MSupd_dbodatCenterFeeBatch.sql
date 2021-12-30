/* CreateDate: 05/05/2020 17:42:46.870 , ModifyDate: 05/05/2020 17:42:46.870 */
GO
create procedure [sp_MSupd_dbodatCenterFeeBatch]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 datetime = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 datetime = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 int = NULL,
		@c15 datetime = NULL,
		@c16 uniqueidentifier = NULL,
		@c17 bit = NULL,
		@c18 bit = NULL,
		@c19 bit = NULL,
		@c20 bit = NULL,
		@c21 bit = NULL,
		@c22 bit = NULL,
		@c23 bit = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datCenterFeeBatch] set
		[CenterFeeBatchGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CenterFeeBatchGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[FeePayCycleID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [FeePayCycleID] end,
		[FeeMonth] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [FeeMonth] end,
		[FeeYear] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FeeYear] end,
		[CenterFeeBatchStatusId] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterFeeBatchStatusId] end,
		[RunDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RunDate] end,
		[RunByEmployeeGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RunByEmployeeGUID] end,
		[DownloadDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DownloadDate] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[IsExported] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsExported] end,
		[ApprovedDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ApprovedDate] end,
		[ApprovedByEmployeeGUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ApprovedByEmployeeGUID] end,
		[AreSalesOrdersCreated] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AreSalesOrdersCreated] end,
		[IsMonetraProcessingCompleted] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsMonetraProcessingCompleted] end,
		[AreMonetraResultsProcessed] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [AreMonetraResultsProcessed] end,
		[IsACHFileCreated] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsACHFileCreated] end,
		[AreAccumulatorsExecuted] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [AreAccumulatorsExecuted] end,
		[AreARPaymentsApplied] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [AreARPaymentsApplied] end,
		[IsNACHAFileCreated] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsNACHAFileCreated] end
	where [CenterFeeBatchGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterFeeBatchGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCenterFeeBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datCenterFeeBatch] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[FeePayCycleID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [FeePayCycleID] end,
		[FeeMonth] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [FeeMonth] end,
		[FeeYear] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FeeYear] end,
		[CenterFeeBatchStatusId] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterFeeBatchStatusId] end,
		[RunDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RunDate] end,
		[RunByEmployeeGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RunByEmployeeGUID] end,
		[DownloadDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DownloadDate] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[IsExported] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsExported] end,
		[ApprovedDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ApprovedDate] end,
		[ApprovedByEmployeeGUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ApprovedByEmployeeGUID] end,
		[AreSalesOrdersCreated] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AreSalesOrdersCreated] end,
		[IsMonetraProcessingCompleted] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsMonetraProcessingCompleted] end,
		[AreMonetraResultsProcessed] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [AreMonetraResultsProcessed] end,
		[IsACHFileCreated] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsACHFileCreated] end,
		[AreAccumulatorsExecuted] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [AreAccumulatorsExecuted] end,
		[AreARPaymentsApplied] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [AreARPaymentsApplied] end,
		[IsNACHAFileCreated] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsNACHAFileCreated] end
	where [CenterFeeBatchGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterFeeBatchGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCenterFeeBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
