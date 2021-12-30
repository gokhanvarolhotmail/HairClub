/* CreateDate: 01/03/2018 16:31:36.367 , ModifyDate: 01/03/2018 16:31:36.367 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_activity_company]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_activity_company]
where [activity_company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
