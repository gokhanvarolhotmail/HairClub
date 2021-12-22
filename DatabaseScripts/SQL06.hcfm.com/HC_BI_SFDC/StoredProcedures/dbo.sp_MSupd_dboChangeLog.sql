/* CreateDate: 10/04/2019 14:09:30.270 , ModifyDate: 10/04/2019 14:09:30.270 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dboChangeLog]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 nvarchar(80) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(80) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[ChangeLog] set
		[SessionID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SessionID] end,
		[ObjectName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ObjectName] end,
		[ObjectKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ObjectKey] end,
		[ColumnName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ColumnName] end,
		[OldValue] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [OldValue] end,
		[NewValue] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [NewValue] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end
	where [ChangeLogID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ChangeLogID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ChangeLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
