/* CreateDate: 07/25/2018 13:07:36.190 , ModifyDate: 07/25/2018 13:07:36.190 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact_source]     @pkc1 nchar(10)
as
begin   	delete [dbo].[oncd_contact_source]
where [contact_source_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
