/* CreateDate: 01/03/2018 16:31:36.037 , ModifyDate: 01/03/2018 16:31:36.037 */
GO
create procedure [dbo].[sp_MSins_dbooncd_contact_phone]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(10),
    @c4 nchar(10),
    @c5 nchar(10),
    @c6 nchar(20),
    @c7 nchar(10),
    @c8 nchar(50),
    @c9 nchar(1),
    @c10 int,
    @c11 datetime,
    @c12 nchar(20),
    @c13 datetime,
    @c14 nchar(20),
    @c15 nchar(1),
    @c16 nchar(1),
    @c17 nchar(10),
    @c18 datetime,
    @c19 nchar(20),
    @c20 datetime,
    @c21 nchar(20),
    @c22 nvarchar(18),
    @c23 nchar(1),
    @c24 nvarchar(50)
as
begin
	insert into [dbo].[oncd_contact_phone](
		[contact_phone_id],
		[contact_id],
		[phone_type_code],
		[country_code_prefix],
		[area_code],
		[phone_number],
		[extension],
		[description],
		[active],
		[sort_order],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code],
		[primary_flag],
		[cst_valid_flag],
		[cst_dnc_code],
		[cst_last_dnc_date],
		[cst_phone_type_updated_by_user_code],
		[cst_phone_type_updated_date],
		[cst_skip_trace_vendor_code],
		[cst_sfdc_leadphone_id],
		[cst_do_not_export],
		[cst_import_note]
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
    @c16,
    @c17,
    @c18,
    @c19,
    @c20,
    @c21,
    @c22,
    @c23,
    @c24	)
end
GO