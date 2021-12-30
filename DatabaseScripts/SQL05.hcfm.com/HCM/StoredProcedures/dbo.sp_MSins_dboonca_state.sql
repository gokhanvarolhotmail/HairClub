/* CreateDate: 01/03/2018 16:31:35.183 , ModifyDate: 01/03/2018 16:31:35.183 */
GO
create procedure [dbo].[sp_MSins_dboonca_state]
    @c1 nchar(20),
    @c2 nchar(50),
    @c3 nchar(10),
    @c4 nchar(20),
    @c5 nchar(1)
as
begin
	insert into [dbo].[onca_state](
		[state_code],
		[description],
		[state_numeric_code],
		[country_code],
		[active]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	)
end
GO
