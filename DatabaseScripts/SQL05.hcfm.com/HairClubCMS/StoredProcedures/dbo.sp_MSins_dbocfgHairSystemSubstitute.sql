/* CreateDate: 05/05/2020 17:42:44.057 , ModifyDate: 05/05/2020 17:42:44.057 */
GO
create procedure [sp_MSins_dbocfgHairSystemSubstitute]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 nvarchar(200),
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemSubstitute] (
		[HairSystemSubstituteID],
		[HairSystemID],
		[SubstituteHairSystemID],
		[Rank],
		[Comments],
		[IsActiveFlag],
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
		@c8,
		@c9,
		@c10,
		default	)
end
GO
