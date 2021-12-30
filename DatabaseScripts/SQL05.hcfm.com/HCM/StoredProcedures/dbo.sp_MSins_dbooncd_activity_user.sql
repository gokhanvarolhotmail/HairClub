/* CreateDate: 01/03/2018 16:31:35.573 , ModifyDate: 01/03/2018 16:31:35.573 */
GO
create procedure [dbo].[sp_MSins_dbooncd_activity_user]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(20),
    @c4 datetime,
    @c5 nchar(1),
    @c6 int,
    @c7 datetime,
    @c8 nchar(20),
    @c9 datetime,
    @c10 nchar(20),
    @c11 nchar(1)
as
begin
	insert into [dbo].[oncd_activity_user](
		[activity_user_id],
		[activity_id],
		[user_code],
		[assignment_date],
		[attendance],
		[sort_order],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code],
		[primary_flag]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8,
    @c9,
    @c10,
    @c11	)
end
GO
