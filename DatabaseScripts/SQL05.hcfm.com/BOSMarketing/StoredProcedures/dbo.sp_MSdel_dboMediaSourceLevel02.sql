/* CreateDate: 07/30/2015 15:49:41.850 , ModifyDate: 07/30/2015 15:49:41.850 */
GO
create procedure [sp_MSdel_dboMediaSourceLevel02]
		@pkc1 smallint
as
begin
	delete [dbo].[MediaSourceLevel02]
where [Level02ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
