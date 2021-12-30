/* CreateDate: 07/30/2015 15:49:41.890 , ModifyDate: 07/30/2015 15:49:41.890 */
GO
create procedure [sp_MSdel_dboMediaSourceLevel03]
		@pkc1 int
as
begin
	delete [dbo].[MediaSourceLevel03]
where [Level03ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
