/* CreateDate: 05/05/2020 17:42:38.453 , ModifyDate: 05/05/2020 17:42:38.453 */
GO
create procedure [sp_MSdel_dbocfgActiveDirectoryGroupJoin]
		@pkc1 int,
		@pkc2 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[cfgActiveDirectoryGroupJoin]
	where [ActiveDirectoryGroupID] = @pkc1
  and [EmployeePositionID] = @pkc2
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActiveDirectoryGroupID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[EmployeePositionID] = ' + convert(nvarchar(100),@pkc2,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgActiveDirectoryGroupJoin]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
