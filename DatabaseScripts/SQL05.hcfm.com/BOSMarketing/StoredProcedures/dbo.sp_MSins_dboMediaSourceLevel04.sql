/* CreateDate: 07/30/2015 15:49:41.913 , ModifyDate: 07/30/2015 15:49:41.913 */
GO
create procedure [sp_MSins_dboMediaSourceLevel04]
    @c1 int,
    @c2 varchar(50),
    @c3 varchar(50),
    @c4 smallint
as
begin
	insert into [dbo].[MediaSourceLevel04](
		[Level04ID],
		[Level04FormatCode],
		[Level04Format],
		[MediaID]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
