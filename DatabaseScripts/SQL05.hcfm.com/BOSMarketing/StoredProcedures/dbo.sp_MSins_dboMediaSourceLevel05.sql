/* CreateDate: 07/30/2015 15:49:41.953 , ModifyDate: 07/30/2015 15:49:41.953 */
GO
create procedure [sp_MSins_dboMediaSourceLevel05]
    @c1 int,
    @c2 varchar(10),
    @c3 varchar(50)
as
begin
	insert into [dbo].[MediaSourceLevel05](
		[Level05ID],
		[Level05CreativeCode],
		[Level05Creative]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
