/* CreateDate: 01/08/2021 15:21:53.667 , ModifyDate: 01/08/2021 15:21:53.667 */
GO
create procedure [sp_MSdel_bief_ddsDimDate_TEMP]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bief_dds].[DimDate_TEMP]
	where [DateKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[DimDate_TEMP]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
