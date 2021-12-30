/* CreateDate: 05/05/2020 17:42:44.383 , ModifyDate: 05/05/2020 17:42:44.383 */
GO
create procedure [sp_MSins_dbocfgHairSystemVendorRanking]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 int,
    @c12 int
as
begin
	insert into [dbo].[cfgHairSystemVendorRanking] (
		[HairSystemVendorRankingID],
		[HairSystemID],
		[Ranking1VendorID],
		[Ranking2VendorID],
		[Ranking3VendorID],
		[Ranking4VendorID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[Ranking5VendorID],
		[Ranking6VendorID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		default,
		@c11,
		@c12	)
end
GO
