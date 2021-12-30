/* CreateDate: 01/03/2018 16:31:35.890 , ModifyDate: 01/03/2018 16:31:35.890 */
GO
create procedure [dbo].[sp_MSins_dbooncd_contact_email]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(10),
    @c4 nvarchar(100),
    @c5 nchar(50),
    @c6 nchar(1),
    @c7 int,
    @c8 datetime,
    @c9 nchar(20),
    @c10 datetime,
    @c11 nchar(20),
    @c12 nchar(1),
    @c13 nchar(1),
    @c14 nchar(20),
    @c15 nvarchar(18),
    @c16 nchar(1),
    @c17 nvarchar(50)
as
begin
	insert into [dbo].[oncd_contact_email](
		[contact_email_id],
		[contact_id],
		[email_type_code],
		[email],
		[description],
		[active],
		[sort_order],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code],
		[primary_flag],
		[cst_valid_flag],
		[cst_skip_trace_vendor_code],
		[cst_sfdc_leademail_id],
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
    @c17	)
end
GO
