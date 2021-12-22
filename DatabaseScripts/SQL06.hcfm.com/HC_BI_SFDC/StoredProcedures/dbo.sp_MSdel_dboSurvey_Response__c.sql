/* CreateDate: 02/24/2020 09:00:10.740 , ModifyDate: 02/24/2020 09:00:10.740 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSdel_dboSurvey_Response__c]
		@pkc1 nvarchar(18)
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[Survey_Response__c]
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Survey_Response__c]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
