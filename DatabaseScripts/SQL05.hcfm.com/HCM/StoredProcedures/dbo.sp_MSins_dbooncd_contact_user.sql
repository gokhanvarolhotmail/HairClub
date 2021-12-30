/* CreateDate: 01/03/2018 16:31:36.227 , ModifyDate: 01/03/2018 16:31:36.227 */
GO
create procedure [dbo].[sp_MSins_dbooncd_contact_user]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(20),
    @c4 nchar(10),
    @c5 nchar(1),
    @c6 int,
    @c7 datetime,
    @c8 datetime,
    @c9 nchar(20),
    @c10 datetime,
    @c11 nchar(20)
as
begin
	insert into [dbo].[oncd_contact_user](
		[contact_user_id],
		[contact_id],
		[user_code],
		[job_function_code],
		[primary_flag],
		[sort_order],
		[assignment_date],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code]
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
