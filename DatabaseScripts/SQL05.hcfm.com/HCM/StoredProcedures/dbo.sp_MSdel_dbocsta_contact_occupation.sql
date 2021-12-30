/* CreateDate: 01/03/2018 16:31:32.320 , ModifyDate: 01/03/2018 16:31:32.320 */
GO
create procedure [dbo].[sp_MSdel_dbocsta_contact_occupation]
		@pkc1 char(10)
as
begin
	delete [dbo].[csta_contact_occupation]
where [occupation_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
