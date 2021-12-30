/* CreateDate: 01/03/2018 16:31:35.530 , ModifyDate: 01/03/2018 16:31:35.530 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_activity_contact]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_activity_contact]
where [activity_contact_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
