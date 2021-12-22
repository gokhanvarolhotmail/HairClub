/* CreateDate: 10/04/2019 14:09:30.483 , ModifyDate: 10/04/2019 14:09:30.483 */
GO
create procedure [sp_MSdel_dboSaleTypeCode__c]
		@pkc1 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[SaleTypeCode__c]
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[SaleTypeCode__c]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
