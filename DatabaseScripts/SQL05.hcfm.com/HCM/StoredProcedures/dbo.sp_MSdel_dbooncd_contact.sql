/* CreateDate: 10/12/2018 14:48:28.153 , ModifyDate: 10/12/2018 14:48:28.153 */
GO
create procedure [dbo].[sp_MSdel_dbooncd_contact]     @pkc1 nchar(10)
as
begin   	delete [dbo].[oncd_contact]
where [contact_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
