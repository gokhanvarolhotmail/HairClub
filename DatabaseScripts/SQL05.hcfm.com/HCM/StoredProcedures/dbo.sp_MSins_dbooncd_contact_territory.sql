/* CreateDate: 01/03/2018 16:31:36.167 , ModifyDate: 01/03/2018 16:31:36.167 */
GO
create procedure [dbo].[sp_MSins_dbooncd_contact_territory]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(10),
    @c4 int,
    @c5 datetime,
    @c6 nchar(20),
    @c7 datetime,
    @c8 nchar(20),
    @c9 nchar(1)
as
begin
	insert into [dbo].[oncd_contact_territory](
		[contact_territory_id],
		[contact_id],
		[territory_code],
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
    @c9	)
end
GO
