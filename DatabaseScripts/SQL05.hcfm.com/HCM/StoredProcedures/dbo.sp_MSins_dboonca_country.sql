/* CreateDate: 01/03/2018 16:31:35.130 , ModifyDate: 01/03/2018 16:31:35.130 */
GO
create procedure [dbo].[sp_MSins_dboonca_country]
    @c1 nchar(20),
    @c2 nchar(100),
    @c3 nchar(10),
    @c4 nchar(1)
as
begin
	insert into [dbo].[onca_country](
		[country_code],
		[country_name],
		[country_code_prefix],
		[active]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
