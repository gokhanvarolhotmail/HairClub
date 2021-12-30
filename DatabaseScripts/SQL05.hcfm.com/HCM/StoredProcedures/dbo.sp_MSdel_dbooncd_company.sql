/* CreateDate: 01/03/2018 16:31:35.650 , ModifyDate: 01/03/2018 16:31:35.650 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_company]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_company]
where [company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
