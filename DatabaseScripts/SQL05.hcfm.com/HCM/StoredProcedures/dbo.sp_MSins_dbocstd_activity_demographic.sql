/* CreateDate: 01/03/2018 16:31:34.727 , ModifyDate: 01/03/2018 16:31:34.727 */
GO
create procedure [dbo].[sp_MSins_dbocstd_activity_demographic]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(1),
    @c4 datetime,
    @c5 char(10),
    @c6 nchar(10),
    @c7 nchar(10),
    @c8 nchar(50),
    @c9 nchar(50),
    @c10 int,
    @c11 datetime,
    @c12 nchar(20),
    @c13 datetime,
    @c14 nchar(20),
    @c15 varchar(50),
    @c16 money,
    @c17 varchar(100),
    @c18 varchar(200),
    @c19 nvarchar(1)
as
begin
	insert into [dbo].[cstd_activity_demographic](
		[activity_demographic_id],
		[activity_id],
		[gender],
		[birthday],
		[occupation_code],
		[ethnicity_code],
		[maritalstatus_code],
		[norwood],
		[ludwig],
		[age],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code],
		[performer],
		[price_quoted],
		[solution_offered],
		[no_sale_reason],
		[disc_style]
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
    @c19	)
end
GO
