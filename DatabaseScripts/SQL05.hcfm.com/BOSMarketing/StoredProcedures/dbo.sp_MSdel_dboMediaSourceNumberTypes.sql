/* CreateDate: 07/30/2015 15:49:42.050 , ModifyDate: 07/30/2015 15:49:42.050 */
GO
create procedure [sp_MSdel_dboMediaSourceNumberTypes]
		@pkc1 tinyint
as
begin
	delete [dbo].[MediaSourceNumberTypes]
where [NumberTypeID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
