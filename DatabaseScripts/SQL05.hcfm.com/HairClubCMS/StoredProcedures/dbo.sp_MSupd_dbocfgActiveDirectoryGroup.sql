/* CreateDate: 05/05/2020 17:42:38.320 , ModifyDate: 05/05/2020 17:42:38.320 */
GO
create procedure [sp_MSupd_dbocfgActiveDirectoryGroup]
		@c1 int = NULL,
		@c2 nvarchar(100) = NULL,
		@c3 datetime = NULL,
		@c4 nvarchar(25) = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgActiveDirectoryGroup] set
		[ActiveDirectoryGroup] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActiveDirectoryGroup] end,
		[CreateDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastUpdateUser] end
	where [ActiveDirectoryGroupID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActiveDirectoryGroupID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgActiveDirectoryGroup]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
