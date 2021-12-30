/* CreateDate: 05/05/2020 17:42:43.720 , ModifyDate: 05/05/2020 17:42:43.720 */
GO
create procedure [sp_MSins_dbocfgHairSystemMembershipJoin]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemMembershipJoin] (
		[HairSystemMembershipJoinID],
		[HairSystemID],
		[MembershipID],
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
