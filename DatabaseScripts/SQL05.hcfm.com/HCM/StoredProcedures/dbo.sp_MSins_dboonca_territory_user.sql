/* CreateDate: 01/03/2018 16:31:35.407 , ModifyDate: 01/03/2018 16:31:35.407 */
GO
create procedure [dbo].[sp_MSins_dboonca_territory_user]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(20),
    @c4 datetime,
    @c5 int,
    @c6 nchar(1)
as
begin
	insert into [dbo].[onca_territory_user](
		[territory_user_id],
		[territory_code],
		[user_code],
		[assignment_date],
		[sort_order],
		[active]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6	)
end
GO
