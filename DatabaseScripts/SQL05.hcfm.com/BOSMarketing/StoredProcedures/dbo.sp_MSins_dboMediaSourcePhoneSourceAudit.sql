/* CreateDate: 07/30/2015 15:49:42.077 , ModifyDate: 07/30/2015 15:49:42.077 */
GO
create procedure [sp_MSins_dboMediaSourcePhoneSourceAudit]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 smalldatetime
as
begin
	insert into [dbo].[MediaSourcePhoneSourceAudit](
		[AuditID],
		[PhoneID],
		[SourceID],
		[DateEntered]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
