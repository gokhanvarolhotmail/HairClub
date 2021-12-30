/* CreateDate: 07/30/2015 15:49:42.157 , ModifyDate: 07/30/2015 15:49:42.157 */
GO
create procedure [sp_MSins_dboMediaSourceQwestOptions]
    @c1 smallint,
    @c2 char(50)
as
begin
	insert into [dbo].[MediaSourceQwestOptions](
		[QwestID],
		[Qwest]
	) values (
    @c1,
    @c2	)
end
GO
