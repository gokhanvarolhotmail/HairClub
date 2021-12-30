/* CreateDate: 03/08/2021 10:59:46.317 , ModifyDate: 03/08/2021 10:59:46.317 */
GO
create procedure [sp_MSdel_dbodatClient]     @pkc1 uniqueidentifier
as
begin   	declare @primarykey_text nvarchar(100) = '' 	delete [dbo].[datClient]
	where [ClientGUID] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClient]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end    --
GO
