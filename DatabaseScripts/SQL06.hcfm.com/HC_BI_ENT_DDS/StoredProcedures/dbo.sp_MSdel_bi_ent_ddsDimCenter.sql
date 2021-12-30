/* CreateDate: 01/08/2021 15:21:53.497 , ModifyDate: 01/08/2021 15:21:53.497 */
GO
create procedure [sp_MSdel_bi_ent_ddsDimCenter]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bi_ent_dds].[DimCenter]
	where [CenterKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimCenter]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
