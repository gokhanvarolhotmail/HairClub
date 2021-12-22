/* CreateDate: 10/03/2019 23:03:39.677 , ModifyDate: 10/03/2019 23:03:39.677 */
GO
create procedure [sp_MSupd_bief_dds_DBVersion]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 datetime = NULL,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@pkc3 int = NULL,
		@pkc4 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 4 = 4) or
 (substring(@bitmap,1,1) & 8 = 8)
begin
update [bief_dds].[_DBVersion] set
		[DBVersionMajor] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [DBVersionMajor] end,
		[DBVersionMinor] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [DBVersionMinor] end,
		[DBVersionBuild] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [DBVersionBuild] end,
		[DBVersionRevision] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DBVersionRevision] end,
		[RowUpdateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [RowUpdateDate] end
	where [DBVersionMajor] = @pkc1
  and [DBVersionMinor] = @pkc2
  and [DBVersionBuild] = @pkc3
  and [DBVersionRevision] = @pkc4
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DBVersionMajor] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[DBVersionMinor] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[DBVersionBuild] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[DBVersionRevision] = ' + convert(nvarchar(100),@pkc4,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBVersion]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bief_dds].[_DBVersion] set
		[RowUpdateDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [RowUpdateDate] end
	where [DBVersionMajor] = @pkc1
  and [DBVersionMinor] = @pkc2
  and [DBVersionBuild] = @pkc3
  and [DBVersionRevision] = @pkc4
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DBVersionMajor] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[DBVersionMinor] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[DBVersionBuild] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[DBVersionRevision] = ' + convert(nvarchar(100),@pkc4,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBVersion]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
