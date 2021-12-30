/* CreateDate: 01/03/2018 16:31:34.800 , ModifyDate: 01/03/2018 16:31:34.800 */
GO
create procedure [sp_MSdel_dboonca_contact_method]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[onca_contact_method]
where [contact_method_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
