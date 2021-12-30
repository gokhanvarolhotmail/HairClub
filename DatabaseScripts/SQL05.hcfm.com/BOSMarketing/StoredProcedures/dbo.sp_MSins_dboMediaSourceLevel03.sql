/* CreateDate: 07/30/2015 15:49:41.873 , ModifyDate: 07/30/2015 15:49:41.873 */
GO
create procedure [sp_MSins_dboMediaSourceLevel03]
    @c1 int,
    @c2 varchar(10),
    @c3 varchar(50),
    @c4 smallint
as
begin
	insert into [dbo].[MediaSourceLevel03](
		[Level03ID],
		[Level03LanguageCode],
		[Level03Language],
		[MediaID]
	) values (
    @c1,
    @c2,
    @c3,
    @c4	)
end
GO
