/* CreateDate: 01/03/2018 16:31:33.283 , ModifyDate: 01/03/2018 16:31:33.283 */
GO
create procedure [dbo].[sp_MSdel_dbocsta_contact_source]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[csta_contact_source]
where [contact_source_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
