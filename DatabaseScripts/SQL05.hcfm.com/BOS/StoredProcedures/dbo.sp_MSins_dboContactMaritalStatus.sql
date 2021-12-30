/* CreateDate: 08/05/2015 09:01:32.127 , ModifyDate: 08/05/2015 09:01:32.127 */
GO
create procedure [sp_MSins_dboContactMaritalStatus]
    @c1 varchar(10),
    @c2 varchar(50),
    @c3 int,
    @c4 int
as
begin
	insert into [dbo].[ContactMaritalStatus](
		[MaritalStatusCode],
		[Description],
		[Active],
		[SortOrder]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
