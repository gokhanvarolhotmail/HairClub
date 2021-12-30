/* CreateDate: 08/05/2015 09:01:32.227 , ModifyDate: 08/05/2015 09:01:32.227 */
GO
create procedure [sp_MSdel_dboContactOccupation]
		@pkc1 varchar(10)
as
begin
	delete [dbo].[ContactOccupation]
where [OccupationCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
