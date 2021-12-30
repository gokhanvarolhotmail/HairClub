/* CreateDate: 05/05/2020 17:42:41.447 , ModifyDate: 05/05/2020 17:42:41.447 */
GO
create procedure [sp_MSupd_dbocfgConfigurationCenterPC]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(200) = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgConfigurationCenterPC] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[PCName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PCName] end,
		[DefaultDirectory] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DefaultDirectory] end,
		[CreateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end
	where [ConfigurationCenterPCID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ConfigurationCenterPCID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgConfigurationCenterPC]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
