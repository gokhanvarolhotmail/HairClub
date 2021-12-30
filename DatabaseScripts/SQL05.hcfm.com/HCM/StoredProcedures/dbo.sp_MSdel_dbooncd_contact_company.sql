/* CreateDate: 01/03/2018 16:31:35.850 , ModifyDate: 01/03/2018 16:31:35.850 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact_company]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_contact_company]
where [contact_company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
