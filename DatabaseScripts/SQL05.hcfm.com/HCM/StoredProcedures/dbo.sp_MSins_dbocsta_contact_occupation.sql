/* CreateDate: 01/03/2018 16:31:32.197 , ModifyDate: 01/03/2018 16:31:32.197 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_occupation]
    @c1 char(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[csta_contact_occupation](
		[occupation_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
