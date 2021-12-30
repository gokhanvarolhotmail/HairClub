/* CreateDate: 01/03/2018 16:31:36.473 , ModifyDate: 01/03/2018 16:31:36.473 */
GO
create procedure [dbo].[sp_MSins_dbocstd_text_msg_temp]
    @c1 int,
    @c2 nchar(10),
    @c3 nchar(10),
    @c4 nchar(11),
    @c5 nchar(20),
    @c6 datetime,
    @c7 nchar(6),
    @c8 nchar(100),
    @c9 datetime,
    @c10 nchar(20)
as
begin
	insert into [dbo].[cstd_text_msg_temp](
		[temp_id],
		[contact_id],
		[appointment_activity_id],
		[phone],
		[created_by_user_code],
		[creation_date],
		[action],
		[status],
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
    @c10	)
end
GO
