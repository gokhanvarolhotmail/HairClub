/* CreateDate: 01/03/2018 16:31:35.720 , ModifyDate: 01/03/2018 16:31:35.720 */
GO
create procedure [sp_MSdel_dbooncd_company_address]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_company_address]
where [company_address_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
