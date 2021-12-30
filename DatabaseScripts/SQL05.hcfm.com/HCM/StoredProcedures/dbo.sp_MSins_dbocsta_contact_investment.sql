/* CreateDate: 01/03/2018 16:31:31.187 , ModifyDate: 01/03/2018 16:31:31.187 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_investment]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 decimal(15,4),
    @c4 nchar(1),
    @c5 nchar(1)
as
begin
	insert into [dbo].[csta_contact_investment](
		[investment_code],
		[description],
		[price],
		[active],
		[extreme_flag]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	)
end
GO
