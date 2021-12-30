/* CreateDate: 08/05/2015 09:01:32.247 , ModifyDate: 08/05/2015 09:01:32.247 */
GO
create procedure [sp_MSins_dboContactSalesType]
    @c1 varchar(50),
    @c2 varchar(50),
    @c3 int,
    @c4 int,
    @c5 int
as
begin
	insert into [dbo].[ContactSalesType](
		[SalesTypeCode],
		[Description],
		[Active],
		[SortOrder],
		[MembershipID]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	)
end
GO
