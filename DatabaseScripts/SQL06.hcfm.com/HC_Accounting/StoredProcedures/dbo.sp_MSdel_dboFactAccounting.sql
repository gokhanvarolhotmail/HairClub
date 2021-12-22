/* CreateDate: 10/03/2019 22:32:12.377 , ModifyDate: 10/03/2019 22:32:12.377 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSdel_dboFactAccounting]
		@pkc1 int,
		@pkc2 int,
		@pkc3 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[FactAccounting]
	where [CenterID] = @pkc1
  and [DateKey] = @pkc2
  and [AccountID] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[AccountID] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FactAccounting]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
