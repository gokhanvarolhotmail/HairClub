/* CreateDate: 05/05/2020 17:42:38.723 , ModifyDate: 05/05/2020 17:42:38.723 */
GO
create procedure [sp_MSdel_dbocfgAppointmentManagementConfiguration]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[cfgAppointmentManagementConfiguration]
	where [AppointmentManagementConfigurationID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentManagementConfigurationID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgAppointmentManagementConfiguration]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
