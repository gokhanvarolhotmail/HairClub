/* CreateDate: 01/08/2021 15:21:53.927 , ModifyDate: 01/08/2021 15:21:53.927 */
GO
create procedure [sp_MSdel_bi_ent_ddsDimMaritalStatus]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bi_ent_dds].[DimMaritalStatus]
	where [MaritalStatusKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MaritalStatusKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimMaritalStatus]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
