/* CreateDate: 01/03/2018 16:31:32.577 , ModifyDate: 01/03/2018 16:31:32.577 */
GO
create procedure [dbo].[sp_MSdel_dbocsta_contact_request]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[csta_contact_request]
where [request_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
