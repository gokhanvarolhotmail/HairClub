/* CreateDate: 05/05/2020 17:42:55.473 , ModifyDate: 05/05/2020 17:42:55.473 */
GO
create procedure [sp_MSins_dbomtnTREBebackExport]
    @c1 int,
    @c2 nvarchar(50),
    @c3 int,
    @c4 nvarchar(50),
    @c5 nvarchar(50),
    @c6 datetime,
    @c7 datetime,
    @c8 bit
as
begin
	insert into [dbo].[mtnTREBebackExport] (
		[TREBebackExportID],
		[ContactID],
		[CenterID],
		[Performer],
		[ResultCode],
		[CreateDate],
		[ProcessedDate],
		[IsProcessedFlag]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8	)
end
GO
