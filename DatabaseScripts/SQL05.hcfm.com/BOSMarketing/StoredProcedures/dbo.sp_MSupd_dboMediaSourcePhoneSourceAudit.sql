/* CreateDate: 07/30/2015 15:49:42.090 , ModifyDate: 07/30/2015 15:49:42.090 */
GO
create procedure [sp_MSupd_dboMediaSourcePhoneSourceAudit]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 smalldatetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourcePhoneSourceAudit] set
		[PhoneID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [PhoneID] end,
		[SourceID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SourceID] end,
		[DateEntered] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DateEntered] end
where [AuditID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
