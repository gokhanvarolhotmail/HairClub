create procedure [sp_MSdel_bief_dds_DBVersion]
		@pkc1 int,
		@pkc2 int,
		@pkc3 int,
		@pkc4 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bief_dds].[_DBVersion]
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
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBVersion]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
