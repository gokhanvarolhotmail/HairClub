/* CreateDate: 07/30/2015 15:49:42.093 , ModifyDate: 07/30/2015 15:49:42.093 */
GO
create procedure [sp_MSdel_dboMediaSourcePhoneSourceAudit]
		@pkc1 int
as
begin
	delete [dbo].[MediaSourcePhoneSourceAudit]
where [AuditID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
