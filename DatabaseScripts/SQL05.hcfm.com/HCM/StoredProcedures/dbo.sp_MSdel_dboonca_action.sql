/* CreateDate: 07/25/2018 13:53:36.677 , ModifyDate: 07/25/2018 13:53:36.677 */
GO
create procedure [dbo].[sp_MSdel_dboonca_action]     @pkc1 nchar(10)
as
begin   	delete [dbo].[onca_action]
where [action_code] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
