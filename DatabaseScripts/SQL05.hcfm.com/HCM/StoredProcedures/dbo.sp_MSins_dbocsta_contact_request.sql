/* CreateDate: 01/03/2018 16:31:32.470 , ModifyDate: 01/03/2018 16:31:32.470 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_request]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[csta_contact_request](
		[request_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
