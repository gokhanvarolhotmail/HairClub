/* CreateDate: 01/03/2018 16:31:30.390 , ModifyDate: 01/03/2018 16:31:30.390 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_age_range]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1),
    @c4 int,
    @c5 int
as
begin
	insert into [dbo].[csta_contact_age_range](
		[age_range_code],
		[description],
		[active],
		[minimum_age],
		[maximum_age]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	)
end
GO
