/* CreateDate: 05/05/2020 17:42:47.397 , ModifyDate: 05/05/2020 17:42:47.397 */
GO
create procedure [sp_MSupd_dbodatEndOfDay]
		@c1 uniqueidentifier = NULL,
		@c2 datetime = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 varchar(25) = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 datetime = NULL,
		@c8 bit = NULL,
		@c9 text = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datEndOfDay] set
		[EndOfDayGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [EndOfDayGUID] end,
		[EndOfDayDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EndOfDayDate] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[DepositID_Temp] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DepositID_Temp] end,
		[DepositNumber] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [DepositNumber] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EmployeeGUID] end,
		[CloseDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CloseDate] end,
		[IsExportedToQuickBooks] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsExportedToQuickBooks] end,
		[CloseNote] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CloseNote] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end
	where [EndOfDayGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EndOfDayGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datEndOfDay]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datEndOfDay] set
		[EndOfDayDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EndOfDayDate] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[DepositID_Temp] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DepositID_Temp] end,
		[DepositNumber] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [DepositNumber] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EmployeeGUID] end,
		[CloseDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CloseDate] end,
		[IsExportedToQuickBooks] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsExportedToQuickBooks] end,
		[CloseNote] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CloseNote] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end
	where [EndOfDayGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EndOfDayGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datEndOfDay]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
