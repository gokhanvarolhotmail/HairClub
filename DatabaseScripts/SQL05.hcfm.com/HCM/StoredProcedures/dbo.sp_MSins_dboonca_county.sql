/* CreateDate: 01/03/2018 16:31:35.297 , ModifyDate: 01/03/2018 16:31:35.297 */
GO
create procedure [dbo].[sp_MSins_dboonca_county]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(20),
    @c4 nchar(10),
    @c5 nchar(1),
    @c6 nchar(60),
    @c7 nchar(1),
    @c8 int,
    @c9 decimal(15,4),
    @c10 int,
    @c11 int,
    @c12 int,
    @c13 nchar(20)
as
begin
	insert into [dbo].[onca_county](
		[county_code],
		[county_name],
		[state_code],
		[time_zone_code],
		[county_type],
		[county_seat],
		[name_type],
		[elevation],
		[persons_per_house],
		[population],
		[area],
		[households],
		[country_code]
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
    @c13	)
end
GO
