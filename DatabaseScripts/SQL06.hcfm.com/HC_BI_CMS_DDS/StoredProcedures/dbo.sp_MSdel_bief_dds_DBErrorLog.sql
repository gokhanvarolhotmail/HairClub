/* CreateDate: 10/03/2019 23:03:39.553 , ModifyDate: 10/03/2019 23:03:39.553 */
GO
create procedure [sp_MSdel_bief_dds_DBErrorLog]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bief_dds].[_DBErrorLog]
	where [DBErrorLogID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DBErrorLogID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBErrorLog]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
