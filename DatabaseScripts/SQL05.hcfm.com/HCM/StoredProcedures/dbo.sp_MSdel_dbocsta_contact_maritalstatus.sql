/* CreateDate: 01/03/2018 16:31:31.700 , ModifyDate: 01/03/2018 16:31:31.700 */
GO
create procedure [dbo].[sp_MSdel_dbocsta_contact_maritalstatus]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[csta_contact_maritalstatus]
where [maritalstatus_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
