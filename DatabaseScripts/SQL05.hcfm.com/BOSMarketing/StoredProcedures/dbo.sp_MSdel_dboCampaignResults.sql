/* CreateDate: 07/30/2015 15:49:41.807 , ModifyDate: 07/30/2015 15:49:41.807 */
GO
create procedure [sp_MSdel_dboCampaignResults]
		@pkc1 int
as
begin
	delete [dbo].[CampaignResults]
where [ResultsID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
