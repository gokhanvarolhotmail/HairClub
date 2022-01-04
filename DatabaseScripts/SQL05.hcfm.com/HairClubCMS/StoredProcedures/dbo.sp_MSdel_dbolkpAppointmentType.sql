/* CreateDate: 05/05/2020 17:42:47.133 , ModifyDate: 05/05/2020 17:42:47.133 */
GO
create procedure [sp_MSdel_dbolkpAppointmentType]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[lkpAppointmentType]
	where [AppointmentTypeID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentTypeID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpAppointmentType]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO