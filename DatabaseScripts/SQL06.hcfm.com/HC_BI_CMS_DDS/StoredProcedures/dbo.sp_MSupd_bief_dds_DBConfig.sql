/* CreateDate: 03/17/2022 11:57:03.493 , ModifyDate: 03/17/2022 11:57:03.493 */
GO
create procedure [sp_MSupd_bief_dds_DBConfig]
		@c1 int = NULL,
		@c2 varchar(max) = NULL,
		@c3 bit = NULL,
		@c4 int = NULL,
		@c5 varchar(max) = NULL,
		@c6 datetime = NULL,
		@c7 decimal(18,4) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bief_dds].[_DBConfig] set
		[setting_key] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [setting_key] end,
		[setting_name] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [setting_name] end,
		[setting_value_bit] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [setting_value_bit] end,
		[setting_value_int] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [setting_value_int] end,
		[setting_value_varchar] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [setting_value_varchar] end,
		[setting_value_datatime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [setting_value_datatime] end,
		[setting_value_decimal] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [setting_value_decimal] end
	where [setting_key] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[setting_key] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBConfig]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bief_dds].[_DBConfig] set
		[setting_name] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [setting_name] end,
		[setting_value_bit] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [setting_value_bit] end,
		[setting_value_int] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [setting_value_int] end,
		[setting_value_varchar] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [setting_value_varchar] end,
		[setting_value_datatime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [setting_value_datatime] end,
		[setting_value_decimal] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [setting_value_decimal] end
	where [setting_key] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[setting_key] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBConfig]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
