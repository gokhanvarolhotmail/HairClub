/* CreateDate: 01/03/2018 16:31:35.790 , ModifyDate: 01/03/2018 16:31:35.790 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact_address]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_contact_address]
where [contact_address_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
