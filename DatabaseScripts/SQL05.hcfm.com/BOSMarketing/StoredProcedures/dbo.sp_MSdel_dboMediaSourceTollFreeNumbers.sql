/* CreateDate: 07/30/2015 15:49:42.263 , ModifyDate: 07/30/2015 15:49:42.263 */
GO
create procedure [sp_MSdel_dboMediaSourceTollFreeNumbers]
		@pkc1 int
as
begin
	delete [dbo].[MediaSourceTollFreeNumbers]
where [NumberID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
