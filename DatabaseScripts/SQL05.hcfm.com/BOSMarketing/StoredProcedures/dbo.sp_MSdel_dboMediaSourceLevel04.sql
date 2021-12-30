/* CreateDate: 07/30/2015 15:49:41.930 , ModifyDate: 07/30/2015 15:49:41.930 */
GO
create procedure [sp_MSdel_dboMediaSourceLevel04]
		@pkc1 int
as
begin
	delete [dbo].[MediaSourceLevel04]
where [Level04ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
