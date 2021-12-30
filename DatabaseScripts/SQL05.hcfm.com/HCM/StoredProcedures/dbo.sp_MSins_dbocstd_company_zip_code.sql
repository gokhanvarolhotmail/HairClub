/* CreateDate: 01/03/2018 16:31:36.413 , ModifyDate: 01/03/2018 16:31:36.413 */
GO
create procedure [dbo].[sp_MSins_dbocstd_company_zip_code]
    @c1 nchar(10),
    @c2 nchar(10),
    @c3 nchar(20),
    @c4 nchar(20),
    @c5 nchar(10),
    @c6 nchar(10),
    @c7 nchar(1),
    @c8 int,
    @c9 nchar(50),
    @c10 datetime,
    @c11 nchar(20),
    @c12 datetime,
    @c13 nchar(20)
as
begin
	insert into [dbo].[cstd_company_zip_code](
		[company_zip_code_id],
		[company_id],
		[zip_from],
		[zip_to],
		[type_code],
		[dma_code],
		[adi_flag],
		[sort_order],
		[county],
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
    @c11,
    @c12,
    @c13	)
end
GO
