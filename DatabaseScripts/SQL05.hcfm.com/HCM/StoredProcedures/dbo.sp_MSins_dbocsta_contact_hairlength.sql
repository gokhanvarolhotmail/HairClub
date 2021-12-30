/* CreateDate: 01/03/2018 16:31:30.943 , ModifyDate: 01/03/2018 16:31:30.943 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_hairlength]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 decimal(15,4),
    @c4 nchar(1)
as
begin
	insert into [dbo].[csta_contact_hairlength](
		[hairlength_code],
		[description],
		[price],
		[active]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
