/* CreateDate: 01/03/2018 16:31:36.057 , ModifyDate: 01/03/2018 16:31:36.057 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact_phone]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_contact_phone]
where [contact_phone_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
