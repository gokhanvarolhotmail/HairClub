/* CreateDate: 01/03/2018 16:31:35.260 , ModifyDate: 01/03/2018 16:31:35.260 */
GO
create procedure [dbo].[sp_MSdel_dboonca_time_zone]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[onca_time_zone]
where [time_zone_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
