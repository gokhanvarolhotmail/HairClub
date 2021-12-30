/* CreateDate: 07/30/2015 15:49:41.830 , ModifyDate: 07/30/2015 15:49:41.830 */
GO
create procedure [sp_MSins_dboMediaSourceLevel02]
    @c1 smallint,
    @c2 varchar(10),
    @c3 varchar(50),
    @c4 smallint
as
begin
	insert into [dbo].[MediaSourceLevel02](
		[Level02ID],
		[Level02LocationCode],
		[Level02Location],
		[MediaID]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
