/* CreateDate: 01/03/2018 16:31:35.240 , ModifyDate: 01/03/2018 16:31:35.240 */
GO
create procedure [dbo].[sp_MSins_dboonca_time_zone]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 float,
    @c4 nchar(20)
as
begin
	insert into [dbo].[onca_time_zone](
		[time_zone_code],
		[description],
		[greenwich_offset],
		[country_code]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
