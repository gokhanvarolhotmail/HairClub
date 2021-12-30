/* CreateDate: 01/03/2018 16:31:35.943 , ModifyDate: 01/03/2018 16:31:35.943 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact_email]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_contact_email]
where [contact_email_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
