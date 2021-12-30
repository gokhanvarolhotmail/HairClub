/* CreateDate: 01/03/2018 16:31:36.433 , ModifyDate: 01/03/2018 16:31:36.433 */
GO
create procedure [dbo].[sp_MSdel_dbocstd_company_zip_code]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[cstd_company_zip_code]
where [company_zip_code_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
