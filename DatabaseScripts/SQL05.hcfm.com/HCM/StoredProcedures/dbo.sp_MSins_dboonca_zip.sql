/* CreateDate: 01/03/2018 16:31:35.463 , ModifyDate: 01/03/2018 16:31:35.463 */
GO
create procedure [dbo].[sp_MSins_dboonca_zip]
    @c1 nchar(10),
    @c2 nchar(20),
    @c3 nchar(60),
    @c4 nchar(20),
    @c5 nchar(20),
    @c6 nchar(1),
    @c7 nchar(10),
    @c8 decimal(15,4),
    @c9 decimal(15,4),
    @c10 nchar(10),
    @c11 nchar(6),
    @c12 nchar(1),
    @c13 nchar(1),
    @c14 nchar(4),
    @c15 nchar(4),
    @c16 nchar(50),
    @c17 nchar(1)
as
begin
	insert into [dbo].[onca_zip](
		[zip_id],
		[zip_code],
		[city],
		[country_code],
		[state_code],
		[zip_code_type],
		[county_code],
		[latitude],
		[longitude],
		[area_code],
		[finance_code],
		[last_line],
		[facility_code],
		[msa_code],
		[pmsa_code],
		[cst_dma],
		[cst_city_type]
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
