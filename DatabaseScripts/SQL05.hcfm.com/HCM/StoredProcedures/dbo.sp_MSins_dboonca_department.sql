/* CreateDate: 01/03/2018 16:31:33.560 , ModifyDate: 01/03/2018 16:31:33.560 */
GO
create procedure [dbo].[sp_MSins_dboonca_department]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1),
    @c4 nchar(1),
    @c5 nchar(1)
as
begin
	insert into [dbo].[onca_department](
		[department_code],
		[description],
		[active],
		[contact_department_flag],
		[user_department_flag]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	)
end
GO
