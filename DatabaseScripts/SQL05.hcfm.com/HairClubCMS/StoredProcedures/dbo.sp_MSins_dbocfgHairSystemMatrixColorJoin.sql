/* CreateDate: 05/05/2020 17:42:43.583 , ModifyDate: 05/05/2020 17:42:43.583 */
GO
create procedure [sp_MSins_dbocfgHairSystemMatrixColorJoin]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemMatrixColorJoin] (
		[HairSystemMatrixColorJoinID],
		[HairSystemID],
		[HairSystemMatrixColorID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		default	)
end
GO
