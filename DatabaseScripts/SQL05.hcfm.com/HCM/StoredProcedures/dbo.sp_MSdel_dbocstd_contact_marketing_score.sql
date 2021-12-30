/* CreateDate: 01/03/2018 16:31:36.300 , ModifyDate: 01/03/2018 16:31:36.300 */
GO
create procedure [sp_MSdel_dbocstd_contact_marketing_score]
		@pkc1 uniqueidentifier
as
begin
	delete [dbo].[cstd_contact_marketing_score]
where [contact_marketing_score_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
