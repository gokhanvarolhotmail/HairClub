/* CreateDate: 01/03/2018 16:31:35.357 , ModifyDate: 01/03/2018 16:31:35.357 */
GO
create procedure [dbo].[sp_MSins_dboonca_territory]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[onca_territory](
		[territory_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
