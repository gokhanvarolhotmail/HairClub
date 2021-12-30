/* CreateDate: 01/03/2018 16:31:34.783 , ModifyDate: 01/03/2018 16:31:34.783 */
GO
create procedure [sp_MSins_dboonca_contact_method]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[onca_contact_method](
		[contact_method_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
