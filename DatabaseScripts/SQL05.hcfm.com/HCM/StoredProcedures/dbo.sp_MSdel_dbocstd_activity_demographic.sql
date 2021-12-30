/* CreateDate: 01/03/2018 16:31:34.747 , ModifyDate: 01/03/2018 16:31:34.747 */
GO
create procedure [dbo].[sp_MSdel_dbocstd_activity_demographic]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[cstd_activity_demographic]
where [activity_demographic_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
