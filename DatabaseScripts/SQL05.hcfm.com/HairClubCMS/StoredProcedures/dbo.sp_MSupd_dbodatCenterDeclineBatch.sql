/* CreateDate: 05/05/2020 17:42:46.970 , ModifyDate: 05/05/2020 17:42:46.970 */
GO
create procedure [sp_MSupd_dbodatCenterDeclineBatch]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 datetime = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 bit = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(25) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datCenterDeclineBatch] set
		[CenterDeclineBatchGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CenterDeclineBatchGUID] end,
		[CenterFeeBatchGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterFeeBatchGUID] end,
		[RunDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RunDate] end,
		[RunByEmployeeGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RunByEmployeeGUID] end,
		[IsCompletedFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsCompletedFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[IsExported] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsExported] end,
		[CenterDeclineBatchStatusID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CenterDeclineBatchStatusID] end
	where [CenterDeclineBatchGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterDeclineBatchGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCenterDeclineBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datCenterDeclineBatch] set
		[CenterFeeBatchGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterFeeBatchGUID] end,
		[RunDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RunDate] end,
		[RunByEmployeeGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RunByEmployeeGUID] end,
		[IsCompletedFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsCompletedFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[IsExported] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsExported] end,
		[CenterDeclineBatchStatusID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CenterDeclineBatchStatusID] end
	where [CenterDeclineBatchGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterDeclineBatchGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCenterDeclineBatch]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
