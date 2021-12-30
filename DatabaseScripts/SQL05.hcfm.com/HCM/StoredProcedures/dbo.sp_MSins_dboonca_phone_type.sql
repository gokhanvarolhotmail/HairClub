/* CreateDate: 01/03/2018 16:31:35.980 , ModifyDate: 01/03/2018 16:31:35.980 */
GO
create procedure [sp_MSins_dboonca_phone_type]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1),
    @c4 nchar(1),
    @c5 nchar(10),
    @c6 nchar(1)
as
begin
	insert into [dbo].[onca_phone_type](
		[phone_type_code],
		[description],
		[active],
		[device_type],
		[cst_entity_code],
		[cst_is_cell_phone]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6	)
end
GO
