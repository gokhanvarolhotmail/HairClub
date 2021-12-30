/* CreateDate: 01/03/2018 16:31:35.590 , ModifyDate: 01/03/2018 16:31:35.590 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_activity_user]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[oncd_activity_user]
where [activity_user_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
