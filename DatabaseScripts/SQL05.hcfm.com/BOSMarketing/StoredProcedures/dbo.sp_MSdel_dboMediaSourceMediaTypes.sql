/* CreateDate: 07/30/2015 15:49:42.010 , ModifyDate: 07/30/2015 15:49:42.010 */
GO
create procedure [sp_MSdel_dboMediaSourceMediaTypes]
		@pkc1 smallint
as
begin
	delete [dbo].[MediaSourceMediaTypes]
where [MediaID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
