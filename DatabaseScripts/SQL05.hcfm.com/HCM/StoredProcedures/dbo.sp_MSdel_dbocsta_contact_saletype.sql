/* CreateDate: 01/03/2018 16:31:32.853 , ModifyDate: 01/03/2018 16:31:32.853 */
GO
create procedure [dbo].[sp_MSdel_dbocsta_contact_saletype]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[csta_contact_saletype]
where [saletype_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
