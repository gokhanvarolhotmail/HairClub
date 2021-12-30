/* CreateDate: 01/03/2018 16:31:34.833 , ModifyDate: 01/03/2018 16:31:34.833 */
GO
create procedure [dbo].[sp_MSins_dboonca_contact_status]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1),
    @c4 nchar(1)
as
begin
	insert into [dbo].[onca_contact_status](
		[contact_status_code],
		[description],
		[active],
		[active_flag]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
