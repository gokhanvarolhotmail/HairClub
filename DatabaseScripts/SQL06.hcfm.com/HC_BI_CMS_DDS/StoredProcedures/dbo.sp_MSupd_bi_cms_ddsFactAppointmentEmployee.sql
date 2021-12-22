/* CreateDate: 10/03/2019 23:03:42.197 , ModifyDate: 10/03/2019 23:03:42.197 */
GO
create procedure [sp_MSupd_bi_cms_ddsFactAppointmentEmployee]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[FactAppointmentEmployee] set
		[AppointmentKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentKey] end,
		[EmployeeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeKey] end,
		[InsertAuditKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [msrepl_tran_version] end,
		[AppointmentEmployeeSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AppointmentEmployeeSSID] end
	where [AppointmentEmployeeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentEmployeeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[FactAppointmentEmployee]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
