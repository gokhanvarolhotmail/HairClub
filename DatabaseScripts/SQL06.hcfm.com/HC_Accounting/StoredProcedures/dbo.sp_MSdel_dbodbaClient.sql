/* CreateDate: 10/03/2019 22:32:11.937 , ModifyDate: 10/03/2019 22:32:11.937 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSdel_dbodbaClient]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[dbaClient]
	where [ClientID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[dbaClient]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
