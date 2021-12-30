/* CreateDate: 08/05/2015 09:01:32.287 , ModifyDate: 08/05/2015 09:01:32.287 */
GO
create procedure [sp_MSins_dboNoSaleReasons]
    @c1 varchar(50),
    @c2 varchar(50),
    @c3 int,
    @c4 int
as
begin
	insert into [dbo].[NoSaleReasons](
		[ReasonCode],
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
