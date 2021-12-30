/* CreateDate: 07/25/2018 13:43:17.040 , ModifyDate: 07/25/2018 13:43:17.040 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_activity]     @pkc1 nchar(10)
as
begin   	delete [dbo].[oncd_activity]
where [activity_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
