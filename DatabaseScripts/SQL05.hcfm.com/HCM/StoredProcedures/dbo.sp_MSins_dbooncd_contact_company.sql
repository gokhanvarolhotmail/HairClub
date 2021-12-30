/* CreateDate: 01/03/2018 16:31:35.833 , ModifyDate: 01/03/2018 16:31:35.833 */
GO
create procedure [dbo].[sp_MSins_dbooncd_contact_company]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(10),
    @c4 nchar(10),
    @c5 nchar(50),
    @c6 int,
    @c7 nchar(10),
    @c8 datetime,
    @c9 nchar(20),
    @c10 datetime,
    @c11 nchar(20),
    @c12 nchar(1),
    @c13 nchar(50),
    @c14 nchar(10),
    @c15 nchar(10),
    @c16 nchar(1)
as
begin
	insert into [dbo].[oncd_contact_company](
		[contact_company_id],
		[contact_id],
		[company_id],
		[company_role_code],
		[description],
		[sort_order],
		[reports_to_contact_id],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code],
		[primary_flag],
		[title],
		[department_code],
		[internal_title_code],
		[cst_preferred_center_flag]
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
    @c11,
    @c12,
    @c13,
    @c14,
    @c15,
    @c16	)
end
GO
