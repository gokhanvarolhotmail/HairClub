/* CreateDate: 01/03/2018 16:31:30.307 , ModifyDate: 01/03/2018 16:31:30.307 */
GO
create procedure [dbo].[sp_MSins_dbocsta_activity_type]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[csta_activity_type](
		[activity_type_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
