/* CreateDate: 05/05/2020 17:42:49.327 , ModifyDate: 05/05/2020 17:42:49.327 */
GO
create procedure [sp_MSdel_dbodatClientMembershipAccum]
		@pkc1 uniqueidentifier
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[datClientMembershipAccum]
	where [ClientMembershipAccumGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipAccumGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientMembershipAccum]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
