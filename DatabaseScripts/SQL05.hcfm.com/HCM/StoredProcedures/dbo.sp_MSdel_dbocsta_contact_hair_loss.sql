/* CreateDate: 01/03/2018 16:31:30.830 , ModifyDate: 01/03/2018 16:31:30.830 */
GO
create procedure [dbo].[sp_MSdel_dbocsta_contact_hair_loss]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[csta_contact_hair_loss]
where [hair_loss_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
