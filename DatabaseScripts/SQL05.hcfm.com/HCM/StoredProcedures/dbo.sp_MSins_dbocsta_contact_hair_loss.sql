/* CreateDate: 01/03/2018 16:31:30.750 , ModifyDate: 01/03/2018 16:31:30.750 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_hair_loss]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[csta_contact_hair_loss](
		[hair_loss_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
