/* CreateDate: 07/30/2015 15:49:42.173 , ModifyDate: 07/30/2015 15:49:42.173 */
GO
create procedure [sp_MSdel_dboMediaSourceQwestOptions]
		@pkc1 smallint
as
begin
	delete [dbo].[MediaSourceQwestOptions]
where [QwestID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
