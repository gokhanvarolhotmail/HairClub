/* CreateDate: 10/03/2019 23:03:40.703 , ModifyDate: 10/03/2019 23:03:40.703 */
GO
create procedure [sp_MSdel_bi_cms_ddsDimHairSystemHairColor]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bi_cms_dds].[DimHairSystemHairColor]
	where [HairSystemHairColorKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemHairColorKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimHairSystemHairColor]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
