/* CreateDate: 01/03/2018 16:31:36.187 , ModifyDate: 01/03/2018 16:31:36.187 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact_territory]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_contact_territory]
where [contact_territory_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
